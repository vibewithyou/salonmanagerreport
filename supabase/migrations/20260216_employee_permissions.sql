-- Migration: 20260216_employee_permissions
-- Purpose: Store per-employee module permissions

CREATE TABLE IF NOT EXISTS public.employee_permissions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  salon_id UUID NOT NULL REFERENCES public.salons(id) ON DELETE CASCADE,
  employee_id UUID NOT NULL REFERENCES public.employees(id) ON DELETE CASCADE,
  module_type TEXT NOT NULL,
  permissions TEXT[] NOT NULL DEFAULT ARRAY['view'],
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  UNIQUE(employee_id, module_type)
);

CREATE INDEX idx_employee_permissions_salon_id ON public.employee_permissions(salon_id);
CREATE INDEX idx_employee_permissions_employee_id ON public.employee_permissions(employee_id);
CREATE INDEX idx_employee_permissions_module_type ON public.employee_permissions(module_type);

ALTER TABLE public.employee_permissions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Salon admins can manage employee permissions"
  ON public.employee_permissions FOR ALL
  USING (
    salon_id IN (
      SELECT id FROM public.salons
      WHERE owner_id = AUTH.UID()
    )
  );

CREATE POLICY "Employees can view own permissions"
  ON public.employee_permissions FOR SELECT
  USING (
    employee_id IN (
      SELECT id FROM public.employees
      WHERE user_id = AUTH.UID()
    )
  );
