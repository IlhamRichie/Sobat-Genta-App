// lib/app/modules/register_farmer/views/register_farmer_view.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sobatgenta/app/modules/00_core_auth/auth_base/base_register_form.dart';
import '../../../../theme/app_colors.dart';
import '../controllers/register_farmer_controller.dart';

class RegisterFarmerView extends GetView<RegisterFarmerController> {
  const RegisterFarmerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // 1. Background Decoration (Sama dengan Onboarding/Role Chooser biar konsisten)
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
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
                color: AppColors.accent.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // 2. Main Content
          SafeArea(
            child: Column(
              children: [
                // Header (Back Button & Title)
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
                          "Daftar Petani",
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

                // Form Section (Scrollable)
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        
                        // Selamat Datang Text
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const FaIcon(FontAwesomeIcons.seedling, color: AppColors.primary, size: 24),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "Halo, Sobat Tani! 🌱",
                                style: Get.textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textDark,
                                  fontSize: 26,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Mari bergabung untuk memajukan pertanian Indonesia bersama Genta.",
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
                          headerText: "", // Header sudah kita buat custom di atas, jadi ini kosong saja
                          nameHint: "Nama Lengkap Sesuai KTP",
                          emailHint: "email@contoh.com",
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