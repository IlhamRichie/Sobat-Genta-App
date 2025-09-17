# GENTA - Aplikasi Agrikultur dan Peternakan

[](https://flutter.dev)
[](https://dart.dev)
[](https://opensource.org/licenses/MIT)

GENTA (Global Ecosystem for New-age Tani and Agri-Tech) adalah sebuah ekosistem Agri-Tech komprehensif yang dirancang untuk mengatasi tiga masalah utama di sektor pertanian dan peternakan di Indonesia: **permodalan, pasar, dan dukungan ahli**. Aplikasi mobile ini tersedia di platform iOS dan Android, melayani berbagai peran pengguna dalam satu platform terintegrasi.

-----

### Fitur Utama (Core Features)

Aplikasi GENTA dibangun di sekitar tiga pilar utama yang menyediakan solusi terintegrasi:

1.  **Pendanaan (Crowdfunding Proyek Pertanian)**
      * **Untuk Petani:** Memungkinkan petani mengajukan proposal pendanaan untuk kebutuhan modal kerja, seperti pembelian bibit, pupuk, atau pakan ternak. Proposal yang diajukan akan diverifikasi oleh Admin.
      * **Untuk Investor:** Menyediakan marketplace proyek yang transparan, memungkinkan investor menelusuri, menganalisis, dan mendanai proyek pertanian/peternakan dengan potensi imbal hasil (ROI) yang menarik.
2.  **Pasar (Marketplace)**
      * **Toko (E-commerce):** Modul ini menyediakan tempat bagi petani untuk membeli sarana produksi pertanian (saprotan) dan kebutuhan lainnya secara online.
      * **Kebutuhan (Tender):** Memungkinkan petani untuk memposting kebutuhan layanan, seperti penyewaan traktor atau tenaga kerja, dan menerima penawaran dari penyedia jasa.
3.  **Dukungan (Dukungan Ahli)**
      * **Klinik:** Modul ini menghubungkan petani dengan para ahli terverifikasi (Pakar Pertanian/Dokter Hewan) melalui layanan telekonsultasi (chat dan video call).
      * **Perpustakaan Digital:** Menyediakan akses ke panduan, artikel, dan tips praktis untuk meningkatkan pengetahuan dan praktik pertanian yang baik.

-----

### Arsitektur dan Alur Bisnis (Architecture and Business Flow)

Aplikasi ini memiliki arsitektur yang mendukung empat peran pengguna utama:

  * **Petani (Farmer):** Dapat mendaftarkan lahan/aset, mengajukan pendanaan, berbelanja di Toko, mencari layanan di Kebutuhan, dan berkonsultasi dengan Pakar.
  * **Investor:** Berinvestasi, memantau portofolio, dan menarik keuntungan.
  * **Pakar (Expert):** Memberikan konsultasi berbayar dan mengelola jadwal.
  * **Admin (Backend Operator):** Melakukan verifikasi data, moderasi proyek, dan manajemen konten dari portal web backend.

Alur bisnis utama yang terjadi di aplikasi meliputi:

  * **Funding Flow:** Petani mendaftarkan lahan -\> Admin verifikasi -\> Petani mengajukan proposal -\> Admin moderasi -\> Proyek tampil di marketplace Investor -\> Investor mendanai -\> Dana cair ke Dompet Petani.
  * **Support Flow:** Petani membayar sesi konsultasi -\> Pakar menerima notifikasi -\> Konsultasi (video call) dimulai -\> Pakar menerima pembayaran.

-----

### Teknologi yang Digunakan (Technology Stack)

  * **Framework:** Flutter
  * **Bahasa Pemrograman:** Dart
  * **State Management:** GetX
  * **Database (Contoh):** Firestore / Realtime Database
  * **Authentication:** Firebase Auth
  * **Payment Gateway:** Midtrans / DOKU
  * **Video Call:** Agora.io / Twilio
  * **API:** RESTful API untuk komunikasi dengan backend.

-----

### Instalasi dan Pengujian (Installation and Testing)

Untuk menjalankan proyek ini secara lokal, ikuti langkah-langkah berikut:

```bash
# Clone the repository
git clone https://github.com/IlhamRichie/Sobat-Genta-App.git

# Navigate to the project directory
cd sobatgenta

# Get dependencies
flutter pub get

# Run the application
flutter run
```

-----

### Kontributor (Contributors)

  * [M. Ilham Rigan Agachi]

-----

### Lisensi (License)

Proyek ini dilisensikan di bawah [MIT License](https://opensource.org/licenses/MIT).

-----