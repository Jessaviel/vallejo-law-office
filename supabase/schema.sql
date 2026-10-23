-- STARTER ONLY — NOT READY FOR PRODUCTION
-- Run only after creating a Supabase project and reviewing security policies.
-- Do not store uploaded files in public buckets.
-- This schema deliberately does not enable anonymous public reads.

create extension if not exists pgcrypto;

create table if not exists public.document_requests (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  client_full_name text not null,
  client_phone text not null,
  client_email text,
  document_type text not null,
  purpose text not null,
  additional_notes text,
  preferred_date date,
  preferred_time text,
  status text not null default 'For initial review'
    check (status in (
      'For initial review',
      'Requirements incomplete',
      'For attorney review',
      'Draft in preparation',
      'Ready for signing',
      'Appointment scheduled',
      'Completed',
      'Declined'
    )),
  assigned_staff uuid references auth.users(id),
  internal_notes text
);

alter table public.document_requests enable row level security;

-- IMPORTANT:
-- No policies are intentionally created here. That means browser access is denied
-- until reviewed, role-aware policies are added. Do NOT solve this by allowing
-- anonymous users to read all rows or by making the table public.
-- Production implementation should use a server-side submission endpoint or
-- carefully designed insert-only access, staff roles, audit logging, and tests.
