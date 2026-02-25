import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

serve(async (req) => {
  const supabase = createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
  )

  // Hole alle fälligen Benachrichtigungen
  const { data: notifications, error } = await supabase
    .from('scheduled_notifications')
    .select(`
      *,
      appointments(id, service_name, start_time, salon_id),
      profiles(full_name)
    `)
    .eq('sent', false)
    .lte('scheduled_for', new Date().toISOString())
    .limit(100)

  if (error) {
    console.error('Error fetching notifications:', error)
    return new Response(JSON.stringify({ error: error.message }), { 
      status: 500,
      headers: { "Content-Type": "application/json" }
    })
  }

  let sent = 0
  let failed = 0

  for (const notif of notifications || []) {
    try {
      const appointment = notif.appointments
      if (!appointment) {
        failed++
        continue
      }

      let title, body

      if (notif.notification_type === 'reminder_24h') {
        title = '📅 Termin-Erinnerung'
        body = `Morgen um ${new Date(appointment.start_time).toLocaleTimeString('de-DE', { hour: '2-digit', minute: '2-digit' })}: ${appointment.service_name}`
      } else if (notif.notification_type === 'reminder_2h') {
        title = '⏰ Termin beginnt bald!'
        body = `In 2 Stunden: ${appointment.service_name}`
      } else {
        title = '📌 Termin-Erinnerung'
        body = `${appointment.service_name}`
      }

      // Send Push Notification
      const response = await fetch(
        `${Deno.env.get('SUPABASE_URL')}/functions/v1/send-push-notification`,
        {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')}`
          },
          body: JSON.stringify({
            user_id: notif.user_id,
            title,
            body,
            notification_type: notif.notification_type,
            data: {
              appointment_id: appointment.id,
              url: `/appointments/${appointment.id}`
            }
          })
        }
      )

      if (response.ok) {
        await supabase
          .from('scheduled_notifications')
          .update({ sent: true, sent_at: new Date().toISOString() })
          .eq('id', notif.id)
        sent++
      } else {
        const error = await response.text()
        await supabase
          .from('scheduled_notifications')
          .update({ error })
          .eq('id', notif.id)
        failed++
      }
    } catch (error: any) {
      console.error(`Failed to process notification ${notif.id}:`, error)
      await supabase
        .from('scheduled_notifications')
        .update({ error: error.message })
        .eq('id', notif.id)
      failed++
    }
  }

  return new Response(JSON.stringify({ 
    success: true, 
    sent, 
    failed,
    total: (notifications || []).length 
  }), {
    headers: { "Content-Type": "application/json" }
  })
})