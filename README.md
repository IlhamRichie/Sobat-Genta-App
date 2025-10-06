# GENTA - Aplikasi Agrikultur dan Peternakan
[![GitHub license](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Flutter Version](https://img.shields.io/badge/Flutter-3.35.4-02569B.svg)](https://flutter.dev)
[![Dart Version](https://img.shields.io/badge/Dart-3.9.2-0175C2.svg)](https://dart.dev)

**GENTA** (Klinik Tani) adalah sebuah ekosistem **Agri-Tech** komprehensif yang dirancang untuk mengatasi tiga masalah utama di sektor pertanian dan peternakan di Indonesia: **permodalan, pasar, dan dukungan ahli**. Aplikasi mobile ini tersedia di platform iOS dan Android, melayani berbagai peran pengguna dalam satu platform terintegrasi.

---

## 💡 Fitur Utama (Core Features)

Aplikasi GENTA dibangun di sekitar tiga pilar utama yang menyediakan solusi terintegrasi:

### 1. Pendanaan (Crowdfunding Proyek Pertanian)
* **Untuk Petani:** Memungkinkan petani mengajukan proposal pendanaan untuk kebutuhan modal kerja (bibit, pupuk, pakan). Proposal diverifikasi oleh Admin.
* **Untuk Investor:** Menyediakan marketplace proyek yang transparan, memungkinkan investor menelusuri, menganalisis, dan mendanai proyek dengan potensi **ROI** yang menarik.

### 2. Pasar (Marketplace)
* **Toko (E-commerce):** Modul untuk petani membeli sarana produksi pertanian (saprotan) dan kebutuhan lainnya secara *online*.
* **Kebutuhan (Tender Jasa):** Memungkinkan petani memposting kebutuhan layanan (sewa traktor, tenaga kerja) dan menerima penawaran dari penyedia jasa.

### 3. Dukungan (Dukungan Ahli)
* **Klinik:** Menghubungkan petani dengan para **Pakar** terverifikasi (Pakar Pertanian/Dokter Hewan) melalui layanan **telekonsultasi** (chat dan *video call*).
* **Perpustakaan Digital:** Menyediakan akses ke panduan, artikel, dan tips praktis untuk meningkatkan pengetahuan dan praktik pertanian yang baik.

---

## ⚙️ Arsitektur dan Alur Bisnis (Architecture and Business Flow)

Aplikasi ini mendukung empat peran pengguna utama:

* **Petani (Farmer):** Mendaftarkan lahan/aset, mengajukan pendanaan, berbelanja, mencari layanan, dan berkonsultasi dengan Pakar.
* **Investor:** Berinvestasi, memantau portofolio, dan menarik keuntungan.
* **Pakar (Expert):** Memberikan konsultasi berbayar dan mengelola jadwal.
* **Admin (Backend Operator):** Melakukan verifikasi data, moderasi proyek, dan manajemen konten.

### Alur Bisnis Utama
1.  **Funding Flow:** Petani Mendaftar Lahan $\to$ Admin Verifikasi $\to$ Petani Mengajukan Proposal $\to$ Admin Moderasi $\to$ Proyek Tampil di Marketplace Investor $\to$ Investor Mendanai $\to$ Dana Cair ke Dompet Petani.
2.  **Support Flow:** Petani Membayar Konsultasi $\to$ Pakar Menerima Notifikasi $\to$ Konsultasi (*Video Call*) Dimulai $\to$ Pakar Menerima Pembayaran.

---

## 🛠️ Teknologi yang Digunakan (Technology Stack)

| Kategori | Teknologi | Deskripsi |
| :--- | :--- | :--- |
| **Mobile App** | **Flutter** | Frontend framework untuk pengembangan lintas platform (iOS & Android). |
| **Bahasa** | **Dart** | Bahasa pemrograman utama. |
| **State Management** | **GetX** | Solusi manajemen state yang ringan dan kuat. |
| **Database** | **MySQL** / Firestore | Database Relasional untuk backend utama dan NoSQL untuk data real-time (opsional). |
| **Autentikasi** | Firebase Auth | Layanan otentikasi pengguna. |
| **Pembayaran** | Midtrans / DOKU | Payment Gateway untuk transaksi pendanaan dan marketplace. |
| **Komunikasi** | Agora.io / Twilio | SDK untuk fitur *video call* dan *chat* di modul Klinik. |
| **API** | RESTful API | Komunikasi antara aplikasi mobile dan backend server. |

---

## 📊 Desain Basis Data (Database Design - PostgreSQL)

Skema basis data GENTA diimplementasikan menggunakan **PostgreSQL**, yang dipilih karena dukungan yang kuat untuk fitur-fitur lanjutan seperti tipe data `JSONB` dan tipe data kustom (`ENUM`s) untuk menjaga integritas data status.

### Entitas Kunci dan Fungsionalitas

Struktur ini mendukung semua modul utama aplikasi:

1.  **Pengguna & Peran:**
    * Tabel **`users`** dan **`roles`** mengelola Petani, Investor, Pakar, dan Admin.
    * Tabel **`investorprofiles`** dan **`pakarprofiles`** menyimpan detail spesifik untuk masing-masing peran.
2.  **Pendanaan (Crowdfunding):**
    * Tabel **`lands`** mencatat aset petani yang diverifikasi (Land Asset).
    * Tabel **`projects`** mencatat proposal pendanaan yang diajukan.
    * Tabel **`investments`** mencatat kontribusi dari Investor ke proyek.
3.  **Marketplace & Tender:**
    * Tabel **`products`** dan **`productcategories`** untuk modul e-commerce (Toko).
    * Tabel **`orders`** dan **`orderitems`** untuk mencatat transaksi pembelian.
    * Tabel **`tenderrequests`** dan **`tenderoffers`** untuk modul layanan/jasa (Kebutuhan).
4.  **Dukungan (Klinik & Perpustakaan):**
    * Tabel **`consultations`** mencatat sesi konsultasi terjadwal/terlaksana.
    * Tabel **`chatmessages`** menyimpan riwayat komunikasi konsultasi.
    * Tabel **`edigitaldocuments`** untuk Perpustakaan Digital.
5.  **Keuangan:**
    * Tabel **`wallets`** untuk mengelola saldo dan transaksi internal setiap pengguna.

### Relasi Utama dan Tipe Data Kustom

Skema ini memanfaatkan Foreign Keys (`REFERENCES`) untuk memastikan konsistensi data. Beberapa tipe data kustom (`ENUM`) yang digunakan mencakup:
* `consultation_status`
* `investment_profit_status`
* `asset_type`, `asset_status`
* `order_status`
* `project_status`
* `offer_status`, `tender_status`
* `user_status`

![Gambar ERD Genta](assets/db_structure.png)

*Visualisasi Entity-Relationship Diagram (ERD) akan ditempatkan di sini.*

---

## 💻 Instalasi dan Pengujian (Installation and Testing)

Untuk menjalankan proyek ini secara lokal, pastikan Anda telah menginstal **Flutter** dan **Dart** yang kompatibel, lalu ikuti langkah-langkah berikut:

```bash
# Clone the repository
git clone [https://github.com/IlhamRichie/Sobat-Genta-App.git](https://github.com/IlhamRichie/Sobat-Genta-App.git)

# Navigate to the project directory
cd sobatgenta

# Get dependencies
flutter pub get

# Run the application on a connected device or emulator
flutter run