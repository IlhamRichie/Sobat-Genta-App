// lib/app/modules/onboarding/views/onboarding_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../theme/app_colors.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Latar Belakang Lingkaran Setengah
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Tombol Lewati di pojok kanan atas
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 16,
            child: TextButton(
              onPressed: controller.skip,
              child: const Text(
                "Lewati",
                style: TextStyle(
                  color: AppColors.textLight,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          // Konten Halaman Geser (Animasi)
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.onPageChanged,
            children: const [
              OnboardingPageContent(
                image: 'assets/onboarding/onboarding_funding.png',
                title: 'Pendanaan Proyek Transparan',
                description: 'Hubungkan lahan produktif Anda dengan investor terverifikasi.',
              ),
              OnboardingPageContent(
                image: 'assets/onboarding/onboarding_market.png',
                title: 'Toko Kebutuhan Tani',
                description: 'Temukan bibit, pupuk, dan alat berkualitas langsung dari produsen.',
              ),
              OnboardingPageContent(
                image: 'assets/onboarding/onboarding_clinic.png',
                title: 'Klinik Tani & Pakar',
                description: 'Dapatkan solusi instan dari pakar pertanian dan dokter hewan.',
              ),
            ],
          ),

          // Kontrol Bawah (Indikator & Tombol)
          Positioned(
            bottom: 40,
            left: 24,
            right: 24,
            child: _buildBottomControls(),
          ),
        ],
      ),
    );
  }

  // Widget untuk kontrol di bagian bawah
  Widget _buildBottomControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Indikator Halaman (Dots)
        Row(
          children: List.generate(
            controller.totalPages,
            (index) => Obx(
              () => _buildDotIndicator(
                index: index,
                isActive: controller.currentPageIndex.value == index,
              ),
            ),
          ),
        ),

        // Tombol Lanjut / Mulai
        FilledButton(
          onPressed: controller.nextPage,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Obx(
            () => Text(
              controller.currentPageIndex.value == controller.totalPages - 1
                  ? "Mulai"
                  : "Lanjut",
            ),
          ),
        ),
      ],
    );
  }

  // Widget untuk satu "dot" indikator
  Widget _buildDotIndicator({required int index, required bool isActive}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(right: 8),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.greyLight,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

/// WIDGET REUSABLE: Konten untuk setiap halaman onboarding
class OnboardingPageContent extends StatelessWidget {
  final String image, title, description;

  const OnboardingPageContent({
    Key? key,
    required this.image,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Gambar Onboarding
          Image.asset(
            image,
            width: Get.width * 0.7, // Ukuran gambar proporsional
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 48),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Get.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            description,
            textAlign: TextAlign.center,
            style: Get.textTheme.bodyLarge?.copyWith(
              color: AppColors.textLight,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}