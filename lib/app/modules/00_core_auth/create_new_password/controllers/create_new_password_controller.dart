import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../../../routes/app_pages.dart'; // Pastikan Routes-nya ada

class CreateNewPasswordController extends GetxController {
  
  // Kunci Global untuk Form Validasi
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Controllers untuk input password
  late TextEditingController newPasswordController;
  late TextEditingController confirmPasswordController;

  // Variabel reaktif untuk toggle show/hide password
  final RxBool isPasswordHidden = true.obs;
  final RxBool isConfirmPasswordHidden = true.obs;

  // Email didapat dari halaman sebelumnya (OtpVerificationPage)
  final RxString userEmail = "".obs;

  @override
  void onInit() {
    super.onInit();
    newPasswordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    
    // Ambil email dari arguments
    if (Get.arguments != null) {
      userEmail.value = Get.arguments as String;
    }
  }

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  // --- Aksi Toggle ---
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  // --- Validator ---
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    if (value.length < 8) {
      return 'Password minimal 8 karakter';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password tidak boleh kosong';
    }
    if (value != newPasswordController.text) {
      return 'Password tidak cocok';
    }
    return null;
  }

  // --- Aksi Tombol ---
  void resetPassword(BuildContext context) {
    // 1. Validasi form
    if (formKey.currentState!.validate()) {
      // 2. (LOGIC API RESET PASSWORD NANTI DI SINI)
      // ... (Tampilkan loading)
      // ... (Panggil API dengan: userEmail.value dan newPasswordController.text)
      
      // 3. (UI SEMENTARA) Tampilkan notifikasi sukses
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.success(
          message: "Password Anda telah berhasil diubah!",
        ),
      );

      // 4. Kembali ke halaman Login setelah 2 detik
      // Gunakan 'offAllNamed' untuk MENGHAPUS SEMUA halaman sebelumnya (Forgot, OTP, Create)
      // dari tumpukan (stack) navigasi.
      Future.delayed(2.seconds, () {
        Get.offAllNamed(Routes.LOGIN);
      });
    }
  }
}