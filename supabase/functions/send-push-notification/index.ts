import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
// @deno-types="npm:@types/web-push@3.6.0"
import webpush from 'npm:web-push@3.6.3'

const VAPID_PUBLIC_KEY = 'BL3MwH4RWN5eE9QLsbuAIT6_9n6WrFLyBzbbkp8om5uTCuJTfWAB8HdPlw0Yr0msnNmYg9Bda-LHB04In3yEEek'
const VAPID_PRIVATE_KEY = 'C-DjR3M74TVfPwkH033wVbQEUciQS22xIItfVBnlv7Q'
const VAPID_SUBJECT = 'mailto:no-reply@salonmanager.app'

webpush.setVapidDetails(
  VAPID_SUBJECT,
  VAPID_PUBLIC_KEY,
  VAPID_PRIVATE_KEY
)

interface SendNotificationRequest {
  user_id: string
  title: string
  body: string
  icon?: string
  badge?: string
  data?: Record<string, any>
  notification_type: string
}

serve(async (req) => {
  try {
    const supabase = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
    )

    const payload: SendNotificationRequest = await req.json()
    const { user_id, title, body, icon, badge, data, notification_type } = payload

    // Subscriptions für User abrufen
    const { data: subscriptions, error: subError } = await supabase
      .from('push_subscriptions')
      .select('*')
      .eq('user_id', user_id)
      .eq('enabled', true)

    if (subError) throw subError
    if (!subscriptions || subscriptions.length === 0) {
      return new Response(JSON.stringify({ 
        success: false, 
        message: 'No active subscriptions found' 
      }), { 
        status: 404,
        headers: { "Content-Type": "application/json" }
      })
    }

    // Notification Payload
    const notificationPayload = JSON.stringify({
      title,
      body,
      icon: icon || '/logo-192.png',
      badge: badge || '/badge-72.png',
      data: {
        ...data,
        notification_type,
        timestamp: Date.now()
      }
    })

    const results = []

    // An alle Subscriptions senden
    for (const sub of subscriptions) {
      try {
        const pushSubscription = {
          endpoint: sub.endpoint,
          keys: {
            p256dh: sub.p256dh_key,
            auth: sub.auth_key
          }
        }

        await webpush.sendNotification(pushSubscription, notificationPayload)

        // Log success
        await supabase.from('notification_logs').insert({
          user_id,
          subscription_id: sub.id,
          notification_type,
          title,
          body,
          data,
          delivered: true
        })

        // Update last_used_at
        await supabase
          .from('push_subscriptions')
          .update({ last_used_at: new Date().toISOString() })
          .eq('id', sub.id)

        results.push({ subscription_id: sub.id, success: true })
      } catch (error: any) {
        console.error(`Failed to send to ${sub.id}:`, error)

        // Log error
        await supabase.from('notification_logs').insert({
          user_id,
          subscription_id: sub.id,
          notification_type,
          title,
          body,
          data,
          delivered: false,
          error: error.message
        })

        // Subscription ungültig? Deaktivieren
        if (error.statusCode === 410 || error.statusCode === 404) {
          await supabase
            .from('push_subscriptions')
            .update({ enabled: false })
            .eq('id', sub.id)
        }

        results.push({ subscription_id: sub.id, success: false, error: error.message })
      }
    }

    return new Response(JSON.stringify({ 
      success: true, 
      sent: results.filter(r => r.success).length,
      failed: results.filter(r => !r.success).length,
      results 
    }), {
      headers: { "Content-Type": "application/json" }
    })
  } catch (error: any) {
    console.error('Error:', error)
    return new Response(JSON.stringify({ error: error.message }), { 
      status: 500,
      headers: { "Content-Type": "application/json" }
    })
  }
})