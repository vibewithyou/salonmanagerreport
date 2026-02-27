-- Aufgabe 12: CRM interne Notizen (staff-only)

CREATE TABLE IF NOT EXISTS public.customer_notes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  salon_id UUID NOT NULL REFERENCES public.salons(id) ON DELETE CASCADE,
  customer_id UUID NOT NULL REFERENCES public.customers(id) ON DELETE CASCADE,
  created_by UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  note TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_customer_notes_salon_id ON public.customer_notes(salon_id);
CREATE INDEX IF NOT EXISTS idx_customer_notes_customer_id ON public.customer_notes(customer_id);
CREATE INDEX IF NOT EXISTS idx_customer_notes_created_at ON public.customer_notes(created_at DESC);

ALTER TABLE public.customer_notes ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Staff can read customer notes"
  ON public.customer_notes FOR SELECT
  USING (
    EXISTS (
      SELECT 1
      FROM public.salons s
      WHERE s.id = customer_notes.salon_id
        AND s.owner_id = auth.uid()
    )
    OR EXISTS (
      SELECT 1
      FROM public.employees e
      WHERE e.salon_id = customer_notes.salon_id
        AND e.user_id = auth.uid()
    )
  );

CREATE POLICY "Staff can insert customer notes"
  ON public.customer_notes FOR INSERT
  WITH CHECK (
    created_by = auth.uid()
    AND (
      EXISTS (
        SELECT 1
        FROM public.salons s
        WHERE s.id = customer_notes.salon_id
          AND s.owner_id = auth.uid()
      )
      OR EXISTS (
        SELECT 1
        FROM public.employees e
        WHERE e.salon_id = customer_notes.salon_id
          AND e.user_id = auth.uid()
      )
    )
  );

CREATE POLICY "Staff can update customer notes"
  ON public.customer_notes FOR UPDATE
  USING (
    EXISTS (
      SELECT 1
      FROM public.salons s
      WHERE s.id = customer_notes.salon_id
        AND s.owner_id = auth.uid()
    )
    OR EXISTS (
      SELECT 1
      FROM public.employees e
      WHERE e.salon_id = customer_notes.salon_id
        AND e.user_id = auth.uid()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1
      FROM public.salons s
      WHERE s.id = customer_notes.salon_id
        AND s.owner_id = auth.uid()
    )
    OR EXISTS (
      SELECT 1
      FROM public.employees e
      WHERE e.salon_id = customer_notes.salon_id
        AND e.user_id = auth.uid()
    )
  );

CREATE POLICY "Staff can delete customer notes"
  ON public.customer_notes FOR DELETE
  USING (
    EXISTS (
      SELECT 1
      FROM public.salons s
      WHERE s.id = customer_notes.salon_id
        AND s.owner_id = auth.uid()
    )
    OR EXISTS (
      SELECT 1
      FROM public.employees e
      WHERE e.salon_id = customer_notes.salon_id
        AND e.user_id = auth.uid()
    )
  );
