# Booking Reminders Edge Function Scheduler

This function is scheduled to run every 15 minutes using Supabase Edge Function scheduler.

## Scheduler Activation

To activate the scheduler, use Supabase CLI:

```
supabase functions schedule booking_reminders --cron "*/15 * * * *"
```

- This will trigger the booking_reminders function every 15 minutes.
- Ensure environment variables SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY are set for the function.

## Structure
- Edge Function: supabase_backup/booking_reminders/index.ts
- Helper Table: reminder_log (see supabase/schema/019_booking_reminders.sql)

## Reminder Logic
- Sends reminders 24h and 2h before booking.
- Prevents duplicate reminders (unique constraint).
- Logs sent reminders in reminder_log.

## Minimum: In-App notifications only (no push).

## Acceptance
- Reminders are sent once per booking per type.
- No duplicate reminders.
- Notifications appear in Notification Center.
