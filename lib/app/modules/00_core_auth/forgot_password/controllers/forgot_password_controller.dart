import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../../../routes/app_pages.dart';

class ForgotPasswordController extends GetxController {
  
  // Kunci Global untuk Form Validasi
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Controller untuk input email
  late TextEditingController emailController;

  @override
  void onInit() {
    super.onInit();
    emailController = TextEditingController();
  }

  @override
  void onClose() {
    // Best practice: Selalu dispose controller
    emailController.dispose();
    super.onClose();
  }

  // Validator untuk Email
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Email tidak valid';
    }
    return null;
  }

  // Aksi saat tombol "Kirim Email Pemulihan" ditekan
  void sendRecoveryEmail(BuildContext context) {
    // 1. Validasi form
    if (formKey.currentState!.validate()) {
      // 2. (LOGIC API NANTI DI SINI)
      // ... (Tampilkan loading)
      // ... (Panggil API forgot password)
      
      // 3. (UI SEMENTARA) Tampilkan notifikasi sukses
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.success(
          message: "Email pemulihan terkirim! Silakan cek inbox Anda.",
        ),
      );

      // 4. Pindah ke halaman OTP setelah 2 detik
      Future.delayed(2.seconds, () {
        // (Kita akan buat halaman OtpVerificationPage selanjutnya)
        Get.toNamed(Routes.OTP_VERIFICATION, arguments: emailController.text);
      });
    }
  }
}