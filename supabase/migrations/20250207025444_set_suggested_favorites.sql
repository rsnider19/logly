alter table activity add column is_suggested_favorite boolean default false;

update activity
set is_suggested_favorite = true
where activity_code in (
  'walk',
  'run',
  'cycling',
  'weight_lifting',
  'strength_training',
  'yoga',
  'hiit',
  'elliptical',
  'swim',
  'hiking'
);
