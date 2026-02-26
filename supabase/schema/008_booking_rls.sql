-- RLS for bookings: stylist can update own, manager can update salonwide

ALTER TABLE public.bookings ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "bookings_update_own_stylist" ON public.bookings;
CREATE POLICY "bookings_update_own_stylist"
  ON public.bookings
  FOR UPDATE
  USING (
    auth.role() = 'stylist' AND stylist_id = auth.uid()
  );

DROP POLICY IF EXISTS "bookings_update_manager" ON public.bookings;
CREATE POLICY "bookings_update_manager"
  ON public.bookings
  FOR UPDATE
  USING (
    auth.role() = 'manager' AND salon_id IN (SELECT salon_id FROM employees WHERE user_id = auth.uid())
  );
