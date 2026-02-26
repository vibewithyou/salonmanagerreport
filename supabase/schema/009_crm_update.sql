-- 009_crm_update.sql
-- Migration for CRM: customer_profiles and customer_notes

-- 1. Ensure customer_profiles table exists and has required columns
CREATE TABLE IF NOT EXISTS public.customer_profiles (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    salon_id uuid NOT NULL,
    user_id uuid,
    phone text,
    preferences_json jsonb,
    tags text[],
    created_at timestamptz DEFAULT now()
);

-- 2. Create customer_notes table
CREATE TABLE IF NOT EXISTS public.customer_notes (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    salon_id uuid NOT NULL,
    customer_id uuid NOT NULL REFERENCES public.customer_profiles(id) ON DELETE CASCADE,
    created_by uuid NOT NULL,
    note text NOT NULL,
    created_at timestamptz DEFAULT now()
);

-- 3. RLS policies
ALTER TABLE public.customer_notes ENABLE ROW LEVEL SECURITY;

-- Staff: salon-wide access
CREATE POLICY staff_can_access_notes ON public.customer_notes
    FOR SELECT USING (EXISTS (
        SELECT 1 FROM public.staff s WHERE s.user_id = auth.uid() AND s.salon_id = salon_id
    ));

-- Staff: can insert notes
CREATE POLICY staff_can_insert_notes ON public.customer_notes
    FOR INSERT WITH CHECK (EXISTS (
        SELECT 1 FROM public.staff s WHERE s.user_id = auth.uid() AND s.salon_id = salon_id
    ));

-- Customers: no access to notes
CREATE POLICY customer_no_access_notes ON public.customer_notes
    FOR SELECT USING (false);
