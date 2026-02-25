-- Migration: 20260216_admin_dashboard_backend
-- Purpose: Create tables and functions for Admin Dashboard features
-- Components:
--   1. activity_logs table
--   2. salon_codes table  
--   3. employee_time_codes table
--   4. module_settings table
--   5. SQL Functions for authentication and management

-- ==================== ACTIVITY LOGS TABLE ====================
-- Audit trail for tracking all admin and user actions

CREATE TABLE IF NOT EXISTS public.activity_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  salon_id UUID NOT NULL REFERENCES public.salons(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  user_name TEXT NOT NULL,
  type TEXT NOT NULL,
  description TEXT NOT NULL,
  timestamp TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  metadata JSONB,
  ip_address TEXT,
  user_agent TEXT,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

-- Indexes for better query performance
CREATE INDEX idx_activity_logs_salon_id ON public.activity_logs(salon_id);
CREATE INDEX idx_activity_logs_user_id ON public.activity_logs(user_id);
CREATE INDEX idx_activity_logs_timestamp ON public.activity_logs(timestamp DESC);
CREATE INDEX idx_activity_logs_type ON public.activity_logs(type);

-- RLS Policy
ALTER TABLE public.activity_logs ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Salon admins can view activity logs"
  ON public.activity_logs FOR SELECT
  USING (
    salon_id IN (
      SELECT salon_id FROM public.salons 
      WHERE owner_id = AUTH.UID()
    )
  );

---

-- ==================== SALON CODES TABLE ====================
-- Stores codes for admin access to salon management

CREATE TABLE IF NOT EXISTS public.salon_codes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  salon_id UUID NOT NULL REFERENCES public.salons(id) ON DELETE CASCADE,
  code TEXT NOT NULL UNIQUE,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  generated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  generated_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  expires_at TIMESTAMP WITH TIME ZONE,
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_salon_codes_salon_id ON public.salon_codes(salon_id);
CREATE INDEX idx_salon_codes_code ON public.salon_codes(code);
CREATE INDEX idx_salon_codes_is_active ON public.salon_codes(is_active);

-- RLS Policy
ALTER TABLE public.salon_codes ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Track salon code access"
  ON public.salon_codes
  USING (true);

---

-- ==================== EMPLOYEE TIME CODES TABLE ====================
-- Codes for employees to log in and track time

CREATE TABLE IF NOT EXISTS public.employee_time_codes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  employee_id UUID NOT NULL REFERENCES public.employees(id) ON DELETE CASCADE,
  salon_id UUID NOT NULL REFERENCES public.salons(id) ON DELETE CASCADE,
  code TEXT NOT NULL UNIQUE,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  generated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  generated_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  expires_at TIMESTAMP WITH TIME ZONE,
  last_used_at TIMESTAMP WITH TIME ZONE,
  access_count INTEGER DEFAULT 0,
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_employee_time_codes_employee_id ON public.employee_time_codes(employee_id);
CREATE INDEX idx_employee_time_codes_salon_id ON public.employee_time_codes(salon_id);
CREATE INDEX idx_employee_time_codes_code ON public.employee_time_codes(code);
CREATE INDEX idx_employee_time_codes_is_active ON public.employee_time_codes(is_active);

-- RLS Policy
ALTER TABLE public.employee_time_codes ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Track employee code access"
  ON public.employee_time_codes
  USING (true);

---

-- ==================== MODULE SETTINGS TABLE ====================
-- Stores configuration for enabled/disabled modules per salon

CREATE TABLE IF NOT EXISTS public.module_settings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  salon_id UUID NOT NULL REFERENCES public.salons(id) ON DELETE CASCADE,
  module_type TEXT NOT NULL,
  is_enabled BOOLEAN NOT NULL DEFAULT TRUE,
  permissions TEXT[] DEFAULT ARRAY['view'],
  configuration JSONB,
  enabled_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  disabled_at TIMESTAMP WITH TIME ZONE,
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  UNIQUE(salon_id, module_type)
);

-- Indexes
CREATE INDEX idx_module_settings_salon_id ON public.module_settings(salon_id);
CREATE INDEX idx_module_settings_module_type ON public.module_settings(module_type);
CREATE INDEX idx_module_settings_is_enabled ON public.module_settings(is_enabled);

