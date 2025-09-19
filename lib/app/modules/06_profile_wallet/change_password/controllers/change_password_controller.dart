// lib/app/modules/change_password/controllers/change_password_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../data/repositories/abstract/auth_repository.dart';

class ChangePasswordController extends GetxController {

  // --- DEPENDENCIES ---
  final IAuthRepository _authRepo = Get.find<IAuthRepository>();

  // --- FORM STATE ---
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController currentPassC = TextEditingController();
  final TextEditingController newPassC = TextEditingController();
  final TextEditingController confirmNewPassC = TextEditingController();

  // --- UI STATE ---
  final RxBool isLoading = false.obs;
  final RxBool isCurrentPassHidden = true.obs;
  final RxBool isNewPassHidden = true.obs;
  final RxBool isConfirmNewPassHidden = true.obs;

  @override
  void onClose() {
    currentPassC.dispose();
    newPassC.dispose();
    confirmNewPassC.dispose();
    super.onClose();
  }

  // --- TOGGLE METHODS ---
  void toggleCurrentPass() => isCurrentPassHidden.toggle();
  void toggleNewPass() => isNewPassHidden.toggle();
  void toggleConfirmNewPass() => isConfirmNewPassHidden.toggle();

  /// Aksi utama: Kirim perubahan password
  Future<void> submitChangePassword() async {
    if (!formKey.currentState!.validate()) return;
    
    isLoading.value = true;
    try {
      // 1. Panggil Repo
      await _authRepo.changePassword(
        currentPassword: currentPassC.text,
        newPassword: newPassC.text,
      );

      // 2. Sukses
      showTopSnackBar(
        Overlay.of(Get.context!),
        CustomSnackBar.success(
          message: "Password Anda berhasil diperbarui.",
          backgroundColor: Colors.green.shade700,
        ),
      );
      
      // 3. Kembali ke halaman Profil
      Get.back();

    } catch (e) {
      // 4. Tangani error (cth: "Password Anda saat ini salah")
      showTopSnackBar(
        Overlay.of(Get.context!),
        CustomSnackBar.error(message: e.toString().replaceAll("Exception: ", "")),
      );
    } finally {
      isLoading.value = false;
    }
  }
}