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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: controller.skip,
            child: const Text(
              "Lewati",
              style: TextStyle(color: AppColors.textLight, fontSize: 16),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          // 1. Konten Halaman Geser (Animasi)
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.onPageChanged,
            children: const [
              OnboardingPageContent(
                image: '/assets/onboarding/onboarding_funding.png', // Ganti dengan path asset Anda
                title: 'Pendanaan Proyek Transparan',
                description: 'Hubungkan lahan produktif Anda dengan investor terverifikasi.',
              ),
              OnboardingPageContent(
                image: '/assets/onboarding/onboarding_market.png', // Ganti dengan path asset Anda
                title: 'Toko Kebutuhan Tani',
                description: 'Temukan bibit, pupuk, dan alat berkualitas langsung dari produsen.',
              ),
              OnboardingPageContent(
                image: '/assets/onboarding/onboarding_clinic.png', // Ganti dengan path asset Anda
                title: 'Klinik Tani & Pakar',
                description: 'Dapatkan solusi instan dari pakar pertanian dan dokter hewan.',
              ),
            ],
          ),

          // 2. Kontrol Bawah (Indikator & Tombol)
          Positioned(
            bottom: 30,
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
    // Animasi perubahan warna dan ukuran
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
          // TODO: Ganti Icon ini dengan Image.asset(image)
          // Pastikan Anda sudah menambahkan folder 'assets/images/' di pubspec.yaml
          Icon(Icons.image, size: Get.width * 0.6, color: AppColors.greyLight),
          const SizedBox(height: 48),
          Text(
            title,
            textAlign: TextAlign.center,
            // Font 'Inter' (titleLarge) otomatis diterapkan dari Theme
            style: Get.textTheme.titleLarge?.copyWith(fontSize: 24),
          ),
          const SizedBox(height: 16),
          Text(
            description,
            textAlign: TextAlign.center,
            // Font 'Inter' (bodyMedium) otomatis diterapkan dari Theme
            style: Get.textTheme.bodyMedium?.copyWith(fontSize: 16, height: 1.5),
          ),
        ],
      ),
    );
  }
}