-- RLS Policy
ALTER TABLE public.module_settings ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Salon admins can manage modules"
  ON public.module_settings FOR ALL
  USING (
    salon_id IN (
      SELECT salon_id FROM public.salons 
      WHERE owner_id = AUTH.UID()
    )
  );

---

-- ==================== FUNCTION: verify_salon_code ====================
-- Verify if a salon code is valid

CREATE OR REPLACE FUNCTION public.verify_salon_code(
  p_salon_id UUID,
  p_code TEXT
)
RETURNS JSON AS $$
DECLARE
  v_code_record RECORD;
BEGIN
  SELECT id, is_active, salon_id INTO v_code_record
  FROM public.salon_codes
  WHERE salon_id = p_salon_id 
    AND code = p_code
    AND is_active = TRUE
    AND (expires_at IS NULL OR expires_at > NOW())
  LIMIT 1;

  IF FOUND THEN
    -- Log the verification attempt
    INSERT INTO public.activity_logs (
      salon_id, user_id, user_name, type, description, metadata
    ) VALUES (
      p_salon_id,
      AUTH.UID(),
      COALESCE(AUTH.JWT()->>'email', 'unknown'),
      'salon_code_verified',
      'Salon code verified successfully',
      jsonb_build_object('code_id', v_code_record.id)
    );
    
    RETURN json_build_object(
      'is_valid', true,
      'salon_id', v_code_record.salon_id,
      'message', 'Code is valid'
    );
  ELSE
    -- Log failed verification
    INSERT INTO public.activity_logs (
      salon_id, user_id, user_name, type, description, metadata
    ) VALUES (
      p_salon_id,
      AUTH.UID(),
      COALESCE(AUTH.JWT()->>'email', 'unknown'),
      'salon_code_verification_failed',
      'Salon code verification failed',
      jsonb_build_object('attempted_code_length', CHAR_LENGTH(p_code))
    );
    
    RETURN json_build_object(
      'is_valid', false,
      'message', 'Invalid or expired code'
    );
  END IF;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

---

-- ==================== FUNCTION: generate_salon_code ====================
-- Generate a new salon code (random 6-digit number)

CREATE OR REPLACE FUNCTION public.generate_salon_code(
  p_salon_id UUID
)
RETURNS JSON AS $$
DECLARE
  v_new_code TEXT;
  v_max_attempts INTEGER := 10;
  v_attempt INTEGER := 0;
