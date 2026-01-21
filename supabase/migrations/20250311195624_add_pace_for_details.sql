alter table activity_detail add column use_for_pace_calculation boolean not null default false;

create or replace function check_activity_detail_type()
returns trigger as $$
begin
  -- check for 'distance' type
  if new.activity_detail_type = 'distance' then
    if exists (
      select 1
      from activity_detail
      where activity_id = new.activity_id
        and activity_detail_type = 'distance'
        and activity_detail_id <> new.activity_detail_id
    ) then
      raise exception 'an activity can only have one detail of type distance';
    end if;
  end if;

  -- check for 'duration' type
  if new.activity_detail_type = 'duration' then
    if exists (
      select 1
      from activity_detail
      where activity_id = new.activity_id
        and activity_detail_type = 'duration'
        and activity_detail_id <> new.activity_detail_id
    ) then
      raise exception 'an activity can only have one detail of type duration';
    end if;
  end if;

  return new;
end;
$$ language plpgsql;

create trigger check_activity_detail_type_trigger
before insert or update on activity_detail
for each row
execute function check_activity_detail_type();

