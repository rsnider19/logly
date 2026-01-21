create or replace function util.service_role_key()
returns text
language plpgsql
security definer
as $$
declare
secret_value text;
begin
  -- Retrieve the project URL from Vault
select decrypted_secret into secret_value from vault.decrypted_secrets where name = 'sb-secret';
return secret_value;
end;
$$;

create or replace function util.process_embeddings(
  batch_size int = 10,
  max_requests int = 10,
  timeout_milliseconds int = 5 * 60 * 1000 -- default 5 minute timeout
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
job_batches jsonb[];
  batch jsonb;
begin
with
  -- First get jobs and assign batch numbers
  numbered_jobs as (
    select
      message || jsonb_build_object('jobId', msg_id) as job_info,
      (row_number() over (order by 1) - 1) / batch_size as batch_num
    from pgmq.read(
      queue_name => 'embedding_jobs',
      vt => timeout_milliseconds / 1000,
      qty => max_requests * batch_size
     )
  ),
  -- Then group jobs into batches
  batched_jobs as (
    select
      jsonb_agg(job_info) as batch_array,
      batch_num
    from numbered_jobs
    group by batch_num
  )
-- Finally aggregate all batches into array
select array_agg(batch_array)
from batched_jobs
  into job_batches;

-- Invoke the embed edge function for each batch
foreach batch in array coalesce(job_batches, '{}') loop
  perform net.http_post(
    url => util.project_url() || '/functions/v1/embed',
    headers => jsonb_build_object(
      'Content-Type', 'application/json',
      'x-sb-secret', util.service_role_key()
    ),
    body => batch,
    timeout_milliseconds => timeout_milliseconds
  );
end loop;
end;
$$;
