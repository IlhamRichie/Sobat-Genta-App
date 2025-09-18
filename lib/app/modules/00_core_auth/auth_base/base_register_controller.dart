// lib/app/modules/auth_base/base_register_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../data/repositories/abstract/auth_repository.dart';
import '../../../routes/app_pages.dart';

// Gunakan 'abstract' agar class ini tidak bisa di-instansiasi
// langsung, tapi harus di-extend.
abstract class BaseRegisterController extends GetxController {
  
  // --- DEPENDENCIES ---
  // Anak kelas bisa mengakses _authRepo
  final IAuthRepository _authRepo = Get.find<IAuthRepository>();
  
  // --- FORM KEYS & CONTROLLERS ---
  // Semua form registrasi punya ini
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameC = TextEditingController();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController phoneC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();
  final TextEditingController confirmPasswordC = TextEditingController();

  // --- STATE MANAGEMENT ---
  final RxBool isLoading = false.obs;
  final RxBool isPasswordHidden = true.obs;
  final RxBool isConfirmPasswordHidden = true.obs;

  // --- ABSTRACT PROPERTIES ---
  // Anak kelas WAJIB meng-override ini
  abstract final String userRole; // e.g. 'FARMER'
  
  @override
  void onClose() {
    nameC.dispose();
    emailC.dispose();
    phoneC.dispose();
    passwordC.dispose();
    confirmPasswordC.dispose();
    super.onClose();
  }

  // --- LOGIKA UMUM ---
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  /// Metode registrasi generik
  Future<void> register() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    isLoading.value = true;

    try {
      final registrationData = {
        'full_name': nameC.text,
        'email': emailC.text,
        'phone_number': phoneC.text,
        'password': passwordC.text,
        'role': userRole, // Ambil role dari anak kelas
      };
      
      // Panggil method 'register' yang sudah dikonsolidasi
      await _authRepo.register(registrationData);

      showTopSnackBar(
        Overlay.of(Get.context!),
        CustomSnackBar.success(
          message: "Pendaftaran berhasil! Cek email Anda untuk kode OTP.",
          backgroundColor: Colors.green.shade700,
        ),
      );

      // Navigasi ke OTP
      Get.toNamed(
        Routes.OTP_VERIFICATION,
        arguments: {
          'email': emailC.text,
          'purpose': 'registration',
        },
      );

    } catch (e) {
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