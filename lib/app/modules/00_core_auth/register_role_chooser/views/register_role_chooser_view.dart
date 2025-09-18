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
      appBar: AppBar(
        title: const Text("Mulai Mendaftar"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: AppColors.textDark),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Pilih Peran Anda",
              style: Get.textTheme.titleLarge?.copyWith(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "Setiap peran memiliki fitur dan manfaat yang berbeda.",
              style: Get.textTheme.bodyMedium?.copyWith(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            
            // --- Card 1: Petani ---
            _buildRoleCard(
              icon: FontAwesomeIcons.leaf,
              role: "Saya Petani",
              description: "Ajukan pendanaan, kelola lahan, dan beli kebutuhan tani.",
              color: AppColors.primary, // Warna hijau tema kita
              onTap: controller.navigateToFarmerRegistration,
            ),
            const SizedBox(height: 20),

            // --- Card 2: Investor ---
            _buildRoleCard(
              icon: FontAwesomeIcons.chartLine,
              role: "Saya Investor",
              description: "Temukan proyek pertanian & dapatkan imbal hasil.",
              color: AppColors.accent, // Warna kuning aksen kita
              onTap: controller.navigateToInvestorRegistration,
            ),
            const SizedBox(height: 20),

            // --- Card 3: Pakar ---
            _buildRoleCard(
              icon: FontAwesomeIcons.userDoctor, // Sesuai Skenario 3
              role: "Saya Pakar",
              description: "Beri konsultasi (ahli tani/dokter hewan) & dapatkan penghasilan.",
              color: Colors.blue.shade700,
              onTap: controller.navigateToExpertRegistration,
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildLoginRedirect(),
    );
  }

  /// Widget Reusable untuk Kartu Pilihan Peran
  /// BEST PRACTICE: Memecah UI kompleks menjadi widget/method
  Widget _buildRoleCard({
    required IconData icon,
    required String role,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3), width: 1.5),
        ),
        child: Row(
          children: [
            FaIcon(icon, size: 36, color: color),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    role,
                    style: Get.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
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
            FaIcon(FontAwesomeIcons.chevronRight, size: 16, color: color.withOpacity(0.7)),
          ],
        ),
      ),
    );
  }

  /// Widget untuk link "Sudah punya akun?" di bawah
  Widget _buildLoginRedirect() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Sudah punya akun?', style: Get.textTheme.bodyMedium),
          TextButton(
            onPressed: controller.navigateToLogin,
            child: const Text(
              'Login di sini',
              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}