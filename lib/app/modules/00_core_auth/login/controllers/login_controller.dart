// lib/app/modules/login/controllers/login_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../data/repositories/abstract/auth_repository.dart';
import '../../../../routes/app_pages.dart';
import '../../../../services/session_service.dart';

class LoginController extends GetxController {
  // --- DEPENDENCIES ---
  // Mengambil service & repo global yang sudah di-inject oleh InitialBinding
  final IAuthRepository _authRepo = Get.find<IAuthRepository>();
  final SessionService _sessionService = Get.find<SessionService>();

  // --- FORM KEYS & CONTROLLERS ---
  // Kunci global untuk validasi form
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();

  // --- STATE MANAGEMENT ---
  // State reaktif untuk loading
  final RxBool isLoading = false.obs;
  // State reaktif untuk toggle password
  final RxBool isPasswordHidden = true.obs;

  @override
  void onClose() {
    // Selalu dispose controller untuk mencegah memory leak
    emailC.dispose();
    passwordC.dispose();
    super.onClose();
  }

  // --- PUBLIC METHODS ---

  /// Aksi untuk toggle visibilitas password
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  /// Aksi utama untuk proses login
  Future<void> login() async {
    // 1. Validasi form terlebih dahulu
    if (!formKey.currentState!.validate()) {
      return; // Jika tidak valid, hentikan eksekusi
    }

    // 2. Set state loading menjadi true
    isLoading.value = true;

    try {
      // 3. Panggil repository (FakeAuthRepository)
      final user = await _authRepo.login(emailC.text, passwordC.text);

      // 4. Jika sukses, simpan data user ke SessionService
      _sessionService.setCurrentUser(user);

      // 5. Tampilkan notifikasi sukses (sesuai request)

      Get.snackbar(
        "Login Berhasil", // Judul
        "Selamat datang kembali, ${user.fullName}.", // Pesan
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.shade700,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        borderRadius: 8,
      );
      // ---------------------------------

      Get.offAllNamed(Routes.MAIN_NAVIGATION);

      // 6. Navigasi ke Halaman Utama.
      //    Kita gunakan offAllNamed agar user tidak bisa "back" ke login.
    } catch (e) {
      // --- Perbaikan Snackbar Error ---
      Get.snackbar(
        "Login Gagal", // Judul
        e.toString().replaceAll("Exception: ", ""), // Pesan
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        borderRadius: 8,
      );
      // --------------------------------
    }
  }
}
