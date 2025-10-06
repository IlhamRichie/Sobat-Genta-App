// lib/app/modules/login/views/login_view.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../routes/app_pages.dart';
import '../../../../theme/app_colors.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: BackButton(color: AppColors.textDark),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              const SizedBox(height: 48),
              _buildEmailField(),
              const SizedBox(height: 16),
              _buildPasswordField(),
              const SizedBox(height: 12),
              _buildForgotPasswordLink(),
              const SizedBox(height: 32),
              _buildLoginButton(),
              const SizedBox(height: 24),
              _buildRegisterLink(),
            ],
          ),
        ),
      ),
    );
  }

  /// Header (Didesain Ulang)
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Selamat Datang Kembali",
          style: Get.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          "Login untuk melanjutkan ke akun Anda.",
          style: Get.textTheme.bodyLarge?.copyWith(
            color: AppColors.textLight,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Field Email (Didesain Ulang)
  Widget _buildEmailField() {
    return TextFormField(
      controller: controller.emailC,
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      decoration: _inputDecoration(
        'Email',
        'contoh: budi@petani.com',
        FontAwesomeIcons.solidEnvelope,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Email tidak boleh kosong';
        }
        if (!GetUtils.isEmail(value)) {
          return 'Format email tidak valid';
        }
        return null;
      },
    );
  }

  /// Field Password (Didesain Ulang)
  Widget _buildPasswordField() {
    return Obx(() => TextFormField(
      controller: controller.passwordC,
      autocorrect: false,
      obscureText: controller.isPasswordHidden.value,
      decoration: _inputDecoration(
        'Password',
        'Minimal 6 karakter',
        FontAwesomeIcons.lock,
        suffixIcon: IconButton(
          icon: FaIcon(
            controller.isPasswordHidden.value
                ? FontAwesomeIcons.eyeSlash
                : FontAwesomeIcons.eye,
            size: 20,
            color: AppColors.textLight,
          ),
          onPressed: controller.togglePasswordVisibility,
        ),
      ),
      validator: (value) {
        if (value == null || value.length < 6) {
          return 'Password minimal 6 karakter';
        }
        return null;
      },
    ));
  }

  /// Tautan Lupa Password (Didesain Ulang)
  Widget _buildForgotPasswordLink() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          Get.toNamed(Routes.FORGOT_PASSWORD);
        },
        child: const Text(
          'Lupa Password?',
          style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  /// Tombol Login (Didesain Ulang)
  Widget _buildLoginButton() {
    return Obx(() => FilledButton(
      onPressed: controller.isLoading.value ? null : controller.login,
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
      ),
      child: controller.isLoading.value
          ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
            )
          : const Text(
              'Login',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
    ));
  }

  /// Tautan Daftar (Didesain Ulang)
  Widget _buildRegisterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Belum punya akun?', style: Get.textTheme.bodyMedium),
        TextButton(
          onPressed: () {
            Get.toNamed(Routes.REGISTER_ROLE_CHOOSER);
          },
          child: const Text(
            'Daftar di sini',
            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  /// Custom InputDecoration untuk konsistensi (Baru)
  InputDecoration _inputDecoration(
    String labelText,
    String hintText,
    IconData prefixIcon, {
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: Get.textTheme.bodyMedium?.copyWith(color: AppColors.textLight),
      hintText: hintText,
      hintStyle: Get.textTheme.bodyMedium?.copyWith(color: AppColors.textLight),
      prefixIcon: FaIcon(prefixIcon, size: 20, color: AppColors.textLight),
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.greyLight)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.greyLight)),
    );
  }
}