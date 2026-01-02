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
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // 1. BACKGROUND DECORATION (Consistent Theme)
          Positioned(
            top: -80,
            right: -60,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.05), // Nuansa biru untuk medis/klinik
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 150,
            left: -80,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // 2. MAIN CONTENT
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCustomAppBar(),
                  const SizedBox(height: 24),
                  
                  _buildAiScanBanner(),
                  const SizedBox(height: 32),
                  
                  _buildCategorySection(),
                  const SizedBox(height: 32),
                  
                  _buildFeaturedPakarSection(),
                  const SizedBox(height: 32),
                  
                  _buildDigitalLibrarySection(),
                  const SizedBox(height: 100), // Bottom padding
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Custom AppBar
  Widget _buildCustomAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Klinik Genta",
              style: Get.textTheme.headlineSmall?.copyWith(
                color: AppColors.textDark,
                fontWeight: FontWeight.w800,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Solusi kesehatan tanaman & ternak",
              style: Get.textTheme.bodyMedium?.copyWith(
                color: AppColors.textLight,
                fontSize: 14,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const FaIcon(FontAwesomeIcons.userDoctor, size: 20, color: AppColors.primary),
        ),
      ],
    );
  }

  /// Header AI Scan (Modern Gradient Card)
  Widget _buildAiScanBanner() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, Color(0xFF4CAF50)], // Gradasi Hijau Segar
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Dekorasi Background
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(
              FontAwesomeIcons.robot,
              size: 140,
              color: Colors.white.withOpacity(0.15),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      FaIcon(FontAwesomeIcons.wandMagicSparkles, size: 12, color: Colors.white),
                      SizedBox(width: 6),
                      Text(
                        "AI Diagnosis",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Tanaman Sakit?",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Scan daun atau hewan untuk deteksi penyakit instan.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: controller.goToAiScan,
                  icon: const FaIcon(FontAwesomeIcons.camera, size: 16, color: AppColors.primary),
                  label: const Text("Scan Sekarang"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Kategori (Clean Chips)
  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader("Kategori Layanan", showViewAll: false),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildCategoryCard(
                "Pertanian",
                FontAwesomeIcons.leaf,
                AppColors.primary,
                () => controller.goToPakarList('PERTANIAN'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildCategoryCard(
                "Peternakan",
                FontAwesomeIcons.cow,
                Colors.brown,
                () => controller.goToPakarList('PETERNAKAN'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryCard(String label, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.greyLight),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: FaIcon(icon, size: 24, color: color),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Featured Pakar (Horizontal List)
  Widget _buildFeaturedPakarSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          "Pakar Rekomendasi", 
          onViewAll: () => controller.goToPakarList('ALL')
        ),
        const SizedBox(height: 16),
        Obx(() {
          if (controller.isLoadingPakar.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.featuredPakarList.isEmpty) {
            return _buildEmptyState("Belum ada pakar tersedia.");
          }

          return SizedBox(
            height: 260, // Tinggi area scroll
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: controller.featuredPakarList.length,
              separatorBuilder: (ctx, i) => const SizedBox(width: 16),
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

  Widget _buildPakarCard(PakarProfileModel pakar) {
    bool isOnline = pakar.isAvailable;
    return Container(
      width: 170,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () => controller.goToPakarDetail(pakar),
          borderRadius: BorderRadius.circular(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image & Badge Container
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    child: Container(
                      height: 120,
                      width: double.infinity,
                      color: AppColors.greyLight,
                      child: pakar.user.profilePictureUrl != null && pakar.user.profilePictureUrl!.isNotEmpty
                          ? Image.network(
                              pakar.user.profilePictureUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (c, e, s) => const Icon(Icons.person, color: Colors.grey),
                            )
                          : const Center(child: FaIcon(FontAwesomeIcons.userDoctor, color: Colors.grey)),
                    ),
                  ),
                  // Online Status Badge
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isOnline ? Colors.green : Colors.grey,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6, height: 6,
                            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isOnline ? "Online" : "Offline",
                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
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
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      pakar.specialization,
                      style: const TextStyle(color: AppColors.textLight, fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          rupiahFormatter.format(pakar.consultationFee),
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.arrow_forward_rounded, size: 14, color: AppColors.primary),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Digital Library (Vertical List)
  Widget _buildDigitalLibrarySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          "Perpustakaan Digital",
          onViewAll: controller.goToDigitalLibrary,
        ),
        const SizedBox(height: 16),
        
        // List Item
        Column(
          children: controller.featuredArticles.map((article) => _buildLibraryItem(article)).toList(),
        ),
      ],
    );
  }

  Widget _buildLibraryItem(Map<String, String> article) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        onTap: () { /* TODO: Detail Article */ },
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.greyLight,
            borderRadius: BorderRadius.circular(12),
            // image: DecorationImage(...) // Jika ada gambar
          ),
          child: const Center(child: FaIcon(FontAwesomeIcons.bookOpen, color: Colors.grey, size: 20)),
        ),
        title: Text(
          article['title']!,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  article['category']!,
                  style: const TextStyle(fontSize: 10, color: AppColors.textDark, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
      ),
    );
  }

  /// Helper untuk Section Header
  Widget _buildSectionHeader(String title, {VoidCallback? onViewAll, bool showViewAll = true}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        if (showViewAll && onViewAll != null)
          GestureDetector(
            onTap: onViewAll,
            child: const Text(
              "Lihat Semua",
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.greyLight.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          message,
          style: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}