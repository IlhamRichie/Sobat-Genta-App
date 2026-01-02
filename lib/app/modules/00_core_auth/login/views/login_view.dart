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
      body: Stack(
        children: [
          // 1. BACKGROUND ORNAMENTS (Aesthetic Blobs)
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 150,
            left: -80,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // 2. MAIN CONTENT
          SafeArea(
            child: Center( // Center content vertically for better focus
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 24.0),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 48),
                      
                      // Label & Inputs
                      _buildLabel("Email Address"),
                      _buildEmailField(),
                      const SizedBox(height: 20),
                      
                      _buildLabel("Password"),
                      _buildPasswordField(),
                      const SizedBox(height: 10),
                      
                      _buildForgotPasswordLink(),
                      const SizedBox(height: 32),
                      
                      _buildLoginButton(),
                      const SizedBox(height: 32),
                      
                      _buildRegisterLink(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Header Section with "Hello" Vibe
  Widget _buildHeader() {
    return Column(
      children: [
        // Logo atau Ikon Kunci/Gembok
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const FaIcon(
            FontAwesomeIcons.lockOpen, 
            size: 32, 
            color: AppColors.primary
          ),
        ),
        const SizedBox(height: 24),
        Text(
          "Selamat Datang Kembali! 👋",
          style: Get.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
            fontSize: 24,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          "Silakan masuk untuk melanjutkan aktivitas Anda di Genta.",
          style: Get.textTheme.bodyMedium?.copyWith(
            color: AppColors.textLight,
            fontSize: 15,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Label Text Helper
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.textDark,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }

  /// Field Email (Filled Style)
  Widget _buildEmailField() {
    return TextFormField(
      controller: controller.emailC,
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      style: const TextStyle(color: AppColors.textDark),
      decoration: _modernInputDecoration(
        'Masukkan email Anda',
        FontAwesomeIcons.envelope,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Email wajib diisi';
        if (!GetUtils.isEmail(value)) return 'Format email tidak valid';
        return null;
      },
    );
  }

  /// Field Password (Filled Style)
  Widget _buildPasswordField() {
    return Obx(() => TextFormField(
      controller: controller.passwordC,
      obscureText: controller.isPasswordHidden.value,
      autocorrect: false,
      style: const TextStyle(color: AppColors.textDark),
      decoration: _modernInputDecoration(
        'Masukkan password',
        FontAwesomeIcons.lock,
        suffixIcon: IconButton(
          icon: FaIcon(
            controller.isPasswordHidden.value
                ? FontAwesomeIcons.eyeSlash
                : FontAwesomeIcons.eye,
            size: 18,
            color: AppColors.textLight,
          ),
          onPressed: controller.togglePasswordVisibility,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Password wajib diisi';
        return null;
      },
    ));
  }

  /// Forgot Password Link
  Widget _buildForgotPasswordLink() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => Get.toNamed(Routes.FORGOT_PASSWORD),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: const Text(
          'Lupa Password?',
          style: TextStyle(
            color: AppColors.primary, 
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  /// Tombol Login Utama
  Widget _buildLoginButton() {
    return Obx(() => Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: FilledButton(
        onPressed: controller.isLoading.value ? null : controller.login,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        child: controller.isLoading.value
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
              )
            : const Text(
                'Masuk',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
      ),
    ));
  }

  /// Footer Register
  Widget _buildRegisterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Belum punya akun?',
          style: TextStyle(color: AppColors.textLight),
        ),
        GestureDetector(
          onTap: () => Get.toNamed(Routes.REGISTER_ROLE_CHOOSER),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
            child: Text(
              'Daftar Sekarang',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Modern Input Decoration (Reused Style)
  InputDecoration _modernInputDecoration(
    String hintText,
    IconData prefixIcon, {
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
      filled: true,
      fillColor: AppColors.greyLight, // Warna latar abu muda
      
      prefixIcon: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Icon(prefixIcon, size: 18, color: AppColors.textLight),
      ),
      prefixIconConstraints: const BoxConstraints(minWidth: 50),
      suffixIcon: suffixIcon,
      
      // Border States
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.transparent),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
    );
  }
}