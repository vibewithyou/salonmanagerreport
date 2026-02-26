-- Migration for Manager Shift Editor
-- Adds constraint, index, and ensures RLS for shifts table

-- Constraint: end_at > start_at
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.table_constraints
    WHERE table_name = 'shifts' AND constraint_name = 'shifts_end_after_start') THEN
    ALTER TABLE public.shifts
      ADD CONSTRAINT shifts_end_after_start CHECK (end_at > start_at);
  END IF;
END $$;

-- Index (already exists, but ensure)
CREATE INDEX IF NOT EXISTS idx_shifts_salon_staff_start
  ON public.shifts (salon_id, staff_id, start_at ASC);

-- Ensure RLS is enabled
ALTER TABLE public.shifts ENABLE ROW LEVEL SECURITY;

-- Policies (already present, but ensure)
-- Staff can SELECT own shifts
-- Manager/Owner can CRUD within salon_id
-- See 003_shifts.sql for full policy definitions

-- No mock data. All shifts must be managed via UI/API.

-- If further changes needed, update this migration.
