import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../../../routes/app_pages.dart';

class LoginController extends GetxController {
  
  // Kunci Global untuk Form Validasi
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late TextEditingController emailController;
  late TextEditingController passwordController;
  
  final RxBool isPasswordHidden = true.obs;

  @override
  void onInit() {
    super.onInit();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }


  // validator untuk email

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Email tidak valid';
    }
    return null;
  }

  // Validator untuk password
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    if (value.length < 8) {
      return 'Password minimal 8 karakter';
    }
    return null;
  }

  // Aksi saat tombol "Masuk" ditekan
  void login(BuildContext context) {
    // 1. Validasi form
    if (formKey.currentState!.validate()) {
      // 2. Tampilkan loading (jika perlu)
      // ... (logic loading)

      // 3. (SEMENTARA - HANYA UI) Tampilkan snackbar
      // Nanti di sini adalah tempat logic API
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.info(
          message: "Tombol login berfungsi! API akan dihubungkan nanti.",
        ),
      );

      // Contoh jika GAGAL
      // showTopSnackBar(
      //   Overlay.of(context),
      //   const CustomSnackBar.error(
      //     message: "Email atau password salah. Silakan coba lagi.",
      //   ),
      // );
    }
  }

  // Aksi untuk ke halaman Lupa Password
  void goToForgotPassword() {
    Get.toNamed(Routes.FORGOT_PASSWORD);
  }

  // Aksi untuk ke halaman Daftar
  void goToRegister() {
    Get.toNamed(Routes.REGISTER_ROLE_CHOOSER); // Sesuai flowchart
  }
}