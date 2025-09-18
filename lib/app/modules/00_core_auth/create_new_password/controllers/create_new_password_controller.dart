// lib/app/modules/create_new_password/controllers/create_new_password_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../data/repositories/abstract/auth_repository.dart';
import '../../../../routes/app_pages.dart';

class CreateNewPasswordController extends GetxController {
  
  final IAuthRepository _authRepo = Get.find<IAuthRepository>();

  // --- FORM & STATE ---
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController newPasswordC = TextEditingController();
  final TextEditingController confirmPasswordC = TextEditingController();
  final RxBool isLoading = false.obs;
  final RxBool isPasswordHidden = true.obs;
  final RxBool isConfirmPasswordHidden = true.obs;

  // --- PAGE ARGUMENTS ---
  late final String email;
  late final String token; // Token otorisasi dari halaman OTP

  @override
  void onInit() {
    super.onInit();
    // Ambil argumen dari halaman OTP
    email = Get.arguments['email'] as String;
    token = Get.arguments['token'] as String;
  }

  @override
  void onClose() {
    newPasswordC.dispose();
    confirmPasswordC.dispose();
    super.onClose();
  }

  // --- PUBLIC METHODS ---
  void togglePasswordVisibility() => isPasswordHidden.toggle();
  void toggleConfirmPasswordVisibility() => isConfirmPasswordHidden.toggle();

  /// Aksi untuk submit password baru
  Future<void> submitNewPassword() async {
    // 1. Validasi form
    if (!formKey.currentState!.validate()) {
      return;
    }
    
    isLoading.value = true;
    try {
      // 2. Panggil repository dengan token otorisasi
      await _authRepo.createNewPassword(
        email,
        token,
        newPasswordC.text,
      );
      
      // 3. Tampilkan notifikasi sukses
      showTopSnackBar(
        Overlay.of(Get.context!),
        CustomSnackBar.success(
          message: "Password Anda telah berhasil diubah! Silakan login kembali.",
          backgroundColor: Colors.green.shade700,
        ),
      );
      
      // 4. Selesai. Hapus semua stack dan kembali ke Login.
      Get.offAllNamed(Routes.LOGIN);
      
    } catch (e) {
      // 5. Tangani error (misal, token kedaluwarsa)
      showTopSnackBar(
        Overlay.of(Get.context!),
        CustomSnackBar.error(message: e.toString().replaceAll("Exception: ", "")),
      );
    } finally {
      isLoading.value = false;
    }
  }
}