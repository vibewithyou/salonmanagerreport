create or replace function public.get_available_slots(
  p_salon_id uuid,
  p_service_id uuid,
  p_target_date date,
  p_staff_id uuid default null
)
returns table(start_at timestamptz, end_at timestamptz)
language plpgsql
security definer
as $$
declare
  v_duration_minutes integer := 30;
  v_day_start timestamptz;
  v_day_end timestamptz;
  v_slot_start timestamptz;
  v_slot_end timestamptz;
begin
  select coalesce(s.duration_minutes, 30)
    into v_duration_minutes
    from public.services s
   where s.id = p_service_id
   limit 1;

  v_day_start := (p_target_date::timestamp at time zone 'UTC') + interval '9 hour';
  v_day_end := (p_target_date::timestamp at time zone 'UTC') + interval '18 hour';

  v_slot_start := v_day_start;
  while v_slot_start + make_interval(mins => v_duration_minutes) <= v_day_end loop
    v_slot_end := v_slot_start + make_interval(mins => v_duration_minutes);

    if not exists (
      select 1
        from public.appointments a
       where a.salon_id = p_salon_id
         and (p_staff_id is null or a.employee_id = p_staff_id)
         and coalesce(a.status, 'pending') <> 'cancelled'
         and a.start_time < v_slot_end
         and a.end_time > v_slot_start
    ) and v_slot_start > now() then
      start_at := v_slot_start;
      end_at := v_slot_end;
      return next;
    end if;

    v_slot_start := v_slot_start + interval '30 minute';
  end loop;

  return;
end;
$$;
