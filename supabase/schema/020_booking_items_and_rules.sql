-- 020_booking_items_and_rules.sql

CREATE TABLE IF NOT EXISTS public.booking_items (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    booking_id uuid NOT NULL REFERENCES public.bookings(id) ON DELETE CASCADE,
    service_id uuid NOT NULL REFERENCES public.services(id),
    duration_min integer NOT NULL,
    price numeric NOT NULL
);

CREATE TABLE IF NOT EXISTS public.salon_booking_rules (
    salon_id uuid PRIMARY KEY REFERENCES public.salons(id) ON DELETE CASCADE,
    slot_granularity_min integer NOT NULL DEFAULT 15,
    min_notice_min integer NOT NULL DEFAULT 60,
    closed_days_json jsonb NOT NULL DEFAULT '[]'
);

CREATE TABLE IF NOT EXISTS public.booking_media (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    booking_id uuid NOT NULL REFERENCES public.bookings(id) ON DELETE CASCADE,
    type text NOT NULL DEFAULT 'reference',
    url text NOT NULL,
    created_at timestamp with time zone NOT NULL DEFAULT now()
);


-- Enable RLS
ALTER TABLE public.booking_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.booking_media ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.salon_booking_rules ENABLE ROW LEVEL SECURITY;

-- Policy: Customers can insert booking_items for their own booking in salon scope
DROP POLICY IF EXISTS "customer_insert_booking_items" ON public.booking_items;
CREATE POLICY "customer_insert_booking_items"
    ON public.booking_items
    FOR INSERT
    WITH CHECK (
        booking_id IN (
            SELECT id FROM public.bookings WHERE customer_id = auth.uid()
        )
    );

-- Policy: Customers can insert booking_media for their own booking in salon scope
DROP POLICY IF EXISTS "customer_insert_booking_media" ON public.booking_media;
CREATE POLICY "customer_insert_booking_media"
    ON public.booking_media
    FOR INSERT
    WITH CHECK (
        booking_id IN (
            SELECT id FROM public.bookings WHERE customer_id = auth.uid()
        )
    );

-- Policy: Customers can view salon_booking_rules for their salon
DROP POLICY IF EXISTS "customer_view_salon_booking_rules" ON public.salon_booking_rules;
CREATE POLICY "customer_view_salon_booking_rules"
    ON public.salon_booking_rules
    FOR SELECT
    USING (
        salon_id IN (
            SELECT salon_id FROM public.customer_profiles WHERE user_id = auth.uid()
        )
    );
