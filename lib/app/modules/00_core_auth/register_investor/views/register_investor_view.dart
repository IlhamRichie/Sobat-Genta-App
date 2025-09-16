import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../../routes/app_pages.dart';
import '../controllers/register_investor_controller.dart'; // <-- UBAH IMPORT

// (Best Practice: Pindahkan ini ke lib/app/theme/app_colors.dart)
const kPrimaryDarkGreen = Color(0xFF3A8A40);
const kLightGreenBlob = Color(0xFFEAF4EB);
const kTextFieldBorder = Color(0xFFD9D9D9);
const kDarkTextColor = Color(0xFF1B2C1E);
const kBodyTextColor = Color(0xFF5A6A5C);

class RegisterInvestorView extends GetView<RegisterInvestorController> { // <-- UBAH CONTROLLER
  const RegisterInvestorView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: kDarkTextColor),
          onPressed: () => Get.back(),
        ),
      ),
      body: Stack(
        children: [
          _buildBackgroundBlobs(), // Konsistensi UI
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: Get.height * 0.02),
                    
                    _buildHeader() // <-- UBAH TULISAN DI SINI
                        .animate()
                        .fadeIn(delay: 300.ms)
                        .slideY(begin: 0.2, end: 0),
                    
                    const SizedBox(height: 32),
                    
                    // --- Form Fields ---
                    // (Semua helper widget di bawah ini identik
                    //  dengan RegisterFarmerView, tidak perlu diubah)
                    _buildNameField()
                        .animate()
                        .fadeIn(delay: 500.ms)
                        .slideX(begin: -0.2),
                    
                    const SizedBox(height: 16),
                    
                    _buildEmailField()
                        .animate()
                        .fadeIn(delay: 600.ms)
                        .slideX(begin: 0.2),
                    
                    const SizedBox(height: 16),
                    
                    _buildPasswordField()
                        .animate()
                        .fadeIn(delay: 700.ms)
                        .slideX(begin: -0.2),
                    
                    const SizedBox(height: 16),
                    
                    _buildConfirmPasswordField()
                        .animate()
                        .fadeIn(delay: 800.ms)
                        .slideX(begin: 0.2),
                    
                    SizedBox(height: Get.height * 0.05),
                    
                    // --- Tombol Daftar ---
                    _buildRegisterButton(context) // <-- UBAH Aksi & Teks
                        .animate()
                        .fadeIn(delay: 900.ms)
                        .shake(),
                    
                    const SizedBox(height: 24),
                    
                    // --- Link Masuk ---
                    _buildLoginLink()
                        .animate()
                        .fadeIn(delay: 1000.ms),
                        
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Helper Widgets (Best Practice) ---

  Widget _buildBackgroundBlobs() {
    return Positioned(
      bottom: -150,
      right: -150,
      child: Container(
        width: 400,
        height: 400,
        decoration: const BoxDecoration(
          color: kLightGreenBlob,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Daftar (Investor)', // <-- UBAH TULISAN
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: kDarkTextColor,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Mulai perjalanan investasi Anda di GENTA.', // <-- UBAH TULISAN
          style: TextStyle(
            fontSize: 17,
            color: kBodyTextColor,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  // (Helper ini identik, tidak perlu diubah)
  InputDecoration _inputDecoration(
    String hintText,
    IconData prefixIcon, {
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: kBodyTextColor),
      prefixIcon: Icon(prefixIcon, color: kBodyTextColor),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: kTextFieldBorder, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: kTextFieldBorder, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: kPrimaryDarkGreen, width: 2),
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: controller.nameController,
      validator: controller.validateName,
      keyboardType: TextInputType.name,
      decoration: _inputDecoration('Nama Lengkap', Icons.person_outline),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: controller.emailController,
      validator: controller.validateEmail,
      keyboardType: TextInputType.emailAddress,
      decoration: _inputDecoration('Email', Icons.mail_outline),
    );
  }

  Widget _buildPasswordField() {
    return Obx(() {
      return TextFormField(
        controller: controller.passwordController,
        validator: controller.validatePassword,
        obscureText: controller.isPasswordHidden.value,
        decoration: _inputDecoration(
          'Password',
          Icons.lock_outline,
          suffixIcon: IconButton(
            icon: Icon(
              controller.isPasswordHidden.value
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: kBodyTextColor,
            ),
            onPressed: controller.togglePasswordVisibility,
          ),
        ),
      );
    });
  }

  Widget _buildConfirmPasswordField() {
    return Obx(() {
      return TextFormField(
        controller: controller.confirmPasswordController,
        validator: controller.validateConfirmPassword,
        obscureText: controller.isConfirmPasswordHidden.value,
        decoration: _inputDecoration(
          'Konfirmasi Password',
          Icons.lock_outline,
          suffixIcon: IconButton(
            icon: Icon(
              controller.isConfirmPasswordHidden.value
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: kBodyTextColor,
            ),
            onPressed: controller.toggleConfirmPasswordVisibility,
          ),
        ),
      );
    });
  }

  Widget _buildRegisterButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => controller.registerInvestor(context), // <-- UBAH AKSI
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryDarkGreen,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: const Text(
        'Daftar sebagai Investor', // <-- UBAH TULISAN
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Center(
      child: RichText(
        text: TextSpan(
          text: 'Sudah punya akun? ',
          style: const TextStyle(
            color: kBodyTextColor,
            fontSize: 16,
            fontFamily: 'Inter',
          ),
          children: [
            TextSpan(
              text: 'Masuk sekarang',
              style: const TextStyle(
                color: kPrimaryDarkGreen,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                fontFamily: 'Inter',
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () => Get.offNamed(Routes.LOGIN), // Kembali ke Login
            ),
          ],
        ),
      ),
    );
  }
}