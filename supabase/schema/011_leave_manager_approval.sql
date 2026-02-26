-- Migration: Manager Approval Workflow for leave_requests
-- Created: 2026-02-26

-- Ensure leave_requests table exists and is up-to-date
CREATE TABLE IF NOT EXISTS public.leave_requests (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  salon_id uuid NOT NULL,
  staff_id uuid NOT NULL,
  type TEXT NOT NULL CHECK (type IN ('vacation', 'sick', 'other')),
  start_at DATE NOT NULL,
  end_at DATE NOT NULL,
  reason TEXT,
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
  decided_by uuid,
  decided_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now()
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_leave_requests_salon_status ON public.leave_requests (salon_id, status);
CREATE INDEX IF NOT EXISTS idx_leave_requests_salon_staff_created ON public.leave_requests (salon_id, staff_id, created_at DESC);

-- Enable RLS
ALTER TABLE public.leave_requests ENABLE ROW LEVEL SECURITY;

-- Policies
DROP POLICY IF EXISTS leave_requests_select_own ON public.leave_requests;
CREATE POLICY leave_requests_select_own ON public.leave_requests
FOR SELECT
USING (staff_id = auth.uid());

DROP POLICY IF EXISTS leave_requests_insert_own ON public.leave_requests;
CREATE POLICY leave_requests_insert_own ON public.leave_requests
FOR INSERT
WITH CHECK (staff_id = auth.uid());

DROP POLICY IF EXISTS leave_requests_select_manager ON public.leave_requests;
CREATE POLICY leave_requests_select_manager ON public.leave_requests
FOR SELECT
USING (
  EXISTS (
    SELECT 1 FROM public.user_roles ur
    WHERE ur.user_id = auth.uid()
      AND ur.salon_id = leave_requests.salon_id
      AND ur.role IN ('owner', 'platform_admin', 'salon_owner', 'salon_manager')
  )
);

DROP POLICY IF EXISTS leave_requests_update_manager ON public.leave_requests;
CREATE POLICY leave_requests_update_manager ON public.leave_requests
FOR UPDATE
USING (
  EXISTS (
    SELECT 1 FROM public.user_roles ur
    WHERE ur.user_id = auth.uid()
      AND ur.salon_id = leave_requests.salon_id
      AND ur.role IN ('owner', 'platform_admin', 'salon_owner', 'salon_manager')
  )
)
WITH CHECK (
  EXISTS (
    SELECT 1 FROM public.user_roles ur
    WHERE ur.user_id = auth.uid()
      AND ur.salon_id = leave_requests.salon_id
      AND ur.role IN ('owner', 'platform_admin', 'salon_owner', 'salon_manager')
  )
);
