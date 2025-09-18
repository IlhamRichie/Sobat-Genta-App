// lib/app/modules/home_dashboard/views/home_dashboard_view.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../theme/app_colors.dart';
import '../controllers/home_dashboard_controller.dart';

class HomeDashboardView extends GetView<HomeDashboardController> {
  const HomeDashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        // BEST PRACTICE: Tambahkan RefreshIndicator
        onRefresh: controller.fetchDashboardData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWalletCard(),
              const SizedBox(height: 24),
              _buildShortcutGrid(),
              const SizedBox(height: 24),
              _buildAssetSummary(),
              const SizedBox(height: 24),
              _buildPromoBanners(), // Placeholder
            ],
          ),
        ),
      ),
    );
  }

  /// AppBar Khusus untuk Halaman Home
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Selamat Datang,",
            style: Get.textTheme.bodyMedium?.copyWith(color: AppColors.textLight),
          ),
          Text(
            controller.userName, // "Budi (Petani)"
            style: Get.textTheme.titleLarge?.copyWith(
              color: AppColors.textDark, 
              fontSize: 20,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () { /* TODO: Go to Notification Page */ },
          icon: const FaIcon(FontAwesomeIcons.solidBell, color: AppColors.textLight),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  /// Widget 1: Kartu Dompet
  Widget _buildWalletCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: AppColors.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Total Saldo Dompet",
              style: Get.textTheme.bodyMedium?.copyWith(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            // Dengarkan state isLoading dan walletBalance
            Obx(() => controller.isLoading.value
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                : Text(
                    controller.walletBalance.value,
                    style: Get.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontSize: 28,
                    ),
                  )),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: controller.goToWallet,
                    icon: const FaIcon(FontAwesomeIcons.wallet, size: 16),
                    label: const Text("Lihat Dompet"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.white.withOpacity(0.1),
                      side: const BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () { /* TODO: Go to Top Up */ },
                    icon: const FaIcon(FontAwesomeIcons.plus, size: 16),
                    label: const Text("Top Up"),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Widget 2: Grid Shortcut
  Widget _buildShortcutGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Menu Utama", style: Get.textTheme.titleLarge?.copyWith(fontSize: 18)),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            _buildShortcutItem(
              icon: FontAwesomeIcons.store,
              label: "Toko",
              onTap: controller.goToStore,
              color: Colors.orange.shade700,
            ),
            _buildShortcutItem(
              icon: FontAwesomeIcons.stethoscope,
              label: "Klinik",
              onTap: controller.goToClinic,
              color: Colors.blue.shade700,
            ),
            _buildShortcutItem(
              icon: FontAwesomeIcons.bullhorn,
              label: "Tender",
              onTap: controller.goToTender,
              color: Colors.purple.shade700,
            ),
            _buildShortcutItem(
              icon: FontAwesomeIcons.solidHeart,
              label: "Komunitas",
              onTap: () {},
              color: Colors.red.shade700,
            ),
          ],
        ),
      ],
    );
  }
  
  // Helper untuk item shortcut
  Widget _buildShortcutItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(label, style: Get.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  /// Widget 3: Ringkasan Aset Lahan
  Widget _buildAssetSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Aset Anda", style: Get.textTheme.titleLarge?.copyWith(fontSize: 18)),
            TextButton(
              onPressed: controller.goToManageAssets,
              child: const Text("Lihat Semua"),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Obx(() => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
                leading: FaIcon(FontAwesomeIcons.mapLocationDot, color: AppColors.primary),
                title: Text("Total Lahan Terdaftar", style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text("Lahan Pertanian & Peternakan"),
                trailing: Text(
                  controller.landCount.value.toString(),
                  style: Get.textTheme.titleLarge?.copyWith(color: AppColors.primary),
                ),
                onTap: controller.goToManageAssets,
              ),
        ),
      ],
    );
  }

  /// Widget 4: Placeholder untuk Banner/Artikel
  Widget _buildPromoBanners() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Info & Promo", style: Get.textTheme.titleLarge?.copyWith(fontSize: 18)),
        const SizedBox(height: 16),
        Container(
          height: 140,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.greyLight,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Text("Banner Promo Akan Tampil di Sini"),
          ),
        ),
      ],
    );
  }
}