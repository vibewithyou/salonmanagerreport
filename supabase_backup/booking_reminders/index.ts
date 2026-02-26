// booking_reminders/index.ts
// Scheduled Edge Function for booking reminders
// Runs every 15 minutes

import { createClient } from "@supabase/supabase-js";

const supabaseUrl = process.env.SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_SERVICE_ROLE_KEY;
const supabase = createClient(supabaseUrl, supabaseKey);

const REMINDER_TYPES = [
  { type: "24h", offset: 24 },
  { type: "2h", offset: 2 }
];

async function getUpcomingBookings() {
  const now = new Date();
  const bookings = [];
  for (const { type, offset } of REMINDER_TYPES) {
    const remindAt = new Date(now.getTime() + offset * 60 * 60 * 1000);
    const { data, error } = await supabase
      .from("bookings")
      .select("id, start_at, customer_id, stylist_id")
      .gte("start_at", now.toISOString())
      .lt("start_at", remindAt.toISOString());
    if (error) throw error;
    bookings.push(...data.map(b => ({ ...b, type })));
  }
  return bookings;
}

async function reminderAlreadySent(booking_id, type) {
  const { data, error } = await supabase
    .from("reminder_log")
    .select("id")
    .eq("booking_id", booking_id)
    .eq("type", type);
  if (error) throw error;
  return data.length > 0;
}

async function sendNotification(user_id, booking_id, type) {
  // Insert notification (in-app)
  await supabase.from("notifications").insert({
    user_id,
    booking_id,
    type,
    message: `Reminder: Your booking is in ${type === "24h" ? "24" : "2"} hours.`
  });
}

async function logReminder(booking_id, remind_at, type) {
  await supabase.from("reminder_log").insert({
    booking_id,
    remind_at,
    type,
    sent_at: new Date().toISOString()
  });
}

export default async function handler(req, res) {
  try {
    const bookings = await getUpcomingBookings();
    for (const booking of bookings) {
      if (!(await reminderAlreadySent(booking.id, booking.type))) {
        await sendNotification(booking.customer_id, booking.id, booking.type);
        await sendNotification(booking.stylist_id, booking.id, booking.type);
        await logReminder(booking.id, booking.start_at, booking.type);
      }
    }
    res.status(200).json({ status: "ok", reminders: bookings.length });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

// Scheduler config:
// Run every 15 min via Supabase Scheduled Edge Functions
// Example config (supabase CLI):
// supabase functions schedule booking_reminders --cron "*/15 * * * *"