-- HR Connect Database Schema for Supabase
-- Execute this in Supabase SQL Editor (Dashboard > SQL Editor > New Query)

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =============================================
-- ENUM TYPES
-- =============================================

CREATE TYPE employee_status AS ENUM ('Active', 'Inactive', 'On Leave', 'Probation');
CREATE TYPE employee_role AS ENUM ('Admin', 'Manager', 'Employee');
CREATE TYPE attendance_status AS ENUM ('On Time', 'Late', 'Absent', 'Early Leave');
CREATE TYPE location_type AS ENUM ('WFO', 'WFH', 'On Site');
CREATE TYPE request_status AS ENUM ('Pending', 'Approved', 'Rejected');
CREATE TYPE request_type AS ENUM ('Leave', 'Attendance', 'Overtime');

-- =============================================
-- TABLES
-- =============================================

-- Departments
CREATE TABLE departments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    manager_id UUID,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Employees (synced with Supabase Auth)
CREATE TABLE employees (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(50),
    department_id UUID REFERENCES departments(id) ON DELETE SET NULL,
    job_title VARCHAR(255),
    status employee_status DEFAULT 'Active',
    join_date DATE NOT NULL DEFAULT CURRENT_DATE,
    role employee_role DEFAULT 'Employee',
    avatar_url TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Add FK constraint for department manager
ALTER TABLE departments 
ADD CONSTRAINT fk_department_manager 
FOREIGN KEY (manager_id) REFERENCES employees(id) ON DELETE SET NULL;

-- Attendance
CREATE TABLE attendance (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    employee_id UUID NOT NULL REFERENCES employees(id) ON DELETE CASCADE,
    date DATE NOT NULL,
    check_in TIMESTAMPTZ,
    check_out TIMESTAMPTZ,
    status attendance_status,
    location_type location_type,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(employee_id, date)
);

-- Attendance Corrections
CREATE TABLE attendance_corrections (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    attendance_id UUID NOT NULL REFERENCES attendance(id) ON DELETE CASCADE,
    requested_time TIMESTAMPTZ NOT NULL,
    reason TEXT NOT NULL,
    status request_status DEFAULT 'Pending',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Leave Types
CREATE TABLE leave_types (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL,
    quota INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Leave Requests
CREATE TABLE leave_requests (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    employee_id UUID NOT NULL REFERENCES employees(id) ON DELETE CASCADE,
    leave_type_id UUID NOT NULL REFERENCES leave_types(id) ON DELETE RESTRICT,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    reason TEXT NOT NULL,
    attachment_url TEXT,
    status request_status DEFAULT 'Pending',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    CONSTRAINT valid_date_range CHECK (end_date >= start_date)
);

-- Approvals
CREATE TABLE approvals (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    request_type request_type NOT NULL,
    request_id UUID NOT NULL,
    approver_id UUID NOT NULL REFERENCES employees(id) ON DELETE CASCADE,
    status request_status DEFAULT 'Pending',
    comment TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Notifications
CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES employees(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================
-- INDEXES
-- =============================================

CREATE INDEX idx_employees_email ON employees(email);
CREATE INDEX idx_employees_department ON employees(department_id);
CREATE INDEX idx_attendance_employee_date ON attendance(employee_id, date);
CREATE INDEX idx_leave_requests_employee ON leave_requests(employee_id);
CREATE INDEX idx_leave_requests_status ON leave_requests(status);
CREATE INDEX idx_approvals_approver ON approvals(approver_id);
CREATE INDEX idx_notifications_user_unread ON notifications(user_id) WHERE is_read = FALSE;

-- =============================================
-- AUTO-UPDATE TIMESTAMPS TRIGGER
-- =============================================

CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_employees_updated_at BEFORE UPDATE ON employees
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER tr_departments_updated_at BEFORE UPDATE ON departments
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER tr_attendance_updated_at BEFORE UPDATE ON attendance
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER tr_attendance_corrections_updated_at BEFORE UPDATE ON attendance_corrections
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER tr_leave_types_updated_at BEFORE UPDATE ON leave_types
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER tr_leave_requests_updated_at BEFORE UPDATE ON leave_requests
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER tr_approvals_updated_at BEFORE UPDATE ON approvals
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- =============================================
-- SEED DATA
-- =============================================

INSERT INTO leave_types (name, quota) VALUES
    ('Annual Leave', 12),
    ('Sick Leave', 12),
    ('Maternity Leave', 90),
    ('Unpaid Leave', 0);

-- =============================================
-- ROW LEVEL SECURITY (RLS)
-- =============================================

ALTER TABLE employees ENABLE ROW LEVEL SECURITY;
ALTER TABLE attendance ENABLE ROW LEVEL SECURITY;
ALTER TABLE leave_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

-- Employees: Users can read their own data, managers can read department
CREATE POLICY "Users can view own employee data" ON employees
    FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own employee data" ON employees
    FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Allow insert for new registrations" ON employees
    FOR INSERT WITH CHECK (auth.uid() = id);

-- Attendance: Users can manage their own attendance
CREATE POLICY "Users can view own attendance" ON attendance
    FOR SELECT USING (employee_id = auth.uid());

CREATE POLICY "Users can insert own attendance" ON attendance
    FOR INSERT WITH CHECK (employee_id = auth.uid());

CREATE POLICY "Users can update own attendance" ON attendance
    FOR UPDATE USING (employee_id = auth.uid());

-- Leave Requests: Users can manage their own requests
CREATE POLICY "Users can view own leave requests" ON leave_requests
    FOR SELECT USING (employee_id = auth.uid());

CREATE POLICY "Users can insert own leave requests" ON leave_requests
    FOR INSERT WITH CHECK (employee_id = auth.uid());

-- Notifications: Users can only see their own notifications
CREATE POLICY "Users can view own notifications" ON notifications
    FOR SELECT USING (user_id = auth.uid());

CREATE POLICY "Users can update own notifications" ON notifications
    FOR UPDATE USING (user_id = auth.uid());

-- Leave Types: Everyone can read
ALTER TABLE leave_types ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can read leave types" ON leave_types
    FOR SELECT USING (true);

-- Departments: Everyone can read
ALTER TABLE departments ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can read departments" ON departments
    FOR SELECT USING (true);
