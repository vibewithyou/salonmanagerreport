-- Booking Status Enum/Constraint & RLS

-- 1. Enum für Status
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'booking_status') THEN
        CREATE TYPE booking_status AS ENUM ('pending', 'accepted', 'declined', 'cancelled', 'completed', 'reschedule_proposed');
    END IF;
END$$;

-- 2. Felder decided_by, decided_at
ALTER TABLE bookings ADD COLUMN IF NOT EXISTS decided_by uuid;
ALTER TABLE bookings ADD COLUMN IF NOT EXISTS decided_at timestamp with time zone;

-- 3. Constraint für Status
ALTER TABLE bookings
    ALTER COLUMN status TYPE booking_status USING status::booking_status,
    ALTER COLUMN status SET DEFAULT 'pending';

-- 4. RLS: Stylist/Manager
-- Stylist: UPDATE nur eigene Bookings und salon match
CREATE POLICY stylist_update_booking ON bookings
    FOR UPDATE
    USING (
        stylist_id = auth.uid() AND salon_id = current_setting('salon.id', true)::uuid
    );

-- Manager: UPDATE salonwide
CREATE POLICY manager_update_booking ON bookings
    FOR UPDATE
    USING (
        EXISTS (SELECT 1 FROM employees WHERE id = auth.uid() AND role = 'manager' AND salon_id = bookings.salon_id)
    );

-- Enable RLS
ALTER TABLE bookings ENABLE ROW LEVEL SECURITY;

-- Hinweis: Policy-Namen und Bedingungen ggf. anpassen je nach Supabase-Setup.
