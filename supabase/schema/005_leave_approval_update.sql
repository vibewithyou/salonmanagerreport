-- Migration: Add/Update leave_requests table for manager approval workflow
-- Created: 2026-02-26


ALTER TABLE public.leave_requests
  ADD COLUMN IF NOT EXISTS decided_by uuid,
  ADD COLUMN IF NOT EXISTS decided_at timestamptz,
  ADD COLUMN IF NOT EXISTS manager_comment text;

-- Rename columns for consistency if needed (optional, comment out if not needed)
-- ALTER TABLE public.leave_requests RENAME COLUMN employee_id TO staff_id;
-- ALTER TABLE public.leave_requests RENAME COLUMN approved_by TO decided_by;
-- ALTER TABLE public.leave_requests RENAME COLUMN start_at TO start_date;
-- ALTER TABLE public.leave_requests RENAME COLUMN type TO leave_type;

-- Add missing columns if not present
ALTER TABLE public.leave_requests
  ADD COLUMN IF NOT EXISTS salon_id uuid,
  ADD COLUMN IF NOT EXISTS staff_id uuid,
  ADD COLUMN IF NOT EXISTS start_date date,
  ADD COLUMN IF NOT EXISTS end_date date,
  ADD COLUMN IF NOT EXISTS reason text,
  ADD COLUMN IF NOT EXISTS status text DEFAULT 'pending',
  ADD COLUMN IF NOT EXISTS created_at timestamptz DEFAULT now();

-- Ensure status enum values
ALTER TABLE public.leave_requests
  ALTER COLUMN status SET DEFAULT 'pending';

-- RLS Policies (already present, but ensure up-to-date)
-- staff: SELECT/INSERT own
-- manager/owner: SELECT/UPDATE salon-wide
-- (see 002_leave_requests.sql for full policy definitions)
