import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../routes/app_pages.dart';
import '../controllers/login_controller.dart';

// --- Best Practice: Definisikan Palet Warna (sesuai UI) ---
// (Idealnya, ini ada di file theme/colors.dart)
const kPrimaryDarkGreen = Color(0xFF3A8A40); // Tombol "Masuk"
const kLightGreenBlob = Color(0xFFEAF4EB); // Blob di background
const kTextFieldBorder = Color(0xFFD9D9D9); // Border text field
const kSocialButtonBg = Color(0xFFF5F5F7); // BG Tombol Google/FB/Apple
const kDarkTextColor = Color(0xFF1B2C1E); // Teks Judul
const kBodyTextColor = Color(0xFF5A6A5C); // Teks Body/Hint

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. Elemen Dekorasi Background (Blobs)
          _buildBackgroundBlobs(),

          // 2. Konten Utama
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 60),
                    // --- Header ---
                    _buildHeader()
                        .animate()
                        .fadeIn(delay: 300.ms, duration: 500.ms)
                        .slideY(begin: 0.2, end: 0),
                    
                    const SizedBox(height: 40),
                    // --- Form Email ---
                    _buildEmailField()
                        .animate()
                        .fadeIn(delay: 500.ms, duration: 500.ms)
                        .slideX(begin: -0.2, end: 0),

                    const SizedBox(height: 16),
                    // --- Form Password ---
                    _buildPasswordField()
                        .animate()
                        .fadeIn(delay: 600.ms, duration: 500.ms)
                        .slideX(begin: 0.2, end: 0),

                    const SizedBox(height: 12),
                    // --- Lupa Password ---
                    _buildForgotPasswordLink(),

                    const SizedBox(height: 24),
                    // --- Tombol Masuk ---
                    _buildLoginButton(context)
                        .animate()
                        .fadeIn(delay: 700.ms, duration: 500.ms)
                        .shake(), // Efek animasi

                    const SizedBox(height: 32),
                    // --- Divider ---
                    _buildDivider(),

                    const SizedBox(height: 24),
                    // --- Tombol Social Media ---
                    _buildSocialLoginRow()
                        .animate()
                        .fadeIn(delay: 800.ms, duration: 500.ms)
                        .slideY(begin: 0.3, end: 0),

                    const SizedBox(height: 40),
                    // --- Link Daftar ---
                    _buildRegisterLink(),
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
    return Stack(
      children: [
        Positioned(
          top: -100,
          left: -100,
          child: Container(
            width: 300,
            height: 300,
            decoration: const BoxDecoration(
              color: kLightGreenBlob,
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          bottom: Get.height * 0.2,
          right: -150,
          child: Container(
            width: 400,
            height: 400,
            decoration: const BoxDecoration(
              color: kLightGreenBlob,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Masuk Akun',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: kDarkTextColor,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Yuk, masuk ke akun kamu!',
          style: TextStyle(
            fontSize: 18,
            color: kBodyTextColor,
          ),
        ),
      ],
    );
  }

  // Dekorasi Input Form (untuk dipakai di Email & Password)
  InputDecoration _inputDecoration(String hintText, IconData prefixIcon,
      {Widget? suffixIcon}) {
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

  Widget _buildEmailField() {
    return TextFormField(
      controller: controller.emailController,
      validator: controller.validateEmail,
      keyboardType: TextInputType.emailAddress,
      decoration: _inputDecoration('Email', Icons.mail_outline),
    );
  }

  Widget _buildPasswordField() {
    // Obx agar UI (icon) bereaksi terhadap perubahan state
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

  Widget _buildForgotPasswordLink() {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: controller.goToForgotPassword,
        child: const Text(
          'Lupa Password?',
          style: TextStyle(
            color: kPrimaryDarkGreen,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Get.offAllNamed(Routes.MAIN_NAVIGATION); // <-- langsung ke dashboard
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryDarkGreen,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: const Text(
        'Masuk',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildDivider() {
    return const Row(
      children: [
        Expanded(child: Divider(color: kTextFieldBorder, thickness: 1)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('atau gunakan', style: TextStyle(color: kBodyTextColor)),
        ),
        Expanded(child: Divider(color: kTextFieldBorder, thickness: 1)),
      ],
    );
  }

  Widget _buildSocialLoginRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialButton(FontAwesomeIcons.google, onTap: () {
          // Logic Google Sign-in nanti
        }),
        const SizedBox(width: 16),
        _buildSocialButton(FontAwesomeIcons.facebookF, onTap: () {
          // Logic Facebook Sign-in nanti
        }),
        const SizedBox(width: 16),
        _buildSocialButton(FontAwesomeIcons.apple, onTap: () {
          // Logic Apple Sign-in nanti
        }),
      ],
    );
  }

  Widget _buildSocialButton(IconData icon, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: kSocialButtonBg,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: FaIcon(icon, color: kDarkTextColor, size: 24),
        ),
      ),
    );
  }

  Widget _buildRegisterLink() {
    return Center(
      child: RichText(
        text: TextSpan(
          text: 'Tidak punya akun? ',
          style: const TextStyle(
            color: kBodyTextColor,
            fontSize: 16,
            fontFamily: 'Inter', // Pastikan sama dengan tema
          ),
          children: [
            TextSpan(
              text: 'Daftar sekarang',
              style: const TextStyle(
                color: kPrimaryDarkGreen,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                fontFamily: 'Inter',
              ),
              // Menggunakan GestureRecognizer untuk onTap di dalam RichText
              recognizer: TapGestureRecognizer()
                ..onTap = controller.goToRegister,
            ),
          ],
        ),
      ),
    );
  }
}