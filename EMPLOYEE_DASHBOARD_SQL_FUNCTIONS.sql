-- ============================================================================
-- EMPLOYEE DASHBOARD SQL FUNCTIONS
-- ============================================================================
-- Execute these functions in Supabase SQL Editor
-- Database: db.tshbudjnxgufagnvgqtl.supabase.co
-- ============================================================================

-- ============================================================================
-- 1. Get Today's Appointments for Employee
-- ============================================================================
CREATE OR REPLACE FUNCTION get_today_appointments(employee_id UUID)
RETURNS TABLE (
  id UUID,
  start_time TIMESTAMP WITH TIME ZONE,
  end_time TIMESTAMP WITH TIME ZONE,
  status TEXT,
  price NUMERIC,
  notes TEXT,
  service_name TEXT,
  duration_minutes INTEGER,
  customer_name TEXT,
  customer_phone TEXT,
  customer_email TEXT,
  customer_id UUID,
  customer_image TEXT[],
  customer_notes TEXT,
  customer_preferences TEXT,
  customer_allergies TEXT
) AS $$
SELECT
  a.id,
  a.start_time,
  a.end_time,
  a.status::TEXT,
  a.price,
  a.notes,
  s.name,
  s.duration_minutes,
  COALESCE(c.first_name || ' ' || c.last_name, a.guest_name),
  COALESCE(c.phone, a.guest_phone),
  COALESCE(c.email, a.guest_email),
  c.id,
  c.image_urls,
  c.notes,
  c.preferences,
  c.allergies
FROM
  appointments a
  LEFT JOIN services s ON a.service_id = s.id
  LEFT JOIN customer_profiles c ON a.customer_id = c.id
WHERE
  a.employee_id = $1
  AND DATE(a.start_time AT TIME ZONE 'Europe/Berlin') = CURRENT_DATE AT TIME ZONE 'Europe/Berlin'
  AND a.deleted_at IS NULL
ORDER BY
  a.start_time ASC;
$$ LANGUAGE SQL STABLE;

COMMENT ON FUNCTION get_today_appointments(UUID) IS 'Fetch all appointments for an employee on the current day (Europe/Berlin timezone)';

-- ============================================================================
-- 2. Get Upcoming Shifts (Next 7 Days)
-- ============================================================================
CREATE OR REPLACE FUNCTION get_upcoming_shifts(employee_id UUID)
RETURNS TABLE (
  id UUID,
  day_of_week INTEGER,
  start_time TIME WITHOUT TIME ZONE,
  end_time TIME WITHOUT TIME ZONE,
  specific_date DATE,
  is_recurring BOOLEAN,
  schedule_date TEXT,
  duration_hours INTEGER
) AS $$
SELECT
  ws.id,
  ws.day_of_week,
  ws.start_time,
  ws.end_time,
  ws.specific_date,
  ws.is_recurring,
  CASE
    WHEN ws.is_recurring THEN CAST(ws.day_of_week AS TEXT)
    ELSE TO_CHAR(ws.specific_date, 'YYYY-MM-DD')
  END,
  (EXTRACT(EPOCH FROM (ws.end_time - ws.start_time)) / 3600)::INTEGER
FROM
  work_schedules ws
WHERE
  ws.employee_id = $1
  AND (
    (ws.is_recurring = TRUE
     AND ws.day_of_week IN (
       SELECT EXTRACT(DOW FROM (CURRENT_DATE AT TIME ZONE 'Europe/Berlin')::DATE + INTERVAL '1 day' * i)::INTEGER
       FROM generate_series(0, 6) AS i
     ))
    OR (ws.is_recurring = FALSE
        AND ws.specific_date >= CURRENT_DATE AT TIME ZONE 'Europe/Berlin'
        AND ws.specific_date < (CURRENT_DATE AT TIME ZONE 'Europe/Berlin'::DATE + INTERVAL '7 days'))
  )
ORDER BY
  CASE WHEN ws.is_recurring THEN ws.day_of_week ELSE 7 END,
  ws.specific_date,
  ws.start_time;
$$ LANGUAGE SQL STABLE;

COMMENT ON FUNCTION get_upcoming_shifts(UUID) IS 'Fetch work schedule for the next 7 days (both recurring and specific dates)';

