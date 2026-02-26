-- Enable Row Level Security
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

-- Policy: User can view only their own notifications
CREATE POLICY "Users can view their notifications" ON notifications
    FOR SELECT USING (auth.uid() = user_id);

-- Policy: User can update read_at only for their notifications
CREATE POLICY "Users can mark their notifications as read" ON notifications
    FOR UPDATE USING (
        auth.uid() = user_id AND
        (read_at IS NULL OR read_at IS NOT NULL)
    )
    WITH CHECK (auth.uid() = user_id);

-- Policy: Only service roles can insert/delete
CREATE POLICY "Service role can insert notifications" ON notifications
    FOR INSERT TO service_role USING (true);
CREATE POLICY "Service role can delete notifications" ON notifications
    FOR DELETE TO service_role USING (true);
