// lib/app/modules/register_investor/views/register_investor_view.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../theme/app_colors.dart';
import '../../auth_base/base_register_form.dart';
import '../controllers/register_investor_controller.dart';

class RegisterInvestorView extends GetView<RegisterInvestorController> {
  const RegisterInvestorView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // 1. AESTHETIC BACKGROUND (Nuansa Emas/Accent)
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                // Menggunakan warna Accent (Emas) agar beda dengan Petani
                color: AppColors.accent.withOpacity(0.15), 
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 100,
            left: -40,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // 2. MAIN CONTENT
          SafeArea(
            child: Column(
              children: [
                // --- Custom AppBar ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textDark),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.all(12),
                          elevation: 2,
                          shadowColor: Colors.black12,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Text(
                          "Daftar Investor",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // --- Scrollable Content ---
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        
                        // Header Section: Greeting & Icon
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Ikon Grafik Naik (Simbol Investasi)
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.accent.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const FaIcon(
                                  FontAwesomeIcons.arrowTrendUp, 
                                  color: AppColors.accent, // Warna Emas
                                  size: 24
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "Halo, Calon Investor! 📈",
                                style: Get.textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textDark,
                                  fontSize: 26,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Dapatkan imbal hasil menarik dengan mendanai proyek pertanian nyata dan transparan.",
                                style: Get.textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textLight,
                                  fontSize: 15,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 24),

                        // Form Reusable
                        BaseRegisterForm(
                          controller: controller,
                          headerText: "", // Kosongkan karena sudah ada header custom di atas
                          nameHint: "Nama Lengkap",
                          emailHint: "email@investor.com",
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}