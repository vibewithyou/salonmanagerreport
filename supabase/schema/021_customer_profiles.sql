-- 021_customer_profiles.sql
CREATE TABLE IF NOT EXISTS customer_profiles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    salon_id UUID NOT NULL,
    customer_id UUID NOT NULL,
    phone TEXT,
    preferences_json JSONB DEFAULT '{}'::jsonb,
    tags TEXT[] DEFAULT '{}',
    created_at TIMESTAMP DEFAULT now()
);

-- RLS policies
-- Staff can select salonwide
CREATE POLICY select_customer_profiles_staff ON customer_profiles
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM staff WHERE staff.salon_id = customer_profiles.salon_id AND staff.user_id = auth.uid()
        )
    );

-- Customer can select own record only
CREATE POLICY select_customer_profiles_customer ON customer_profiles
    FOR SELECT USING (
        customer_id = auth.uid()
    );

ALTER TABLE customer_profiles ENABLE ROW LEVEL SECURITY;

-- Indexes
CREATE INDEX IF NOT EXISTS idx_customer_profiles_salon_id ON customer_profiles(salon_id);
CREATE INDEX IF NOT EXISTS idx_customer_profiles_customer_id ON customer_profiles(customer_id);