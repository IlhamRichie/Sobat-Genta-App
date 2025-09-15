import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:introduction_screen/introduction_screen.dart';
import '../../../../routes/app_pages.dart';

class OnboardingController extends GetxController {
  
  final introKey = GlobalKey<IntroductionScreenState>();
  final storage = GetStorage(); // Panggil instance GetStorage

  void onOnboardingDone() {
    // 1. Set flag di storage bahwa onboarding sudah selesai
    storage.write('isOnboardingDone', true);

    // 2. Navigasi ke Halaman Login (atau halaman pilih peran register)
    // Gunakan Get.offAllNamed agar user tidak bisa kembali (swipe back) ke onboarding
    Get.offAllNamed(Routes.LOGIN); // (Asumsi kita arahkan ke Login)
  }
}