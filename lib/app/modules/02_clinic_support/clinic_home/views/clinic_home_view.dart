// lib/app/modules/clinic_home/views/clinic_home_view.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../data/models/pakar_profile_model.dart';
import '../../../../theme/app_colors.dart';
import '../controllers/clinic_home_controller.dart';

class ClinicHomeView extends GetView<ClinicHomeController> {
  ClinicHomeView({Key? key}) : super(key: key);
  
  final rupiahFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Klinik"),
        // Ini adalah root tab, tidak perlu back button
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildCategorySection(),
            const SizedBox(height: 24),
            _buildFeaturedPakarSection(), // Skenario 3
            const SizedBox(height: 24),
            _buildDigitalLibrarySection(), //
          ],
        ),
      ),
    );
  }

  /// Header dengan shortcut ke AI Scan
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Punya Masalah?",
                  style: Get.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  "Coba scan hama atau penyakit tanaman/ternak Anda dengan AI.",
                  style: Get.textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: controller.goToAiScan,
                  icon: const FaIcon(FontAwesomeIcons.camera, size: 16),
                  label: const Text("Scan Sekarang"),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const FaIcon(FontAwesomeIcons.robot, size: 60, color: AppColors.primary),
        ],
      ),
    );
  }

  /// Bagian Kategori (Pertanian/Peternakan)
  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text("Cari Bantuan Ahli", style: Get.textTheme.titleLarge?.copyWith(fontSize: 18)),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
              // Skenario 3: Budi memfilter "Peternakan"
              () => controller.goToPakarList('PETERNAKAN'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryButton(String label, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: Get.width * 0.4,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            FaIcon(icon, size: 32, color: color),
            const SizedBox(height: 12),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  /// Bagian Pakar Unggulan (menampilkan Drh. Santoso)
  Widget _buildFeaturedPakarSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Pakar Online", style: Get.textTheme.titleLarge?.copyWith(fontSize: 18)),
              TextButton(
                onPressed: () => controller.goToPakarList('ALL'), // Tampilkan semua
                child: const Text("Lihat Semua"),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Obx(() {
          if (controller.isLoadingPakar.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.featuredPakarList.isEmpty) {
            return const Center(child: Text("Belum ada pakar tersedia."));
          }
          
          return SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
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

  /// Kartu untuk satu Pakar
  Widget _buildPakarCard(PakarProfileModel pakar) {
    bool isOnline = pakar.isAvailable;
    return SizedBox(
      width: 160,
      child: Card(
        elevation: 1,
        child: InkWell(
          onTap: () => controller.goToPakarDetail(pakar),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Foto & Status Online
              Stack(
                children: [
                  Container(
                    height: 100,
                    width: 160,
                    decoration: BoxDecoration(
                      color: AppColors.greyLight,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    ),
                    child: const Center(child: FaIcon(FontAwesomeIcons.userDoctor, color: Colors.grey)),
                  ),
                  Positioned(
                    top: 8, right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isOnline ? Colors.green.shade700 : Colors.grey.shade600,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        isOnline ? "Online" : "Offline",
                        style: Get.textTheme.bodySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
              // Info
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pakar.user.fullName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      pakar.specialization,
                      style: Get.textTheme.bodySmall?.copyWith(color: AppColors.textLight),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      rupiahFormatter.format(pakar.consultationFee),
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// Bagian Artikel Perpustakaan Digital (Mock Lokal)
  Widget _buildDigitalLibrarySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Perpustakaan Digital", style: Get.textTheme.titleLarge?.copyWith(fontSize: 18)),
              TextButton(
                onPressed: controller.goToDigitalLibrary,
                child: const Text("Lihat Semua"),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Gunakan data mock lokal dari controller
        ...controller.featuredArticles.map((article) => Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade300)
            ),
            leading: Container(
              width: 60, height: 60,
              decoration: BoxDecoration(color: AppColors.greyLight, borderRadius: BorderRadius.circular(8)),
              child: const FaIcon(FontAwesomeIcons.image, color: Colors.grey),
            ),
            title: Text(article['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(article['category']!),
            onTap: () { /* TODO: Navigasi ke detail artikel */ },
          ),
        )).toList(),
      ],
    );
  }
}