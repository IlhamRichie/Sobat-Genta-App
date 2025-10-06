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
      backgroundColor: AppColors.background, // Set background color
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: controller.fetchDashboardData,
        child: SingleChildScrollView( // Menggunakan SingleChildScrollView untuk fleksibilitas
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWalletCard(),
              const SizedBox(height: 24),
              _buildShortcutGrid(),
              const SizedBox(height: 24),
              _buildAssetSummary(),
              const SizedBox(height: 24),
              _buildPromoBanners(),
              const SizedBox(height: 24), // Tambahan padding
            ],
          ),
        ),
      ),
    );
  }

  // AppBar
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Selamat Datang,",
            style: Get.textTheme.bodyMedium?.copyWith(
              color: AppColors.textLight,
              fontSize: 14,
            ),
          ),
          Text(
            controller.userName,
            style: Get.textTheme.titleLarge?.copyWith(
              color: AppColors.textDark,
              fontSize: 22, // Ukuran font lebih besar
              fontWeight: FontWeight.bold, // Bold untuk hierarki
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

  // Widget 1: Kartu Dompet (Diperbarui)
  Widget _buildWalletCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20), // Sudut lebih rounded
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 15, // Efek shadow yang lebih halus
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Total Saldo Dompet",
            style: Get.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 8),
          Obx(() => controller.isLoading.value
              ? const SizedBox(
                  height: 32,
                  width: 32,
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : Text(
                  controller.walletBalance.value,
                  style: Get.textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )),
          const SizedBox(height: 24), // Spasi lebih besar
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2), // Warna latar belakang semi-transparan
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.4)),
                  ),
                  child: TextButton.icon(
                    onPressed: controller.goToWallet,
                    icon: const FaIcon(FontAwesomeIcons.wallet, size: 16, color: Colors.white),
                    label: const Text(
                      "Lihat Dompet",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => Get.toNamed('/wallet-top-up'),
                  icon: const FaIcon(FontAwesomeIcons.plus, color: AppColors.primary, size: 16),
                  label: const Text("Top Up"),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget 2: Grid Shortcut (Diperbarui & Mengatasi Overflow)
  Widget _buildShortcutGrid() {
    // Menghilangkan GridView.count dan menggantinya dengan Row + Column
    // Ini lebih baik karena kita tidak perlu NeverScrollableScrollPhysics
    // yang sering menjadi penyebab RenderFlex overflow.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Menu Utama",
          style: Get.textTheme.titleLarge?.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildShortcutItem(
              icon: FontAwesomeIcons.store,
              label: "Toko",
              onTap: controller.goToStore,
              color: AppColors.primary, // Menggunakan warna dari theme
            ),
            _buildShortcutItem(
              icon: FontAwesomeIcons.stethoscope,
              label: "Klinik",
              onTap: controller.goToClinic,
              color: AppColors.primary,
            ),
            _buildShortcutItem(
              icon: FontAwesomeIcons.bullhorn,
              label: "Tender",
              onTap: controller.goToTender,
              color: AppColors.primary,
            ),
            _buildShortcutItem(
              icon: FontAwesomeIcons.solidHeart,
              label: "Komunitas",
              onTap: () {},
              color: AppColors.primary,
            ),
          ],
        ),
      ],
    );
  }

  // Helper untuk item shortcut (Diperbarui)
  Widget _buildShortcutItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded( // Gunakan Expanded agar item membagi ruang secara merata
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            Container(
              width: 56, // Ukuran ikon lebih besar
              height: 56,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color, size: 28), // Ukuran ikon lebih besar
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: Get.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // Widget 3: Ringkasan Aset Lahan (Diperbarui)
  Widget _buildAssetSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Aset Anda",
              style: Get.textTheme.titleLarge?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: controller.goToManageAssets,
              child: Text(
                "Lihat Semua",
                style: TextStyle(color: AppColors.primary),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Obx(() => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: FaIcon(FontAwesomeIcons.mapLocationDot, color: AppColors.primary, size: 20),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Total Lahan Terdaftar",
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Lahan Pertanian & Peternakan",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      controller.landCount.value.toString(),
                      style: Get.textTheme.titleLarge?.copyWith(
                        color: AppColors.primary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )),
      ],
    );
  }

  // Widget 4: Placeholder untuk Banner/Artikel (Diperbarui)
  Widget _buildPromoBanners() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Info & Promo",
          style: Get.textTheme.titleLarge?.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 150, // Tinggi lebih proporsional
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.greyLight,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: const Center(
            child: Text(
              "Banner Promo Akan Tampil di Sini",
              style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
            ),
          ),
        ),
      ],
    );
  }
}
