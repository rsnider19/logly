create function public.popular_activities()
returns setof public.activity
stable
language sql
set search_path = ''
as $$
  select *
  from public.activity
  where activity_id in (
    '6e0d91f2-49dd-5018-896f-681a212cd475',
    '0b43c0a1-9849-5f47-b11e-2f2aed897e49',
    'c4fc9dfa-b272-5476-926d-524f4b19964f',
    '647223e3-ff67-597d-bea4-6b188ea08872',
    'a67e680e-460a-5941-9fa8-56bf5a2ebce6',
    'c9537d01-0d7c-53fa-a9ed-54781075a22d',
    '527e3c27-bdd5-5df6-8cee-2310ca802366',
    'f04fa7df-b8bc-5307-ab80-7295850e1981',
    '8e0dc783-93a1-57dc-b736-4094b4e11611',
    '60fb715e-7e98-5e08-9da6-04f7c182fd1f',
    '9f2bdd86-8380-5a79-a426-d0c0061b7aca',
    'cd2deb67-060b-513a-a584-5dc329b61681',
    'b9630dae-233d-52a8-ad5f-9eb3641e8e53',
    '8870faea-30d4-52db-9659-8c75a0ba9ce3',
    'c179cbf7-e7dc-5c61-b468-e3ad7563f2d9'
  );
$$;