// lib/app/modules/splash/controllers/splash_controller.dart

import 'package:get/get.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import '../../../../data/repositories/abstract/auth_repository.dart';
import '../../../../routes/app_pages.dart';
import '../../../../services/session_service.dart'; // <-- 1. IMPORT

class SplashController extends GetxController {
  
  final SessionService _sessionService = Get.find<SessionService>();
  final IAuthRepository _authRepo = Get.find<IAuthRepository>();

  @override
  void onReady() {
    super.onReady();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // 1. Definisikan minimum splash time (Ini tetap berjalan, 
    //    ini adalah splash Flutter kita, tapi tertutup native splash)
    Future<void> minSplashTime = Future.delayed(const Duration(seconds: 2));

    // 2. Definisikan tugas inisialisasi (tetap berjalan)
    Future<bool> checkAuthTask = _checkCurrentUserSession();

    // 3. Jalankan kedua tugas secara bersamaan
    var results = await Future.wait([
      minSplashTime,
      checkAuthTask,
    ]);
    
    final bool isLoggedIn = results[1] as bool;

    // 4. --- PERBAIKAN DI SINI ---
    // Setelah semua logic async kita selesai, perintahkan 
    // splash NATIVE untuk menghilang.
    FlutterNativeSplash.remove();
    
    // (Opsional: Beri delay super singkat agar transisi render mulus)
    await Future.delayed(const Duration(milliseconds: 50)); 

    // 5. Navigasi seperti biasa
    if (isLoggedIn) {
      Get.offAllNamed(Routes.MAIN_NAVIGATION);
    } else {
      Get.offAllNamed(Routes.ONBOARDING);
    }
  }

  Future<bool> _checkCurrentUserSession() async {
    // ... (Logika cek sesi tetap sama) ...
    try {
      final user = await _authRepo.getMyProfile();
      _sessionService.setCurrentUser(user);
      return true;
    } catch (e) {
      _sessionService.clearSession();
      return false;
    }
  }
}