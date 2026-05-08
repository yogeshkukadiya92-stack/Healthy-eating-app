insert into storage.buckets (id, name, public)
values
  ('food-photos', 'food-photos', false),
  ('avatars', 'avatars', true),
  ('exports', 'exports', false)
on conflict (id) do nothing;

create policy "users read own food photos"
on storage.objects for select
using (bucket_id = 'food-photos' and auth.uid()::text = (storage.foldername(name))[1]);

create policy "users upload own food photos"
on storage.objects for insert
with check (bucket_id = 'food-photos' and auth.uid()::text = (storage.foldername(name))[1]);

create policy "users read own exports"
on storage.objects for select
using (bucket_id = 'exports' and auth.uid()::text = (storage.foldername(name))[1]);

create table public.export_jobs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  format text not null check (format in ('pdf', 'xlsx', 'csv')),
  status text not null default 'queued',
  file_path text,
  created_at timestamptz default now(),
  completed_at timestamptz
);

alter table public.export_jobs enable row level security;
create policy "export jobs owner access" on public.export_jobs for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
