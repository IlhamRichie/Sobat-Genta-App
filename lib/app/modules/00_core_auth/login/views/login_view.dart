import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../routes/app_pages.dart';
import '../../../../theme/app_colors.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Bikin status bar menyatu dengan background
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. BACKGROUND ORNAMENTS (Lebih Soft & Artistik)
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 100,
            left: -80,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.05), // Sedikit variasi warna
                shape: BoxShape.circle,
              ),
            ),
          ),

          // 2. MAIN CONTENT
          Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Form(
                key: controller.formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildBrandLogo(),
                    const SizedBox(height: 40),
                    _buildWelcomeText(),
                    const SizedBox(height: 40),
                    
                    // Inputs
                    _buildInputLabel("Email Address"),
                    _buildEmailField(),
                    const SizedBox(height: 20),
                    
                    _buildInputLabel("Password"),
                    _buildPasswordField(),
                    const SizedBox(height: 12),
                    
                    _buildForgotPasswordLink(),
                    const SizedBox(height: 32),
                    
                    _buildLoginButton(),
                    const SizedBox(height: 40),
                    
                    _buildRegisterLink(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Logo Brand Besar di Tengah
  Widget _buildBrandLogo() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Center(
            child: FaIcon(FontAwesomeIcons.leaf, size: 40, color: Colors.white),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          "GENTA",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: AppColors.primary,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }

  /// Teks Sapaan
  Widget _buildWelcomeText() {
    return Column(
      children: [
        const Text(
          "Selamat Datang Kembali!",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3436),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          "Masuk untuk mengelola pertanian dan\ninvestasi Anda dengan mudah.",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade500,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF2D3436),
        ),
      ),
    );
  }

  /// Field Email dengan Style Modern
  Widget _buildEmailField() {
    return TextFormField(
      controller: controller.emailC,
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(fontWeight: FontWeight.w600),
      decoration: _modernInputDecoration(
        hintText: "nama@email.com",
        icon: FontAwesomeIcons.envelope,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Email tidak boleh kosong';
        if (!GetUtils.isEmail(value)) return 'Format email salah';
        return null;
      },
    );
  }

  /// Field Password dengan Toggle Visibility
  Widget _buildPasswordField() {
    return Obx(() => TextFormField(
      controller: controller.passwordC,
      obscureText: controller.isPasswordHidden.value,
      style: const TextStyle(fontWeight: FontWeight.w600),
      decoration: _modernInputDecoration(
        hintText: "••••••••",
        icon: FontAwesomeIcons.lock,
        suffixIcon: IconButton(
          icon: Icon(
            controller.isPasswordHidden.value ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey.shade400,
            size: 20,
          ),
          onPressed: controller.togglePasswordVisibility,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Password tidak boleh kosong';
        return null;
      },
    ));
  }

  Widget _buildForgotPasswordLink() {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () => Get.toNamed(Routes.FORGOT_PASSWORD),
        child: const Text(
          "Lupa Password?",
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  /// Tombol Login Besar
  Widget _buildLoginButton() {
    return Obx(() => SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: controller.isLoading.value ? null : controller.login,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 10,
          shadowColor: AppColors.primary.withOpacity(0.4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: controller.isLoading.value
            ? const SizedBox(
                height: 24, 
                width: 24, 
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5)
              )
            : const Text(
                "Masuk Sekarang",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
      ),
    ));
  }

  /// Footer Daftar
  Widget _buildRegisterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Belum punya akun? ", style: TextStyle(color: Colors.grey.shade600)),
        GestureDetector(
          onTap: () => Get.toNamed(Routes.REGISTER_ROLE_CHOOSER),
          child: const Text(
            "Daftar",
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }

  /// Dekorasi Input yang Clean
  InputDecoration _modernInputDecoration({
    required String hintText,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.normal),
      filled: true,
      fillColor: const Color(0xFFF9F9F9), // Abu sangat muda
      prefixIcon: Padding(
        padding: const EdgeInsets.all(14),
        child: FaIcon(icon, size: 18, color: Colors.grey.shade400),
      ),
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
    );
  }
}