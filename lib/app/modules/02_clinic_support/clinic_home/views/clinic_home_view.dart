// lib/app/modules/clinic_home/views/clinic_home_view.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../data/models/pakar_profile_model.dart';
import '../../../../theme/app_colors.dart'; // Pastikan AppColors sudah didefinisikan dengan baik
import '../controllers/clinic_home_controller.dart';

class ClinicHomeView extends GetView<ClinicHomeController> {
  ClinicHomeView({Key? key}) : super(key: key);

  final rupiahFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // Konsisten dengan HomeDashboard
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0, // AppBar modern umumnya tanpa shadow
        title: Text(
          "Klinik",
          style: Get.textTheme.headlineSmall?.copyWith(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false, // Judul rata kiri
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16), // Padding konsisten
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 32), // Spasi lebih lega
            _buildCategorySection(),
            const SizedBox(height: 32),
            _buildFeaturedPakarSection(),
            const SizedBox(height: 32),
            _buildDigitalLibrarySection(),
            const SizedBox(height: 24), // Padding bawah
          ],
        ),
      ),
    );
  }

  /// Header dengan shortcut ke AI Scan (Diperbarui)
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24), // Padding lebih besar
      decoration: BoxDecoration(
        color: AppColors.primary, // Menggunakan warna primary penuh untuk kesan premium
        borderRadius: BorderRadius.circular(24), // Sudut lebih rounded
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10), // Shadow lebih menonjol
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Align to top
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Punya Masalah?",
                  style: Get.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Teks putih di latar hijau
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Coba scan hama atau penyakit tanaman/ternak Anda dengan AI untuk diagnosis cepat.",
                  style: Get.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 20), // Spasi lebih lega
                ElevatedButton.icon( // Menggunakan ElevatedButton untuk tampilan modern
                  onPressed: controller.goToAiScan,
                  icon: const FaIcon(FontAwesomeIcons.camera, size: 16, color: AppColors.primary),
                  label: const Text(
                    "Scan Sekarang",
                    style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Tombol putih
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    elevation: 5, // Shadow untuk tombol
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Ikon robot lebih besar dan ditaruh di dalam Container dengan background ringan
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const FaIcon(FontAwesomeIcons.robot, size: 64, color: Colors.white),
          ),
        ],
      ),
    );
  }

  /// Bagian Kategori (Diperbarui)
  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0), // Padding disesuaikan dengan SingleChildScrollView
          child: Text(
            "Cari Bantuan Ahli",
            style: Get.textTheme.titleLarge?.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround, // Atau spaceBetween jika ingin merapat ke tepi
          children: [
            _buildCategoryButton(
              "Pertanian",
              FontAwesomeIcons.leaf,
              Colors.green.shade700,
              () => controller.goToPakarList('PERTANIAN'),
            ),
            _buildCategoryButton(
              "Peternakan",
              FontAwesomeIcons.cow,
              Colors.brown.shade700,
              () => controller.goToPakarList('PETERNAKAN'),
            ),
            // Jika ada lebih banyak kategori, pertimbangkan GridView.builder
          ],
        ),
      ],
    );
  }

  /// Helper untuk Category Button (Diperbarui)
  Widget _buildCategoryButton(String label, IconData icon, Color color, VoidCallback onTap) {
    return Expanded( // Menggunakan Expanded agar responsif terhadap lebar layar
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12), // Padding lebih besar
          margin: const EdgeInsets.symmetric(horizontal: 8), // Margin antar tombol
          decoration: BoxDecoration(
            color: Colors.white, // Latar belakang putih
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              FaIcon(icon, size: 36, color: color), // Ikon lebih besar
              const SizedBox(height: 16), // Spasi lebih besar
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16, // Ukuran font lebih besar
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Bagian Pakar Unggulan (Diperbarui)
  Widget _buildFeaturedPakarSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Pakar Online",
                style: Get.textTheme.titleLarge?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () => controller.goToPakarList('ALL'),
                child: Text(
                  "Lihat Semua",
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Obx(() {
          if (controller.isLoadingPakar.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.featuredPakarList.isEmpty) {
            return const Center(child: Text("Belum ada pakar tersedia."));
          }

          return SizedBox(
            height: 240, // Tinggi card disesuaikan
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 0), // Padding dihapus di sini karena sudah ada di _buildPakarCard
              itemCount: controller.featuredPakarList.length,
              itemBuilder: (context, index) {
                final pakar = controller.featuredPakarList[index];
                return _buildPakarCard(pakar);
              },
            ),
          );
        }),
      ],
    );
  }

  /// Kartu untuk satu Pakar (Diperbarui)
  Widget _buildPakarCard(PakarProfileModel pakar) {
    bool isOnline = pakar.isAvailable;
    return Container(
      width: 180, // Lebar card sedikit lebih besar
      margin: const EdgeInsets.only(right: 16), // Margin antar card
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20), // Sudut lebih rounded
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => controller.goToPakarDetail(pakar),
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto & Status Online
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)), // Hanya bagian atas
                  child: pakar.user.profilePictureUrl != null && pakar.user.profilePictureUrl!.isNotEmpty
                      ? Image.network(
                          pakar.user.profilePictureUrl!,
                          height: 120, // Tinggi gambar lebih besar
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 120,
                            width: double.infinity,
                            color: AppColors.greyLight,
                            child: const Center(child: FaIcon(FontAwesomeIcons.userDoctor, color: Colors.grey, size: 40)),
                          ),
                        )
                      : Container(
                          height: 120,
                          width: double.infinity,
                          color: AppColors.greyLight,
                          child: const Center(child: FaIcon(FontAwesomeIcons.userDoctor, color: Colors.grey, size: 40)),
                        ),
                ),
                Positioned(
                  top: 12, right: 12, // Posisi sedikit lebih masuk
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isOnline ? Colors.green : Colors.grey.shade600, // Warna lebih kuat
                      borderRadius: BorderRadius.circular(16), // Rounded lebih besar
                    ),
                    child: Text(
                      isOnline ? "Online" : "Offline",
                      style: Get.textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                )
              ],
            ),
            // Info
            Padding(
              padding: const EdgeInsets.all(16.0), // Padding lebih besar
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pakar.user.fullName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    pakar.specialization,
                    style: Get.textTheme.bodySmall?.copyWith(
                      color: AppColors.textLight,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    rupiahFormatter.format(pakar.consultationFee),
                    style: Get.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  /// Bagian Artikel Perpustakaan Digital (Diperbarui)
  Widget _buildDigitalLibrarySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Perpustakaan Digital",
                style: Get.textTheme.titleLarge?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: controller.goToDigitalLibrary,
                child: Text(
                  "Lihat Semua",
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Menggunakan ListView.builder untuk daftar artikel agar lebih dinamis
        // dan bisa di-scroll jika artikel terlalu banyak, atau diganti dengan Column jika selalu sedikit
        Column(
          children: controller.featuredArticles.map((article) => Padding(
            padding: const EdgeInsets.only(bottom: 12), // Jarak antar item
            child: _buildArticleListItem(article),
          )).toList(),
        ),
      ],
    );
  }

  /// Helper untuk Item Artikel (Diperbarui)
  Widget _buildArticleListItem(Map<String, String> article) {
    return InkWell(
      onTap: () { /* TODO: Navigasi ke detail artikel */ },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 70,
                height: 70,
                color: AppColors.greyLight,
                child: const Center(child: FaIcon(FontAwesomeIcons.image, color: Colors.grey, size: 28)), // Placeholder
                // Jika ada gambar, gunakan Image.network:
                // child: Image.network(
                //   article['imageUrl']!, // Pastikan ada imageUrl di model
                //   fit: BoxFit.cover,
                //   errorBuilder: (context, error, stackTrace) => const Center(child: FaIcon(FontAwesomeIcons.image, color: Colors.grey)),
                // ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article['title']!,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    article['category']!,
                    style: Get.textTheme.bodySmall?.copyWith(color: AppColors.textLight),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}