BEGIN
  -- Try to generate a unique code
  LOOP
    v_attempt := v_attempt + 1;
    v_new_code := LPAD(FLOOR(RANDOM() * 1000000)::TEXT, 6, '0');
    
    -- Check if code already exists
    IF NOT EXISTS(SELECT 1 FROM public.salon_codes WHERE code = v_new_code) THEN
      EXIT;
    END IF;
    
    IF v_attempt >= v_max_attempts THEN
      RETURN json_build_object(
        'success', false,
        'message', 'Failed to generate unique code'
      );
    END IF;
  END LOOP;

  -- Insert new code (deactivate old ones)
  UPDATE public.salon_codes 
  SET is_active = FALSE, updated_at = NOW()
  WHERE salon_id = p_salon_id AND is_active = TRUE;

  INSERT INTO public.salon_codes (
    salon_id, code, is_active, generated_by
  ) VALUES (
    p_salon_id, v_new_code, TRUE, AUTH.UID()
  );

  -- Log the generation
  INSERT INTO public.activity_logs (
    salon_id, user_id, user_name, type, description
  ) VALUES (
    p_salon_id,
    AUTH.UID(),
    COALESCE(AUTH.JWT()->>'email', 'unknown'),
    'salon_code_generated',
    'New salon code generated: ' || v_new_code
  );

  RETURN json_build_object(
    'success', true,
    'code', v_new_code,
    'message', 'Salon code generated successfully'
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

---

-- ==================== FUNCTION: reset_salon_code ====================
-- Reset salon code to a new one

CREATE OR REPLACE FUNCTION public.reset_salon_code(
  p_salon_id UUID,
  p_new_code TEXT
)
RETURNS JSON AS $$
DECLARE
  v_old_code TEXT;
BEGIN
  -- Validate code length
  IF CHAR_LENGTH(p_new_code) < 4 THEN
    RETURN json_build_object(
      'success', false,
      'message', 'Code must be at least 4 characters'
    );
  END IF;

  -- Check if code already exists
  IF EXISTS(SELECT 1 FROM public.salon_codes WHERE code = p_new_code) THEN
    RETURN json_build_object(
      'success', false,
      'message', 'Code already in use'
    );
  END IF;

  -- Get current code
  SELECT code INTO v_old_code
  FROM public.salon_codes
  WHERE salon_id = p_salon_id AND is_active = TRUE
  LIMIT 1;

  -- Deactivate old code
  UPDATE public.salon_codes 
  SET is_active = FALSE, updated_at = NOW()
  WHERE salon_id = p_salon_id AND is_active = TRUE;

  -- Insert new code
  INSERT INTO public.salon_codes (
    salon_id, code, is_active, generated_by
  ) VALUES (
    p_salon_id, UPPER(p_new_code), TRUE, AUTH.UID()
  );

  -- Log the reset
  INSERT INTO public.activity_logs (
    salon_id, user_id, user_name, type, description, metadata
  ) VALUES (
    p_salon_id,
    AUTH.UID(),
    COALESCE(AUTH.JWT()->>'email', 'unknown'),
    'salon_code_reset',
    'Salon code reset',
    jsonb_build_object('old_code', v_old_code, 'new_code', UPPER(p_new_code))
  );

  RETURN json_build_object(
    'success', true,
    'code', UPPER(p_new_code),
    'message', 'Salon code reset successfully'
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

---

-- ==================== FUNCTION: generate_employee_time_code ====================
-- Generate a new time code for an employee

CREATE OR REPLACE FUNCTION public.generate_employee_time_code(
  p_employee_id UUID
)
RETURNS JSON AS $$
DECLARE
  v_new_code TEXT;
  v_salon_id UUID;
  v_max_attempts INTEGER := 10;
  v_attempt INTEGER := 0;
BEGIN
  -- Get salon_id from employee
  SELECT employee_code, salon_id INTO v_new_code, v_salon_id
  FROM public.employees WHERE id = p_employee_id
  LIMIT 1;

  IF v_salon_id IS NULL THEN
    RETURN json_build_object(
      'success', false,
      'message', 'Employee not found'
    );
  END IF;

  -- Generate unique code (6 alphanumeric characters)
  LOOP
    v_attempt := v_attempt + 1;
    v_new_code := SUBSTRING(MD5(RANDOM()::TEXT || CLOCK_TIMESTAMP()::TEXT), 1, 6);
    
    IF NOT EXISTS(SELECT 1 FROM public.employee_time_codes WHERE code = v_new_code) THEN
      EXIT;
    END IF;
    
    IF v_attempt >= v_max_attempts THEN
      RETURN json_build_object(
        'success', false,
        'message', 'Failed to generate unique code'
      );
    END IF;
  END LOOP;

  -- Deactivate old codes
  UPDATE public.employee_time_codes 
  SET is_active = FALSE, updated_at = NOW()
  WHERE employee_id = p_employee_id AND is_active = TRUE;

  -- Insert new code
  INSERT INTO public.employee_time_codes (
    employee_id, salon_id, code, is_active, generated_by
  ) VALUES (
    p_employee_id, v_salon_id, UPPER(v_new_code), TRUE, AUTH.UID()
  );

  -- Log the generation
  INSERT INTO public.activity_logs (
    salon_id, user_id, user_name, type, description, metadata
  ) VALUES (
    v_salon_id,
    AUTH.UID(),
    COALESCE(AUTH.JWT()->>'email', 'unknown'),
    'employee_code_generated',
    'New employee time code generated',
    jsonb_build_object('employee_id', p_employee_id, 'code', UPPER(v_new_code))
  );

  RETURN json_build_object(
    'success', true,
    'code', UPPER(v_new_code),
    'employee_id', p_employee_id,
    'message', 'Employee time code generated successfully'
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

---

-- ==================== FUNCTION: verify_employee_code ====================
-- Verify if an employee code is valid

CREATE OR REPLACE FUNCTION public.verify_employee_code(
  p_code TEXT
)
RETURNS JSON AS $$
DECLARE
  v_code_record RECORD;
BEGIN
  SELECT 
    etc.id,
    etc.employee_id,
    etc.salon_id,
    etc.is_active,
    e.first_name,
    e.last_name,
    e.email
  INTO v_code_record
  FROM public.employee_time_codes etc
  JOIN public.employees e ON etc.employee_id = e.id
  WHERE etc.code = UPPER(p_code)
    AND etc.is_active = TRUE
    AND (etc.expires_at IS NULL OR etc.expires_at > NOW())
  LIMIT 1;

  IF FOUND THEN
    -- Update access count and last used
    UPDATE public.employee_time_codes
    SET access_count = access_count + 1,
        last_used_at = NOW(),
        updated_at = NOW()
    WHERE id = v_code_record.id;

    -- Log the verification
    INSERT INTO public.activity_logs (
      salon_id, user_id, user_name, type, description, metadata
    ) VALUES (
      v_code_record.salon_id,
      v_code_record.employee_id,
      v_code_record.first_name || ' ' || COALESCE(v_code_record.last_name, ''),
      'employee_login',
      'Employee login via time code',
      jsonb_build_object('code_id', v_code_record.id)
    );

    RETURN json_build_object(
      'is_valid', true,
      'employee_id', v_code_record.employee_id,
      'employee_name', v_code_record.first_name || ' ' || COALESCE(v_code_record.last_name, ''),
      'employee_email', v_code_record.email,
      'salon_id', v_code_record.salon_id,
      'message', 'Code is valid'
    );
  ELSE
    RETURN json_build_object(
      'is_valid', false,
      'message', 'Invalid or expired code'
    );
  END IF;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

---

-- ==================== FUNCTION: log_activity ====================
-- Helper function to log activities

CREATE OR REPLACE FUNCTION public.log_activity(
  p_salon_id UUID,
  p_user_id UUID,
  p_user_name TEXT,
  p_type TEXT,
  p_description TEXT,
  p_metadata JSONB DEFAULT NULL
)
RETURNS UUID AS $$
DECLARE
  v_log_id UUID;
BEGIN
  INSERT INTO public.activity_logs (
    salon_id, user_id, user_name, type, description, metadata
  ) VALUES (
    p_salon_id,
    p_user_id,
    p_user_name,
    p_type,
    p_description,
    p_metadata
  )
  RETURNING id INTO v_log_id;

  RETURN v_log_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

---

-- ==================== FUNCTION: get_activity_log ====================
-- Get activity logs for a salon with optional filtering

CREATE OR REPLACE FUNCTION public.get_activity_log(
  p_salon_id UUID,
  p_limit INTEGER DEFAULT 50,
  p_offset INTEGER DEFAULT 0,
  p_type_filter TEXT DEFAULT NULL
)
RETURNS TABLE (
  id UUID,
  salon_id UUID,
  user_id UUID,
  user_name TEXT,
  type TEXT,
  description TEXT,
  timestamp TIMESTAMP WITH TIME ZONE,
  metadata JSONB
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    al.id,
    al.salon_id,
    al.user_id,
    al.user_name,
    al.type,
    al.description,
    al.timestamp,
    al.metadata
  FROM public.activity_logs al
  WHERE al.salon_id = p_salon_id
    AND (p_type_filter IS NULL OR al.type = p_type_filter)
  ORDER BY al.timestamp DESC
  LIMIT p_limit
  OFFSET p_offset;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

---

-- ==================== GRANTS ====================
-- Set proper permissions for functions

GRANT EXECUTE ON FUNCTION public.verify_salon_code(UUID, TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION public.generate_salon_code(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION public.reset_salon_code(UUID, TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION public.generate_employee_time_code(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION public.verify_employee_code(TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION public.log_activity(UUID, UUID, TEXT, TEXT, TEXT, JSONB) TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_activity_log(UUID, INTEGER, INTEGER, TEXT) TO authenticated;

---

-- ==================== VERIFICATION QUERIES ====================
-- Run these to verify the setup

-- Select all tables
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
  AND table_name IN ('activity_logs', 'salon_codes', 'employee_time_codes', 'module_settings')
ORDER BY table_name;

-- Check functions
SELECT routine_name, routine_type
FROM information_schema.routines
WHERE routine_schema = 'public'
  AND routine_name IN (
    'verify_salon_code',
    'generate_salon_code', 
    'reset_salon_code',
    'generate_employee_time_code',
    'verify_employee_code',
    'log_activity',
    'get_activity_log'
  )
ORDER BY routine_name;
