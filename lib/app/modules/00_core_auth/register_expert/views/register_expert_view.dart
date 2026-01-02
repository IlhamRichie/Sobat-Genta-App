// lib/app/modules/register_expert/views/register_expert_view.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../theme/app_colors.dart';
import '../../auth_base/base_register_form.dart';
import '../controllers/register_expert_controller.dart';

class RegisterExpertView extends GetView<RegisterExpertController> {
  const RegisterExpertView({Key? key}) : super(key: key);

  // Warna khusus untuk tema Pakar (Biru Profesional)
  // Kita definisikan di sini agar tidak merusak AppColors global, 
  // tapi tetap konsisten dengan card di Role Chooser.
  final Color expertThemeColor = const Color(0xFF1976D2); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // 1. BACKGROUND DECORATION (Nuansa Biru/Trust)
          Positioned(
            top: -80,
            right: -40,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                color: expertThemeColor.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 120,
            left: -50,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent.withOpacity(0.1),
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
                          "Daftar Pakar",
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

                // --- Scrollable Form ---
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
                              // Ikon Dokter/Pakar
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: expertThemeColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: FaIcon(
                                  FontAwesomeIcons.userDoctor, 
                                  color: expertThemeColor, 
                                  size: 24
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "Halo, Para Ahli! 🩺",
                                style: Get.textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textDark,
                                  fontSize: 26,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Bagikan keahlian Anda untuk membantu petani dan dapatkan penghasilan tambahan.",
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

                        // Reusable Form
                        BaseRegisterForm(
                          controller: controller,
                          headerText: "", // Header sudah di-handle custom di atas
                          nameHint: "Nama Lengkap & Gelar",
                          emailHint: "email@profesional.com",
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