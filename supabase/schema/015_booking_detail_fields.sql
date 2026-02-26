-- booking_media table for appointment reference images
CREATE TABLE IF NOT EXISTS booking_media (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    booking_id UUID NOT NULL REFERENCES bookings(id) ON DELETE CASCADE,
    type TEXT CHECK (type IN ('reference', 'before', 'after')) NOT NULL,
    url TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL
);

-- Index for fast lookup
CREATE INDEX IF NOT EXISTS idx_booking_media_booking_id ON booking_media(booking_id);

-- RLS policies (example, adjust for Supabase):
-- Only stylist can see their bookings
CREATE POLICY select_stylist ON booking_media
    FOR SELECT USING (EXISTS (SELECT 1 FROM bookings WHERE bookings.id = booking_media.booking_id AND bookings.stylist_id = auth.uid()));
-- Only customer can see their own bookings
CREATE POLICY select_customer ON booking_media
    FOR SELECT USING (EXISTS (SELECT 1 FROM bookings WHERE bookings.id = booking_media.booking_id AND bookings.customer_id = auth.uid()));
-- Manager can see all for their salon
CREATE POLICY select_manager ON booking_media
    FOR SELECT USING (EXISTS (SELECT 1 FROM bookings WHERE bookings.id = booking_media.booking_id AND bookings.salon_id = auth.uid()));
