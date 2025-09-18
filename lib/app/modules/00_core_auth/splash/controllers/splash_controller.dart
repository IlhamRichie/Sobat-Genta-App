// lib/app/modules/splash/controllers/splash_controller.dart

import 'package:get/get.dart';

import '../../../../data/repositories/abstract/auth_repository.dart';
import '../../../../routes/app_pages.dart';
import '../../../../services/session_service.dart';

class SplashController extends GetxController {
  
  // Kita akan mengambil service global yang sudah di-inject
  // di main.dart atau InitialBinding
  final SessionService _sessionService = Get.find<SessionService>();
  final IAuthRepository _authRepo = Get.find<IAuthRepository>();

  @override
  void onReady() {
    super.onReady();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // 1. Tentukan waktu minimum splash screen (misal 2 detik)
    //    Ini untuk UX, agar logo tidak "flash" (hilang terlalu cepat).
    Future<void> minSplashTime = Future.delayed(const Duration(seconds: 2));

    // 2. Tentukan tugas inisialisasi
    //    Kita cek apakah ada user session yang valid
    Future<bool> checkAuthTask = _checkCurrentUserSession();

    // 3. Jalankan kedua tugas secara bersamaan
    var results = await Future.wait([
      minSplashTime,
      checkAuthTask,
    ]);

    // 4. Ambil hasil dari tugas inisialisasi
    //    Hasilnya ada di index [1]
    final bool isLoggedIn = results[1] as bool;

    // 5. Navigasi berdasarkan hasil
    if (isLoggedIn) {
      // User punya sesi valid. Langsung ke home.
      Get.offAllNamed(Routes.MAIN_NAVIGATION);
    } else {
      // Tidak ada sesi. Arahkan ke onboarding.
      Get.offAllNamed(Routes.ONBOARDING);
    }
  }

  /// Memeriksa sesi user saat ini ke repository.
  /// Ini akan memanggil FakeAuthRepository.getMyProfile()
  Future<bool> _checkCurrentUserSession() async {
    try {
      // Fake repository akan mengembalikan mock user jika "token" ada,
      // atau melempar exception jika tidak.
      final user = await _authRepo.getMyProfile();
      
      // Jika berhasil, simpan user ke service global kita
      _sessionService.setCurrentUser(user);
      
      return true;
    } catch (e) {
      // Error (misal: "No token", "401 Unauthorized" di API asli)
      _sessionService.clearSession();
      return false;
    }
  }
}