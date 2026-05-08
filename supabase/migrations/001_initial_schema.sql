create extension if not exists "pgcrypto";
create extension if not exists "vector";

create type meal_type as enum ('breakfast', 'lunch', 'dinner', 'snack');
create type subscription_status as enum ('free', 'trialing', 'active', 'past_due', 'canceled');

create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  name text,
  email text unique,
  avatar_url text,
  gender text,
  age int check (age between 10 and 120),
  height_cm numeric(5,2),
  current_weight_kg numeric(5,2),
  target_weight_kg numeric(5,2),
  calorie_goal int default 2000,
  protein_goal int default 120,
  carb_goal int default 220,
  fat_goal int default 70,
  water_goal_ml int default 3000,
  diet_type text default 'indian',
  activity_level text default 'moderate',
  theme_preference text default 'system',
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create table public.foods (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  brand text,
  category text,
  cuisine text,
  serving_size text default '100 g',
  calories numeric not null,
  protein numeric default 0,
  carbs numeric default 0,
  fat numeric default 0,
  fiber numeric default 0,
  sugar numeric default 0,
  sodium_mg numeric default 0,
  barcode text unique,
  image_url text,
  verified boolean default false,
  search_vector tsvector generated always as (
    setweight(to_tsvector('english', coalesce(name, '')), 'A') ||
    setweight(to_tsvector('english', coalesce(brand, '')), 'B') ||
    setweight(to_tsvector('english', coalesce(cuisine, '')), 'C')
  ) stored,
  created_at timestamptz default now()
);

create index foods_search_idx on public.foods using gin(search_vector);
create index foods_barcode_idx on public.foods(barcode);

create table public.meals (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  meal_type meal_type not null,
  logged_at timestamptz not null default now(),
  total_calories numeric default 0,
  total_protein numeric default 0,
  total_carbs numeric default 0,
  total_fat numeric default 0,
  created_at timestamptz default now()
);

create table public.meal_items (
  id uuid primary key default gen_random_uuid(),
  meal_id uuid not null references public.meals(id) on delete cascade,
  food_id uuid references public.foods(id),
  food_name text not null,
  quantity numeric not null,
  unit text default 'g',
  calories numeric not null,
  protein numeric default 0,
  carbs numeric default 0,
  fat numeric default 0,
  fiber numeric default 0,
  image_url text,
  ai_confidence numeric,
  created_at timestamptz default now()
);

create table public.water_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  amount int not null check (amount > 0),
  date timestamptz not null default now()
);

create table public.weight_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  weight numeric not null,
  body_fat numeric,
  muscle_mass numeric,
  date timestamptz not null default now()
);

create table public.notifications (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  title text not null,
  body text not null,
  kind text not null default 'reminder',
  sent_at timestamptz,
  read_at timestamptz,
  created_at timestamptz default now()
);

create table public.subscriptions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  revenuecat_customer_id text,
  plan text default 'free',
  status subscription_status default 'free',
  renewal_date timestamptz,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create table public.ai_food_analyses (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  image_url text,
  provider text not null default 'openai',
  detected_items jsonb not null default '[]'::jsonb,
  corrections jsonb not null default '{}'::jsonb,
  confidence numeric,
  created_at timestamptz default now()
);

create table public.achievements (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  code text not null,
  title text not null,
  earned_at timestamptz default now(),
  unique(user_id, code)
);

alter table public.profiles enable row level security;
alter table public.meals enable row level security;
alter table public.meal_items enable row level security;
alter table public.water_logs enable row level security;
alter table public.weight_logs enable row level security;
alter table public.notifications enable row level security;
alter table public.subscriptions enable row level security;
alter table public.ai_food_analyses enable row level security;
alter table public.achievements enable row level security;

create policy "profiles owner access" on public.profiles for all using (auth.uid() = id) with check (auth.uid() = id);
create policy "foods readable" on public.foods for select using (true);
create policy "meals owner access" on public.meals for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "meal items owner access" on public.meal_items for all using (
  exists (select 1 from public.meals where meals.id = meal_items.meal_id and meals.user_id = auth.uid())
) with check (
  exists (select 1 from public.meals where meals.id = meal_items.meal_id and meals.user_id = auth.uid())
);
create policy "water owner access" on public.water_logs for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "weight owner access" on public.weight_logs for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "notifications owner access" on public.notifications for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "subscriptions owner access" on public.subscriptions for select using (auth.uid() = user_id);
create policy "ai owner access" on public.ai_food_analyses for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "achievements owner access" on public.achievements for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

insert into public.foods (name, category, cuisine, calories, protein, carbs, fat, fiber, sodium_mg, verified) values
('Gujarati dal', 'homemade', 'Gujarati', 90, 4, 13, 2.5, 2, 280, true),
('Rotli', 'homemade', 'Gujarati', 105, 3, 21, 1.5, 3, 120, true),
('Paneer bhurji', 'high protein', 'Indian', 210, 16, 7, 14, 2, 420, true),
('Khichdi', 'vegetarian', 'Indian', 125, 5, 22, 2, 3, 260, true),
('Whey protein shake', 'protein', 'International', 120, 24, 3, 2, 0, 90, true);
