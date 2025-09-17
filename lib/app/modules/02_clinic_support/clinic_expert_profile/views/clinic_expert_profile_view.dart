import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sobatgenta/app/modules/02_clinic_support/clinic_expert_list/views/clinic_expert_list_view.dart';
import '../../../../data/models/expert_model.dart';
import '../../../01_main_navigation/main_navigation/controllers/main_navigation_controller.dart';
import '../controllers/clinic_expert_profile_controller.dart';

// (Konstanta warna tema konsisten)
const kPrimaryDarkGreen = Color(0xFF3A8A40);
const kLightGreenBlob = Color(0xFFEAF4EB);
const kDarkTextColor = Color(0xFF1B2C1E);
const kBodyTextColor = Color(0xFF5A6A5C);

class ClinicExpertProfileView extends GetView<ClinicExpertProfileController> {
  const ClinicExpertProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // Gunakan CustomScrollView untuk efek AppBar yang modern
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(controller.expertData),
          SliverList(
            delegate: SliverChildListDelegate([
              // Konten di bawah AppBar
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatsRow(),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Tentang Saya'),
                    const SizedBox(height: 8),
                    _buildBiography(),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Ulasan Pengguna (3)'),
                    const SizedBox(height: 16),
                    _buildReviewPlaceholder(), // Placeholder Ulasan
                    _buildReviewPlaceholder(),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ).animate().fadeIn(),

      // --- Tombol Aksi Sticky di Bawah ---
      // (Best Practice: Menggunakan slot bottomNavigationBar)
      bottomNavigationBar: _buildStickyButton(context, controller.expertData),
    );
  }

  // --- Helper Widgets (Best Practice) ---

  Widget _buildSliverAppBar(ExpertModel expert) {
    return SliverAppBar(
      expandedHeight: 250.0,
      backgroundColor: kLightGreenBlob,
      pinned: true,
      stretch: true,
      elevation: 1,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: kDarkTextColor),
        onPressed: () => Get.back(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          // Judul akan mengecil saat di-scroll
          expert.name,
          style: const TextStyle(
              color: kDarkTextColor, fontWeight: FontWeight.bold),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Gambar Pakar sebagai background
            // (Kita bisa ganti dengan Image.network(expert.imageUrl))
            Container(color: kLightGreenBlob),
            // Avatar di tengah
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40), // Ruang untuk status bar
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(expert.imageUrl),
                  ),
                  const SizedBox(height: 12),
                  // (Nama akan muncul di sini saat AppBar di-expand)
                  // (Status Online)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                        color:
                            expert.isOnline ? kPrimaryDarkGreen : Colors.grey,
                        borderRadius: BorderRadius.circular(12)),
                    child: Text(
                      expert.isOnline ? 'Online' : 'Offline',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      // Gunakan spaceEvenly agar padding konsisten
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment:
          CrossAxisAlignment.start, // Agar rata atas jika ada yg wrap
      children: [
        // [FIX] Bungkus setiap item dengan Flexible
        Flexible(
            child: _buildStatItem(FontAwesomeIcons.solidStar, '4.9', 'Rating')),
        Flexible(
            child: _buildStatItem(
                FontAwesomeIcons.solidMessage, '100+', 'Sesi Selesai')),
        Flexible(
            child:
                _buildStatItem(FontAwesomeIcons.award, '5 Thn', 'Pengalaman')),
      ],
    ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.5);
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        FaIcon(icon, color: kPrimaryDarkGreen, size: 28),
        const SizedBox(height: 8),
        Text(value,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: kDarkTextColor)),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: kBodyTextColor, fontSize: 14),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, color: kDarkTextColor),
    );
  }

  Widget _buildBiography() {
    return const Text(
      'Drh. Anita Dewi adalah dokter hewan lulusan IPB dengan pengalaman 5 tahun menangani ternak besar dan unggas. Beliau berfokus pada pencegahan penyakit dan nutrisi pakan ternak...',
      style: TextStyle(color: kBodyTextColor, fontSize: 16, height: 1.5),
    );
  }

  Widget _buildReviewPlaceholder() {
    // (Placeholder untuk UI Ulasan Pengguna)
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: kTextFieldBorder),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          CircleAvatar(radius: 20, child: Text('P')),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Petani Jaya',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Sangat membantu! Ternak saya sehat kembali.',
                    style: TextStyle(color: kBodyTextColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- [SR-KYC-02] Tombol Aksi Sticky yang Reaktif terhadap KYC ---
  Widget _buildStickyButton(BuildContext context, ExpertModel expert) {
    return Obx(() {
      final kycStatus = controller.mainNavController.kycStatus.value;
      final bool isLocked = (kycStatus != UserKycStatus.verified);

      return Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 15)
          ],
        ),
        child: Column(
          // Ganti dari Row menjadi Column
          mainAxisSize:
              MainAxisSize.min, // Agar Column tidak memakan ruang berlebih
          crossAxisAlignment:
              CrossAxisAlignment.stretch, // Agar anak-anaknya merentang penuh
          children: [
            // Teks Harga di atas tombol
            Text(
              'Rp ${expert.price} /sesi',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: kDarkTextColor, // Warna yang lebih gelap agar terbaca
              ),
              textAlign: TextAlign.center, // Pusatkan teks
            ),
            const SizedBox(height: 12), // Spasi antara teks harga dan tombol

            // Tombol Mulai Konsultasi
            ElevatedButton(
              onPressed:
                  isLocked ? null : () => controller.startConsultation(context),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isLocked ? Colors.grey.shade400 : kPrimaryDarkGreen,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              // Hapus teks harga dari sini
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Pusatkan isi tombol
                mainAxisSize: MainAxisSize.min, // Agar Row hanya selebar isinya
                children: [
                  Text(
                    'Mulai Konsultasi',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  if (isLocked)
                    const Icon(Icons.lock, size: 20)
                    else
                    const Icon(FontAwesomeIcons.solidMessage, size: 18, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
