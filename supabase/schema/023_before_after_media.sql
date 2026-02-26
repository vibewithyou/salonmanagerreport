-- 023_before_after_media.sql
-- Create before_after_media table for booking media uploads
CREATE TABLE IF NOT EXISTS before_after_media (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    booking_id UUID NOT NULL REFERENCES bookings(id) ON DELETE CASCADE,
    customer_id UUID NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
    media_type VARCHAR(20) NOT NULL CHECK (media_type IN ('before', 'after')),
    url TEXT NOT NULL,
    uploaded_at TIMESTAMP DEFAULT NOW(),
    uploaded_by UUID REFERENCES employees(id)
);

-- Index for fast lookup by booking
CREATE INDEX IF NOT EXISTS idx_before_after_media_booking_id ON before_after_media(booking_id);
-- Index for fast lookup by customer
CREATE INDEX IF NOT EXISTS idx_before_after_media_customer_id ON before_after_media(customer_id);