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
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // 1. BACKGROUND DECORATION (Agar tidak flat)
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 150,
            left: -80,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // 2. MAIN CONTENT
          SafeArea(
            child: RefreshIndicator(
              onRefresh: controller.fetchDashboardData,
              color: AppColors.primary,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCustomAppBar(),
                    const SizedBox(height: 24),
                    
                    _buildWalletCard(),
                    const SizedBox(height: 28),
                    
                    _buildSectionTitle("Menu Utama"),
                    const SizedBox(height: 16),
                    _buildShortcutGrid(),
                    
                    const SizedBox(height: 28),
                    _buildAssetSummary(),
                    
                    const SizedBox(height: 28),
                    _buildPromoSection(),
                    
                    const SizedBox(height: 100), // Bottom padding untuk navigasi bar
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET COMPONENTS ---

  /// 1. Custom AppBar (Nama User & Notifikasi)
  Widget _buildCustomAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Selamat Pagi, ☀️",
              style: Get.textTheme.bodyMedium?.copyWith(
                color: AppColors.textLight,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            // HAPUS OBX DI SINI KARENA userName BUKAN OBSERVABLE
            Text( 
              controller.userName.isNotEmpty ? controller.userName : "Sobat Genta",
              style: Get.textTheme.headlineSmall?.copyWith(
                color: AppColors.textDark,
                fontWeight: FontWeight.w800, 
                fontSize: 22,
              ),
            ),
          ],
        ),
        Container(
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
          child: IconButton(
            onPressed: () { /* TODO: Notification Page */ },
            icon: const FaIcon(FontAwesomeIcons.solidBell, size: 20),
            color: AppColors.primary,
            splashRadius: 24,
          ),
        ),
      ],
    );
  }

  /// 2. Wallet Card (Premium Gradient Style)
  Widget _buildWalletCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
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
          // Dekorasi Lingkaran Transparan di dalam kartu
          Positioned(
            right: -20,
            top: -20,
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white.withOpacity(0.1),
            ),
          ),
          Positioned(
            bottom: -30,
            left: -10,
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white.withOpacity(0.1),
            ),
          ),
          
          // Konten Kartu
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const FaIcon(FontAwesomeIcons.wallet, color: Colors.white, size: 16),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "GentaPay",
                      style: Get.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  "Total Saldo Aktif",
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 4),
                Obx(() => controller.isLoading.value
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: SizedBox(
                          height: 24, 
                          width: 24, 
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        ),
                      )
                    : Text(
                        controller.walletBalance.value,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      )
                ),
                const SizedBox(height: 24),
                
                // Tombol Aksi
                Row(
                  children: [
                    Expanded(
                      child: _buildWalletActionButton(
                        icon: FontAwesomeIcons.plus,
                        label: "Isi Saldo",
                        onTap: () => Get.toNamed('/wallet-top-up'), // Pastikan route ada
                        isPrimary: true,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildWalletActionButton(
                        icon: FontAwesomeIcons.clockRotateLeft,
                        label: "Riwayat",
                        onTap: controller.goToWallet,
                        isPrimary: false,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletActionButton({
    required IconData icon, 
    required String label, 
    required VoidCallback onTap,
    bool isPrimary = true,
  }) {
    return Material(
      color: isPrimary ? Colors.white : Colors.white.withOpacity(0.2),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(
                icon, 
                size: 14, 
                color: isPrimary ? AppColors.primary : Colors.white
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isPrimary ? AppColors.primary : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 3. Grid Menu Shortcuts (Modern Icons)
  Widget _buildShortcutGrid() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildShortcutItem(
          icon: FontAwesomeIcons.shop,
          label: "Toko Tani",
          color: Colors.orange,
          onTap: controller.goToStore,
        ),
        _buildShortcutItem(
          icon: FontAwesomeIcons.userDoctor,
          label: "Konsultasi",
          color: Colors.blue,
          onTap: controller.goToClinic,
        ),
        _buildShortcutItem(
          icon: FontAwesomeIcons.fileContract,
          label: "Tender",
          color: Colors.purple,
          onTap: controller.goToTender,
        ),
        _buildShortcutItem(
          icon: FontAwesomeIcons.users,
          label: "Komunitas",
          color: AppColors.primary,
          onTap: controller.goToCommunity, // TODO: Add Community Route
        ),
      ],
    );
  }

  Widget _buildShortcutItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1), // Background lembut sesuai warna ikon
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: FaIcon(icon, color: color, size: 26),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
      ],
    );
  }

  /// 4. Asset Summary (Dashboard Widget Style)
  Widget _buildAssetSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.greyLight),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Aset Terdaftar",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              GestureDetector(
                onTap: controller.goToManageAssets,
                child: const Text(
                  "Kelola",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const FaIcon(FontAwesomeIcons.tree, color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => Text(
                      controller.landCount.value.toString(),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                      ),
                    )),
                    const Text(
                      "Lahan Produktif",
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.greyLight),
            ],
          ),
        ],
      ),
    );
  }

  /// 5. Promo/News Section (Carousel Look)
  Widget _buildPromoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Info & Promo Spesial"),
        const SizedBox(height: 16),
        SizedBox(
          height: 160,
          child: PageView.builder(
            controller: PageController(viewportFraction: 0.9),
            padEnds: false, // Align left
            itemCount: 3,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: const DecorationImage(
                    image: AssetImage('assets/onboarding/onboarding_market.png'), // Placeholder
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(Colors.black26, BlendMode.darken), // Gelapkan dikit biar teks kebaca
                  ),
                  color: AppColors.greyLight,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          "PROMO",
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textDark),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Diskon Pupuk Organik hingga 50%",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Helper untuk Judul Seksi
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.textDark,
      ),
    );
  }
}