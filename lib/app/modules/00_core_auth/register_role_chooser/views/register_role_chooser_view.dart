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
      backgroundColor: AppColors.background, // Pastikan background putih bersih
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            // Bagian Scrollable (Header + Cards)
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(24, 10, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Header Text
                    Text(
                      "Pilih Peran Anda",
                      style: Get.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800, // Lebih tebal dikit biar tegas
                        fontSize: 26,
                        color: AppColors.textDark,
                        letterSpacing: -0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Silakan pilih peran yang sesuai untuk menikmati fitur dan manfaat ekosistem Genta.",
                      style: Get.textTheme.bodyMedium?.copyWith(
                        fontSize: 15,
                        height: 1.5, // Jarak antar baris lebih lega
                        color: AppColors.textLight,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),

                    // --- Card 1: Petani ---
                    _buildRoleCard(
                      icon: FontAwesomeIcons.seedling, // Ikon lebih spesifik
                      role: "Saya Petani",
                      description: "Ajukan modal, kelola lahan, dan akses pasar digital.",
                      themeColor: AppColors.primary,
                      onTap: controller.navigateToFarmerRegistration,
                    ),
                    const SizedBox(height: 16),

                    // --- Card 2: Investor ---
                    _buildRoleCard(
                      icon: FontAwesomeIcons.arrowTrendUp, // Ikon grafik naik
                      role: "Saya Investor",
                      description: "Investasi pada proyek riil & pantau ROI secara transparan.",
                      themeColor: AppColors.accent, // Warna Emas/Kuning
                      onTap: controller.navigateToInvestorRegistration,
                    ),
                    const SizedBox(height: 16),

                    // --- Card 3: Pakar ---
                    _buildRoleCard(
                      icon: FontAwesomeIcons.userDoctor,
                      role: "Saya Pakar",
                      description: "Buka konsultasi berbayar & bagikan keahlian Anda.",
                      themeColor: Colors.blue.shade600,
                      onTap: controller.navigateToExpertRegistration,
                    ),
                  ],
                ),
              ),
            ),

            // Footer (Login Redirect)
            _buildLoginRedirect(),
          ],
        ),
      ),
    );
  }

  /// AppBar Minimalis
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        color: AppColors.textDark,
        onPressed: () => Get.back(),
      ),
    );
  }

  /// Modern Card Design
  Widget _buildRoleCard({
    required IconData icon,
    required String role,
    required String description,
    required Color themeColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        splashColor: themeColor.withOpacity(0.1),
        highlightColor: themeColor.withOpacity(0.05),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.greyLight, width: 1), // Border tipis rapi
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFE0E0E0).withOpacity(0.5),
                blurRadius: 20,
                offset: const Offset(0, 10), // Shadow lembut ke bawah
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon Container (Badge Style)
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: themeColor.withOpacity(0.1), // Background transparan warna role
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: FaIcon(icon, color: themeColor, size: 26),
                ),
              ),
              const SizedBox(width: 20),
              
              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4), // Visual alignment dengan ikon
                    Text(
                      role,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.4,
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow Icon (Center Vertically)
              Padding(
                padding: const EdgeInsets.only(top: 16.0), // Agak turun biar center visual
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: AppColors.textLight.withOpacity(0.5),
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Footer yang menyatu tapi distinct
  Widget _buildLoginRedirect() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppColors.greyLight, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Sudah punya akun Sobat Genta?',
            style: TextStyle(
              color: AppColors.textLight,
              fontSize: 14,
            ),
          ),
          GestureDetector(
            onTap: controller.navigateToLogin,
            child: const Padding(
              padding: EdgeInsets.only(left: 6.0),
              child: Text(
                'Masuk',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}