-- ============================================================================
-- 3. Get Employee Statistics (Today, This Week, This Month)
-- ============================================================================
CREATE OR REPLACE FUNCTION get_employee_stats(employee_id UUID)
RETURNS TABLE (
  total_today INTEGER,
  completed_today INTEGER,
  upcoming_today INTEGER,
  revenue_today NUMERIC,
  total_week INTEGER,
  completed_week INTEGER,
  revenue_week NUMERIC,
  total_month INTEGER,
  revenue_month NUMERIC,
  unique_customers INTEGER,
  completion_rate_today NUMERIC
) AS $$
WITH today_appointments AS (
  SELECT
    COUNT(*)::INTEGER AS total_today,
    COUNT(CASE WHEN status = 'completed' THEN 1 END)::INTEGER AS completed_today,
    COUNT(CASE WHEN status = 'pending' OR status = 'confirmed' THEN 1 END)::INTEGER AS upcoming_today,
    COALESCE(SUM(CASE WHEN status = 'completed' THEN price END), 0) AS revenue_today
  FROM
    appointments
  WHERE
    employee_id = $1
    AND DATE(start_time AT TIME ZONE 'Europe/Berlin') = CURRENT_DATE AT TIME ZONE 'Europe/Berlin'
    AND deleted_at IS NULL
),
this_week_appointments AS (
  SELECT
    COUNT(*)::INTEGER AS total_week,
    COUNT(CASE WHEN status = 'completed' THEN 1 END)::INTEGER AS completed_week,
    COALESCE(SUM(CASE WHEN status = 'completed' THEN price END), 0) AS revenue_week
  FROM
    appointments
  WHERE
    employee_id = $1
    AND DATE(start_time AT TIME ZONE 'Europe/Berlin') >= DATE_TRUNC('week', CURRENT_DATE AT TIME ZONE 'Europe/Berlin')::DATE
    AND DATE(start_time AT TIME ZONE 'Europe/Berlin') <= CURRENT_DATE AT TIME ZONE 'Europe/Berlin'
    AND deleted_at IS NULL
),
this_month_appointments AS (
  SELECT
    COUNT(*)::INTEGER AS total_month,
    COALESCE(SUM(CASE WHEN status = 'completed' THEN price END), 0) AS revenue_month
  FROM
    appointments
  WHERE
    employee_id = $1
    AND DATE_TRUNC('month', start_time AT TIME ZONE 'Europe/Berlin') = DATE_TRUNC('month', CURRENT_DATE AT TIME ZONE 'Europe/Berlin')
    AND deleted_at IS NULL
),
unique_customers_today AS (
  SELECT COUNT(DISTINCT customer_id)::INTEGER AS unique_customers
  FROM appointments
  WHERE
    employee_id = $1
    AND DATE(start_time AT TIME ZONE 'Europe/Berlin') = CURRENT_DATE AT TIME ZONE 'Europe/Berlin'
    AND status = 'completed'
    AND deleted_at IS NULL
)
SELECT
  ta.total_today,
  ta.completed_today,
  ta.upcoming_today,
  ta.revenue_today,
  tw.total_week,
  tw.completed_week,
  tw.revenue_week,
  tm.total_month,
  tm.revenue_month,
  uc.unique_customers,
  ROUND((ta.completed_today::NUMERIC / NULLIF(ta.total_today, 0)) * 100, 1)
FROM
  today_appointments ta,
  this_week_appointments tw,
  this_month_appointments tm,
  unique_customers_today uc;
$$ LANGUAGE SQL STABLE;

COMMENT ON FUNCTION get_employee_stats(UUID) IS 'Comprehensive statistics: today, this week, this month with revenue and customer metrics';

-- ============================================================================
-- 4. Get Recent Customers with Service History
-- ============================================================================
CREATE OR REPLACE FUNCTION get_recent_customers(employee_id UUID, limit_count INTEGER DEFAULT 10)
RETURNS TABLE (
  id UUID,
  first_name TEXT,
  last_name TEXT,
  phone TEXT,
  email TEXT,
  image_urls TEXT[],
  preferences TEXT,
  allergies TEXT,
  notes TEXT,
  last_appointment TIMESTAMP WITH TIME ZONE,
  total_appointments INTEGER,
  services_history TEXT
) AS $$
SELECT DISTINCT ON (c.id)
  c.id,
  c.first_name,
  c.last_name,
  c.phone,
  c.email,
  c.image_urls,
  c.preferences,
  c.allergies,
  c.notes,
  MAX(a.start_time),
  COUNT(a.id)::INTEGER,
  STRING_AGG(DISTINCT s.name, ', ' ORDER BY s.name)
