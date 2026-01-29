# Setup Database PostgreSQL di Supabase

## Langkah-Langkah Setup

### 1. Akses Supabase SQL Editor
1. Login ke [Supabase Dashboard](https://app.supabase.com)
2. Pilih project Anda
3. Navigasi ke menu **SQL Editor** di sidebar kiri

### 2. Eksekusi SQL Script
1. Klik **New Query** di SQL Editor
2. Copy seluruh isi file `database_setup.sql`
3. Paste ke SQL Editor
4. Klik **Run** atau tekan `Ctrl+Enter` untuk mengeksekusi

### 3. Verifikasi Setup
Setelah eksekusi berhasil, Anda akan memiliki:

#### ✅ Tables Created
- `departments` - Data departemen perusahaan
- `employees` - Data karyawan
- `attendance` - Record kehadiran harian
- `attendance_corrections` - Request koreksi kehadiran
- `leave_types` - Jenis-jenis cuti
- `leave_requests` - Pengajuan cuti
- `approvals` - Workflow approval
- `notifications` - Notifikasi sistem

#### ✅ Enum Types Created
- `employee_status`: Active, Inactive, On Leave, Probation
- `employee_role`: Admin, Manager, Employee
- `attendance_status`: On Time, Late, Absent, Early Leave
- `location_type`: WFO, WFH, On Site
- `correction_status`: Pending, Approved, Rejected
- `leave_status`: Pending, Approved, Rejected
- `request_type`: Leave, Attendance, Overtime
- `approval_status`: Pending, Approved, Rejected

#### ✅ Indexes Created
Performance indexes untuk query yang sering digunakan

#### ✅ Triggers Created
Auto-update `updated_at` timestamp pada setiap perubahan data

#### ✅ Seed Data
Default leave types sudah diinsert

### 4. Verifikasi di Table Editor
1. Buka **Table Editor** di Supabase
2. Pastikan semua tabel terlihat
3. Check struktur kolom sesuai schema

### 5. Row Level Security (Optional)
Script sudah include contoh RLS policies yang bisa diaktifkan sesuai kebutuhan. Uncomment bagian RLS di akhir script jika ingin mengaktifkan.

## Database Schema Overview

```
┌─────────────────┐
│   departments   │
├─────────────────┤
│ - id            │
│ - name          │
│ - manager_id ───┐
└─────────────────┘ │
                    │
┌─────────────────┐ │
│   employees     │◄┘
├─────────────────┤
│ - id            │──┐
│ - employee_id   │  │
│ - full_name     │  │
│ - email         │  │
│ - department_id │  │
│ - role          │  │
│ - status        │  │
└─────────────────┘  │
         ┌───────────┘
         │
    ┌────▼──────────┐
    │  attendance   │
    ├───────────────┤
    │ - employee_id │
    │ - date        │
    │ - check_in    │
    │ - check_out   │
    │ - status      │
    └───────────────┘
         │
    ┌────▼──────────────────┐
    │ attendance_corrections│
    ├───────────────────────┤
    │ - attendance_id       │
    │ - requested_time      │
    │ - status              │
    └───────────────────────┘
```

## Troubleshooting

### Error: Extension "uuid-ossp" already exists
✅ **Aman diabaikan** - Extension sudah terinstall

### Error: Type already exists
❌ **Hapus semua enum types terlebih dahulu:**
```sql
DROP TYPE IF EXISTS employee_status CASCADE;
DROP TYPE IF EXISTS employee_role CASCADE;
-- dst...
```

### Error: Table already exists
❌ **Hapus semua tables:**
```sql
DROP TABLE IF EXISTS notifications CASCADE;
DROP TABLE IF EXISTS approvals CASCADE;
DROP TABLE IF EXISTS leave_requests CASCADE;
DROP TABLE IF EXISTS leave_types CASCADE;
DROP TABLE IF EXISTS attendance_corrections CASCADE;
DROP TABLE IF EXISTS attendance CASCADE;
DROP TABLE IF EXISTS employees CASCADE;
DROP TABLE IF EXISTS departments CASCADE;
```

## Next Steps

1. **Setup Supabase Auth** - Sync dengan table `employees`
2. **Configure RLS Policies** - Sesuai requirement security
3. **Test Insert Data** - Coba insert sample data
4. **Connect ke Flutter App** - Update connection string

---
**File Created**: `database_setup.sql`  
**Status**: ✅ Ready to execute in Supabase SQL Editor
