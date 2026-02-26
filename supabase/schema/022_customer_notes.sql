-- 022_customer_notes.sql
-- Staff-only customer notes

CREATE TABLE customer_notes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    salon_id UUID NOT NULL,
    customer_id UUID NOT NULL,
    created_by UUID NOT NULL,
    note TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Row Level Security
ALTER TABLE customer_notes ENABLE ROW LEVEL SECURITY;

-- Staff: salonwide select/insert/update/delete
CREATE POLICY "staff_can_manage_notes" ON customer_notes
    FOR ALL
    USING (
        EXISTS (
            SELECT 1 FROM staff
            WHERE staff.id = auth.uid()
            AND staff.salon_id = customer_notes.salon_id
        )
    );

-- Customer: no access
CREATE POLICY "customer_no_access_notes" ON customer_notes
    FOR ALL
    USING (false);

-- Grant access to staff only
-- (Assumes staff table and auth.uid() setup)
