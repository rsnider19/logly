-- For vector operations
create extension if not exists vector with schema extensions;

-- For queueing and processing jobs
-- (pgmq will create its own schema)
create extension if not exists pgmq;

-- For async HTTP requests
create extension if not exists pg_net with schema extensions;

-- For scheduled processing and retries
-- (pg_cron will create its own schema)
create extension if not exists pg_cron;

-- For clearing embeddings during updates
create extension if not exists hstore with schema extensions;
       
-- Schema for utility functions
create schema util;

-- Utility function to get the Supabase project URL (required for Edge Functions)
create or replace function util.project_url()
  returns text
  language plpgsql
security definer
as $$
declare
  secret_value text;
begin
  -- Retrieve the project URL from Vault
  select decrypted_secret into secret_value from vault.decrypted_secrets where name = 'project-url';
  return secret_value;
end;
$$;

-- Utility function to get the Supabase project URL (required for Edge Functions)
create or replace function util.service_role_key()
returns text
language plpgsql
security definer
as $$
declare
  secret_value text;
begin
  -- Retrieve the project URL from Vault
  select decrypted_secret into secret_value from vault.decrypted_secrets where name = 'service-role-key';
  return secret_value;
end;
$$;

-- Generic trigger function to clear a column on update
create or replace function util.clear_column()
returns trigger
language plpgsql as $$
declare
clear_column text := TG_ARGV[0];
begin
    NEW := NEW #= hstore(clear_column, NULL);
return NEW;
end;
$$;

-- Queue for processing embedding jobs
select pgmq.create('embedding_jobs');

-- Generic trigger function to queue embedding jobs
create or replace function util.queue_embeddings()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  content_function text = TG_ARGV[0];
  embedding_column text = TG_ARGV[1];
  pk_column text := TG_TABLE_NAME || '_id';
  pk_uuid uuid = TG_ARGV[2];
begin
  execute format('select ($1).%I', pk_column) into pk_uuid using new;

  perform pgmq.send(
    queue_name => 'embedding_jobs',
    msg => jsonb_build_object(
      'id', pk_uuid,
      'schema', TG_TABLE_SCHEMA,
      'table', TG_TABLE_NAME,
      'contentFunction', content_function,
      'embeddingColumn', embedding_column
    )
  );
return NEW;
end;
$$;

-- Function to process embedding jobs from the queue
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

-- Schedule the embedding processing
select
  cron.schedule(
    'process-embeddings',
    '10 seconds',
  $$
    select util.process_embeddings();
  $$
);
