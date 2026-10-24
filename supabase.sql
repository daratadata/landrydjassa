-- LandryDjassa : à coller dans Supabase > SQL Editor > Run
create table if not exists profiles(id uuid primary key references auth.users on delete cascade,name text,phone text unique,role text not null default 'client',created_at timestamptz default now());
create table if not exists products(id uuid primary key default gen_random_uuid(),name text not null,type text not null,price integer not null,image_url text,active boolean default true,created_at timestamptz default now());
create table if not exists orders(id uuid primary key default gen_random_uuid(),ref text,user_id uuid default auth.uid() references auth.users,name text,phone text,address text,note text,items jsonb,total integer,status text default 'Nouvelle',created_at timestamptz default now());

create or replace function is_admin() returns boolean language sql security definer set search_path=public as $$ select exists(select 1 from profiles where id=auth.uid() and role='admin') $$;
create or replace function handle_new_user() returns trigger language plpgsql security definer set search_path=public as $$ begin insert into profiles(id,name,phone) values(new.id,new.raw_user_meta_data->>'name',new.raw_user_meta_data->>'phone'); return new; end $$;
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created after insert on auth.users for each row execute function handle_new_user();

alter table profiles enable row level security;alter table products enable row level security;alter table orders enable row level security;
create policy "profil: voir le sien ou admin" on profiles for select using(id=auth.uid() or is_admin());
create policy "produits: lecture publique" on products for select using(true);
create policy "produits: admin écrit" on products for all using(is_admin()) with check(is_admin());
create policy "commandes: voir les siennes ou admin" on orders for select using(user_id=auth.uid() or is_admin());
create policy "commandes: créer la sienne" on orders for insert with check(user_id=auth.uid());
create policy "commandes: admin modifie" on orders for update using(is_admin());
create policy "commandes: admin supprime" on orders for delete using(is_admin());

insert into storage.buckets(id,name,public) values('produits','produits',true) on conflict do nothing;
create policy "images: lecture publique" on storage.objects for select using(bucket_id='produits');
create policy "images: admin envoie" on storage.objects for insert with check(bucket_id='produits' and is_admin());
create policy "images: admin modifie" on storage.objects for update using(bucket_id='produits' and is_admin());
create policy "images: admin supprime" on storage.objects for delete using(bucket_id='produits' and is_admin());

insert into products(name,type,price) values('Polo bleu classique','T-shirt',8000),('Sneakers confort','Chaussures',18000),('Sac à main cuir','Sacs',15000),('Montre bracelet cuir','Montres',22000);

-- ÉTAPE FINALE (après avoir créé votre compte sur le site) : remplacez le numéro par le vôtre
-- update profiles set role='admin' where phone='0789515505';
