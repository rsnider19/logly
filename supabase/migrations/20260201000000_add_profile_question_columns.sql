ALTER TABLE public.profile
ADD COLUMN gender text,
ADD COLUMN date_of_birth date,
ADD COLUMN motivations jsonb,
ADD COLUMN progress_preferences jsonb,
ADD COLUMN user_descriptors jsonb;
