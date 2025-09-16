import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../../../routes/app_pages.dart';

class RegisterFarmerController extends GetxController {
  
  // Kunci Global untuk Form Validasi
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Controllers untuk input text
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  // Variabel reaktif untuk toggle show/hide password
  final RxBool isPasswordHidden = true.obs;
  final RxBool isConfirmPasswordHidden = true.obs;

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void onClose() {
    // Best practice: Selalu dispose controllers
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
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
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama lengkap tidak boleh kosong';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Email tidak valid';
    }
    return null;
  }

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
    if (value != passwordController.text) {
      return 'Password tidak cocok';
    }
    return null;
  }

  // --- Aksi Tombol ---
  void registerFarmer(BuildContext context) {
    // 1. Validasi semua input
    if (formKey.currentState!.validate()) {
      // 2. (LOGIC API REGISTER NANTI DI SINI)
      // ... (Tampilkan loading)
      // ... (Panggil API register/farmer)
      
      // 3. (UI SEMENTARA) Tampilkan notifikasi sukses
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.success(
          message: "Pendaftaran berhasil! Silakan verifikasi email Anda.",
        ),
      );

      // 4. Arahkan ke halaman Verifikasi OTP
      // Kita gunakan halaman OTP yang sudah ada (best practice)
      Future.delayed(2.seconds, () {
        Get.toNamed(
          Routes.OTP_VERIFICATION,
          arguments: emailController.text, // Kirim email untuk ditampilkan
        );
      });
    }
  }
}