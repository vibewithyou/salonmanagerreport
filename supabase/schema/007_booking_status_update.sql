-- Migration: Add status enum to bookings table
-- Only run if status is not already an enum with correct values

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'booking_status') THEN
    CREATE TYPE booking_status AS ENUM ('pending', 'accepted', 'declined', 'completed', 'cancelled');
  END IF;
END$$;

ALTER TABLE IF EXISTS public.bookings
  ALTER COLUMN status TYPE booking_status USING status::booking_status,
  ALTER COLUMN status SET DEFAULT 'pending';

-- Optionally, update existing values to valid enum values if needed
-- UPDATE public.bookings SET status = 'pending' WHERE status IS NULL;
