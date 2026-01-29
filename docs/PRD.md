# Product Requirements Document (PRD) - HR Connect

| Metadata | Details |
| :--- | :--- |
| **Project Name** | HR Connect |
| **Version** | 1.0 |
| **Status** | Draft / UI-Ready |
| **Platform** | Mobile Application |

## 1. Executive Summary
Sistem ini bertujuan untuk menggantikan proses HR manual yang kaku dengan platform SaaS yang modern, intuitif, dan memiliki estetika tinggi. Fokus utama adalah pada efisiensi manajemen data karyawan, transparansi absensi, dan penyederhanaan alur kerja persetujuan (approval workflow).

## 2. Goals & Objectives
- **Sentralisasi Data**: Menjadi satu-satunya sumber kebenaran (single source of truth) untuk data karyawan.
- **User Experience Premium**: Meningkatkan adopsi pengguna melalui UI yang bersih, cepat, dan tidak membosankan.
- **Otomasi Workflow**: Mengurangi waktu proses pengajuan cuti dan koreksi absensi hingga 50%.
- **Scalability**: Arsitektur database yang siap menangani pertumbuhan perusahaan dari startup hingga skala enterprise.

## 3. User Personas
- **HR Administrator**: Mengelola data master, mengonfigurasi pengaturan sistem, dan memantau metrik headcount.
- **Manager**: Menyetujui permintaan (cuti/absensi) tim dan memantau produktivitas harian.
- **Employee**: Melakukan check-in/out, melihat sisa cuti, dan memperbarui profil pribadi secara mandiri.

## 4. Functional Requirements (Modul)

### 4.1. Core Employee Management
- **ID: FR-01**: Sistem harus menampilkan daftar karyawan dengan fitur pencarian dan filter (departemen, jabatan).
- **ID: FR-02**: Profil karyawan harus mencakup data pribadi, informasi pekerjaan, kontak darurat, dan ringkasan aktivitas.
- **ID: FR-03**: Role-based Access Control (Admin vs Employee view) pada level UI.

### 4.2. Attendance & Time Tracking
- **ID: FR-04**: Fitur Check-in/Check-out manual dengan pencatatan waktu (timestamp).
- **ID: FR-05**: Dashboard statistik kehadiran bulanan (On-time, Late, Absent).
- **ID: FR-06**: Pengajuan koreksi absensi jika terjadi kesalahan input atau kegagalan perangkat.

### 4.3. Leave Management
- **ID: FR-07**: Visualisasi saldo cuti (tahunan, sakit, dll) secara real-time.
- **ID: FR-08**: Kalender interaktif untuk memantau jadwal cuti tim (Team Absence Calendar).
- **ID: FR-09**: Form pengajuan cuti dengan dukungan lampiran dokumen (misal: surat sakit).

### 4.4. Approval Workflow & Notifications
- **ID: FR-10**: Central Inbox untuk manager guna menyetujui atau menolak berbagai jenis permintaan dalam satu layar.
- **ID: FR-11**: Sistem notifikasi in-app untuk pembaruan status pengajuan secara instan.

## 5. Non-Functional Requirements
- **UI/UX**: Desain harus menggunakan skala spasi 4/8/12/16/24 dan palet warna netral premium.
- **Responsiveness**: Layout harus optimal baik di layar desktop maupun mobile browser.
- **Performance**: Kecepatan pemuatan halaman (Initial Load) di bawah 2 detik.
- **Security**: Hash password menggunakan algoritma kuat (BCrypt/Argon2) dan implementasi token-based auth (JWT).

## 6. Technical Stack (Suggested)
- **Frontend**: Dart (Flutter).
- **Backend**: Supabase (BAAS).
- **Database**: PostgreSQL.
- **State Management**: Riverpod.

## 7. Roadmap & Future Scope
- **Phase 1**: Core Modules (Karyawan, Absensi, Cuti, Dashboard).
- **Phase 2**: Payroll Integration & Performance Appraisal (KPI).
- **Phase 3**: Recruitment Module (ATS) & Learning Management System (LMS).
- **Phase 4**: AI Insights untuk prediksi turnover karyawan.

## 8. Success Metrics
- **Zero Data Loss**: Tidak ada data master yang hilang saat migrasi.
- **User Satisfaction**: Skor kepuasan pengguna di atas 4.5/5.0 pada fase testing.
- **Processing Time**: Approval workflow selesai dalam waktu rata-rata < 24 jam.

---
*PRD ini merupakan panduan bagi tim pengembang untuk merealisasikan visi desain yang telah dibuat menjadi produk fungsional yang tangguh.*