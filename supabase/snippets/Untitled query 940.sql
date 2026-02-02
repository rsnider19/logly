select date_trunc('month', activity_date), ac.name, count(1)
from user_activity ua
  join activity a using (activity_id)
  join activity_category ac using (activity_category_id)
where user_id <> uuid_nil()
  and ac.name = 'Workouts'
group by date_trunc('month', activity_date), ac.activity_category_id
order by 1 desc