-- 019_booking_reminders.sql
-- Helper table for booking reminders
CREATE TABLE IF NOT EXISTS reminder_log (
    id SERIAL PRIMARY KEY,
    booking_id UUID NOT NULL,
    remind_at TIMESTAMP NOT NULL,
    type VARCHAR(16) NOT NULL,
    sent_at TIMESTAMP NOT NULL DEFAULT NOW(),
    UNIQUE (booking_id, type)
);
-- Add indexes for performance
CREATE INDEX IF NOT EXISTS idx_reminder_log_booking_id ON reminder_log(booking_id);
CREATE INDEX IF NOT EXISTS idx_reminder_log_remind_at ON reminder_log(remind_at);