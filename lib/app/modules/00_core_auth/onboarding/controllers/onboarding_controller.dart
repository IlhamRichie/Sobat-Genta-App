// lib/app/modules/onboarding/controllers/onboarding_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../routes/app_pages.dart';

class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  
  // State reaktif untuk melacak halaman saat ini
  final RxInt currentPageIndex = 0.obs;

  // Sesuai user story, kita punya 3 halaman
  final int totalPages = 3;

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  /// Dipanggil oleh PageView saat halaman digeser
  void onPageChanged(int index) {
    currentPageIndex.value = index;
  }

  /// Dipanggil oleh tombol "Lanjut"
  void nextPage() {
    if (currentPageIndex.value == totalPages - 1) {
      // Jika di halaman terakhir, kita "Mulai"
      goToAuth();
    } else {
      // Animasikan ke halaman berikutnya
      pageController.animateToPage(
        currentPageIndex.value + 1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  /// Dipanggil oleh tombol "Skip"
  void skip() {
    goToAuth();
  }

  /// Navigasi ke alur autentikasi
  void goToAuth() {
    // Sesuai rencana, user baru diarahkan ke pemilih peran
    Get.offAllNamed(Routes.REGISTER_ROLE_CHOOSER);
  }
}