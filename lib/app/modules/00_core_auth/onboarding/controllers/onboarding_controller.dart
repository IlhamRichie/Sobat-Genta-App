import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../routes/app_pages.dart';

class OnboardingController extends GetxController {
  
  // 1. Controller untuk PageView
  late PageController pageController;

  // 2. Variabel reaktif untuk melacak halaman saat ini
  final RxInt currentPageIndex = 0.obs;

  // 3. Jumlah total halaman
  final int totalPages = 4;

  final storage = GetStorage(); // Panggil instance GetStorage

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
  }

  @override
  void onClose() {
    // Best practice: Selalu dispose controller
    pageController.dispose();
    super.onClose();
  }

  // 4. Dipanggil oleh PageView setiap kali halaman berganti
  void onPageChanged(int index) {
    currentPageIndex.value = index;
  }

  // 5. Dipanggil oleh tombol "Next"
  void nextPage() {
    if (currentPageIndex.value < totalPages - 1) {
      pageController.nextPage(
        duration: 300.ms,
        curve: Curves.easeInOut,
      );
    }
  }

  // 6. Dipanggil oleh tombol "Mulai Sekarang" atau "Lewati"
  void onOnboardingDone() {
    // Set flag di storage bahwa onboarding sudah selesai
    storage.write('isOnboardingDone', true);

    // Navigasi ke Halaman Login
    Get.offAllNamed(Routes.LOGIN);
  }
}