FROM
  customer_profiles c
  INNER JOIN appointments a ON c.id = a.customer_id
  LEFT JOIN services s ON a.service_id = s.id
WHERE
  a.employee_id = $1
  AND a.status = 'completed'
  AND a.deleted_at IS NULL
  AND c.deleted_at IS NULL
GROUP BY
  c.id,
  c.first_name,
  c.last_name,
  c.phone,
  c.email,
  c.image_urls,
  c.preferences,
  c.allergies,
  c.notes
ORDER BY
  c.id,
  MAX(a.start_time) DESC
LIMIT limit_count;
$$ LANGUAGE SQL STABLE;

COMMENT ON FUNCTION get_recent_customers(UUID, INTEGER) IS 'Fetch recent customers with appointment history and service information';

-- ============================================================================
-- 5. Get Current Shift Status (For Time Tracking)
-- ============================================================================
CREATE OR REPLACE FUNCTION get_current_shift(employee_id UUID)
RETURNS TABLE (
  schedule_id UUID,
  start_time TIME WITHOUT TIME ZONE,
  end_time TIME WITHOUT TIME ZONE,
  schedule_type TEXT,
  last_entry_type TEXT,
  last_entry_time TIMESTAMP WITH TIME ZONE,
  current_status TEXT,
  minutes_since_last_entry NUMERIC,
  is_shift_active BOOLEAN
) AS $$
WITH today_schedule AS (
  SELECT
    ws.id,
    ws.start_time,
    ws.end_time,
    ws.day_of_week,
    CASE
      WHEN ws.is_recurring THEN 'recurring'
      ELSE 'specific'
    END AS schedule_type
  FROM
    work_schedules ws
  WHERE
    ws.employee_id = $1
    AND (
      (ws.is_recurring = TRUE AND ws.day_of_week = EXTRACT(DOW FROM CURRENT_DATE AT TIME ZONE 'Europe/Berlin')::INTEGER)
      OR (ws.is_recurring = FALSE AND ws.specific_date = CURRENT_DATE AT TIME ZONE 'Europe/Berlin')
    )
  LIMIT 1
),
latest_time_entry AS (
  SELECT
    id,
    entry_type,
    timestamp,
    ROW_NUMBER() OVER (PARTITION BY employee_id ORDER BY timestamp DESC) AS rn
  FROM
    dashboard_time_entries
  WHERE
    employee_id = $1
    AND DATE(timestamp AT TIME ZONE 'Europe/Berlin') = CURRENT_DATE AT TIME ZONE 'Europe/Berlin'
)
SELECT
  ts.id,
  ts.start_time,
  ts.end_time,
  ts.schedule_type,
  lte.entry_type,
  lte.timestamp,
  CASE
    WHEN lte.entry_type = 'check_in' THEN 'working'
    WHEN lte.entry_type = 'check_out' THEN 'checked_out'
    WHEN lte.entry_type = 'break_start' THEN 'on_break'
    WHEN lte.entry_type = 'break_end' THEN 'working'
    ELSE 'not_started'
  END,
  EXTRACT(EPOCH FROM (CURRENT_TIMESTAMP AT TIME ZONE 'Europe/Berlin' - lte.timestamp)) / 60,
  CASE
    WHEN (CURRENT_TIME AT TIME ZONE 'Europe/Berlin')::TIME > ts.start_time
         AND (CURRENT_TIME AT TIME ZONE 'Europe/Berlin')::TIME < ts.end_time
    THEN TRUE
    ELSE FALSE
  END
FROM
  today_schedule ts
  LEFT JOIN latest_time_entry lte ON lte.rn = 1;
$$ LANGUAGE SQL STABLE;

COMMENT ON FUNCTION get_current_shift(UUID) IS 'Fetch current shift status with latest time entry for real-time time tracking';

-- ============================================================================
-- VERIFICATION QUERIES
-- ============================================================================

-- Test query 1: Verify functions exist
SELECT
  proname,
  prosignature
FROM
  pg_proc
WHERE
  proname IN (
    'get_today_appointments',
    'get_upcoming_shifts',
    'get_employee_stats',
    'get_recent_customers',
    'get_current_shift'
  )
  AND pronamespace = (SELECT oid FROM pg_namespace WHERE nspname = 'public')
ORDER BY
  proname;

-- Test query 2: Show function definitions
SELECT
  routine_name,
  routine_type
FROM
  information_schema.routines
WHERE
  routine_schema = 'public'
  AND routine_name LIKE 'get_%'
ORDER BY
  routine_name;
