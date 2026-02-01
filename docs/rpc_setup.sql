-- Function to get attendance for a specific employee in a specific month/year
create or replace function get_monthly_attendance(
  p_employee_id uuid,
  p_month int,
  p_year int
)
returns setof attendance
language sql
security definer
as $$
  select *
  from attendance
  where employee_id = p_employee_id
  and extract(month from date) = p_month
  and extract(year from date) = p_year
  order by date desc;
$$;

-- Add lat/long columns if not exist (for geolocation check-in)
ALTER TABLE attendance ADD COLUMN IF NOT EXISTS check_in_lat DOUBLE PRECISION;
ALTER TABLE attendance ADD COLUMN IF NOT EXISTS check_in_long DOUBLE PRECISION;
