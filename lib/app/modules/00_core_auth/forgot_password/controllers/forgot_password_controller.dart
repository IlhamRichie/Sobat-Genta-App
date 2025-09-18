// lib/app/modules/forgot_password/controllers/forgot_password_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../data/repositories/abstract/auth_repository.dart';
import '../../../../routes/app_pages.dart';

class ForgotPasswordController extends GetxController {

  final IAuthRepository _authRepo = Get.find<IAuthRepository>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailC = TextEditingController();
  
  final RxBool isLoading = false.obs;

  @override
  void onClose() {
    emailC.dispose();
    super.onClose();
  }

  /// Aksi untuk mengirim permintaan reset password
  Future<void> sendResetRequest() async {
    // 1. Validasi form
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;

    try {
      // 2. Panggil repository
      await _authRepo.forgotPassword(emailC.text);

      // 3. Tampilkan notifikasi sukses
      showTopSnackBar(
        Overlay.of(Get.context!),
        CustomSnackBar.success(
          message: "Permintaan terkirim. Cek email Anda untuk kode OTP.",
          backgroundColor: Colors.green.shade700,
        ),
      );

      // 4. Navigasi ke Halaman OTP
      //    PENTING: Kirim 'purpose' yang berbeda
      Get.toNamed(
        Routes.OTP_VERIFICATION,
        arguments: {
          'email': emailC.text,
          'purpose': 'reset_password', // Berbeda dari 'registration'
        },
      );
      
    } catch (e) {
      // 5. Tangani error
      showTopSnackBar(
        Overlay.of(Get.context!),
        CustomSnackBar.error(
          message: e.toString().replaceAll("Exception: ", ""),
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }
}