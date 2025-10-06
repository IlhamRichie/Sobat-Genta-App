// lib/app/modules/register_role_chooser/views/register_role_chooser_view.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../theme/app_colors.dart';
import '../controllers/register_role_chooser_controller.dart';

class RegisterRoleChooserView extends GetView<RegisterRoleChooserController> {
  const RegisterRoleChooserView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            Text(
              "Pilih Peran Anda",
              style: Get.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: AppColors.textDark,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "Setiap peran memiliki fitur dan manfaat yang berbeda.",
              style: Get.textTheme.bodyMedium?.copyWith(
                fontSize: 14, // Ukuran font sedikit dikecilkan
                color: AppColors.textLight,
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            
            // --- Card 1: Petani ---
            _buildRoleCard(
              icon: FontAwesomeIcons.leaf,
              role: "Saya Petani",
              description: "Ajukan pendanaan, kelola lahan, dan beli kebutuhan tani.",
              color: AppColors.primary,
              onTap: controller.navigateToFarmerRegistration,
            ),
            const Spacer(),

            // --- Card 2: Investor ---
            _buildRoleCard(
              icon: FontAwesomeIcons.chartLine,
              role: "Saya Investor",
              description: "Temukan proyek pertanian & dapatkan imbal hasil.",
              color: AppColors.accent,
              onTap: controller.navigateToInvestorRegistration,
            ),
            const Spacer(),

            // --- Card 3: Pakar ---
            _buildRoleCard(
              icon: FontAwesomeIcons.userDoctor,
              role: "Saya Pakar",
              description: "Beri konsultasi (ahli tani/dokter hewan) & dapatkan penghasilan.",
              color: Colors.blue.shade700,
              onTap: controller.navigateToExpertRegistration,
            ),
            const Spacer(flex: 2), // Spasi lebih besar di bawah kartu
          ],
        ),
      ),
      bottomNavigationBar: _buildLoginRedirect(),
    );
  }

  /// AppBar Kustom (Konsisten)
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: const BackButton(color: AppColors.textDark),
      title: Text(
        "Mendaftar",
        style: Get.textTheme.headlineSmall?.copyWith(
          color: AppColors.textDark,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: false,
    );
  }

  /// Widget Reusable untuk Kartu Pilihan Peran (Didesain Ulang)
  Widget _buildRoleCard({
    required IconData icon,
    required String role,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            FaIcon(icon, size: 32, color: color), // Ukuran ikon tetap besar
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    role,
                    style: Get.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Get.textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
            ),
            FaIcon(FontAwesomeIcons.chevronRight, size: 16, color: AppColors.textLight.withOpacity(0.5)),
          ],
        ),
      ),
    );
  }

  /// Widget untuk link "Sudah punya akun?" di bawah (Didesain Ulang)
  Widget _buildLoginRedirect() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.greyLight)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Sudah punya akun?', style: Get.textTheme.bodyMedium),
          TextButton(
            onPressed: controller.navigateToLogin,
            child: const Text(
              'Login di sini',
              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}