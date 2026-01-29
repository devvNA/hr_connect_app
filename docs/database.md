# HRIS Database Schema (PostgreSQL/Supabase)

## 1. Core Employee Management
Modul ini menyimpan data master karyawan sebagaimana terlihat di layar "Employee Profile" dan "Employee List".

### Table: `employees`
| Column | Type | Description |
| :--- | :--- | :--- |
| `id` | UUID (PK) | Unique identifier |
| `employee_id` | String | ID Karyawan Perusahaan (misal: EMP-001) |
| `full_name` | String | Nama lengkap |
| `email` | String (Unique) | Email kerja (untuk login) |
| `password_hash` | String | Hash password tersinkron dengan Auth page |
| `phone` | String | Nomor telepon |
| `department_id` | UUID (FK) | Relasi ke tabel departments |
| `job_title` | String | Posisi jabatan (misal: Senior UX Designer) |
| `status` | Enum | Active, Inactive, On Leave, Probation |
| `join_date` | Date | Tanggal bergabung |
| `role` | Enum | Admin, Manager, Employee (untuk UI logic) |
| `avatar_url` | String | Link foto profil |

### Table: `departments`
| Column | Type | Description |
| :--- | :--- | :--- |
| `id` | UUID (PK) | Unique identifier |
| `name` | String | Nama departemen (IT, HR, Finance, dll) |
| `manager_id` | UUID (FK) | Relasi ke employee yang menjadi manager |

---

## 2. Attendance & Time Tracking
Mendukung fitur Check-in/out dan dashboard kehadiran.

### Table: `attendance`
| Column | Type | Description |
| :--- | :--- | :--- |
| `id` | UUID (PK) | Unique identifier |
| `employee_id` | UUID (FK) | Relasi ke employee |
| `date` | Date | Tanggal record |
| `check_in` | Timestamp | Waktu masuk |
| `check_out` | Timestamp | Waktu pulang |
| `status` | Enum | On Time, Late, Absent, Early Leave |
| `location_type` | Enum | WFO, WFH, On Site |

### Table: `attendance_corrections`
| Column | Type | Description |
| :--- | :--- | :--- |
| `id` | UUID (PK) | Unique identifier |
| `attendance_id` | UUID (FK) | Record yang ingin diperbaiki |
| `requested_time` | Timestamp | Waktu yang diusulkan |
| `reason` | Text | Alasan koreksi |
| `status` | Enum | Pending, Approved, Rejected |

---

## 3. Leave Management
Mendukung dashboard saldo cuti dan kalender cuti.

### Table: `leave_types`
| Column | Type | Description |
| :--- | :--- | :--- |
| `id` | UUID (PK) | Unique identifier |
| `name` | String | Annual, Sick, Maternity, Unpaid |
| `quota` | Integer | Jatah hari per tahun |

### Table: `leave_requests`
| Column | Type | Description |
| :--- | :--- | :--- |
| `id` | UUID (PK) | Unique identifier |
| `employee_id` | UUID (FK) | Relasi ke employee |
| `leave_type_id` | UUID (FK) | Tipe cuti |
| `start_date` | Date | Tanggal mulai |
| `end_date` | Date | Tanggal selesai |
| `reason` | Text | Alasan cuti |
| `attachment_url` | String | Bukti surat sakit, dll |
| `status` | Enum | Pending, Approved, Rejected |

---

## 4. Workflow Approvals & Notifications
Mendukung fitur "Approval Center" dan notifikasi.

### Table: `approvals`
| Column | Type | Description |
| :--- | :--- | :--- |
| `id` | UUID (PK) | Unique identifier |
| `request_type` | Enum | Leave, Attendance, Overtime |
| `request_id` | UUID | ID dari tabel leave_requests atau attendance_corrections |
| `approver_id` | UUID (FK) | Manager yang harus menyetujui |
| `status` | Enum | Pending, Approved, Rejected |
| `comment` | Text | Catatan dari manager |

### Table: `notifications`
| Column | Type | Description |
| :--- | :--- | :--- |
| `id` | UUID (PK) | Unique identifier |
| `user_id` | UUID (FK) | Penerima notifikasi |
| `title` | String | Judul pesan |
| `message` | Text | Isi pesan |
| `is_read` | Boolean | Status dibaca |
| `created_at` | Timestamp | Waktu kirim |
Catatan Implementasi:

Role-Based Access Control (RBAC): Gunakan kolom role di tabel employees untuk menentukan layar mana yang bisa diakses (misal: hanya Admin/Manager yang bisa melihat "Approval Center").
Audit Trail: Disarankan menambah tabel activity_logs untuk mencatat setiap perubahan data sensitif oleh HR.