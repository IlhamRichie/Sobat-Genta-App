import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../controllers/create_new_password_controller.dart';

// (Best Practice: Pindahkan ini ke lib/app/theme/app_colors.dart)
const kPrimaryDarkGreen = Color(0xFF3A8A40);
const kLightGreenBlob = Color(0xFFEAF4EB);
const kTextFieldBorder = Color(0xFFD9D9D9);
const kDarkTextColor = Color(0xFF1B2C1E);
const kBodyTextColor = Color(0xFF5A6A5C);

class CreateNewPasswordView extends GetView<CreateNewPasswordController> {
  const CreateNewPasswordView({Key? key}) : super(key: key);

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
                    SizedBox(height: Get.height * 0.05),
                    
                    _buildIllustration()
                        .animate()
                        .fadeIn(delay: 300.ms)
                        .scale(begin: const Offset(0.8, 0.8)),
                    
                    SizedBox(height: Get.height * 0.05),
                    
                    _buildHeader()
                        .animate()
                        .fadeIn(delay: 500.ms)
                        .slideY(begin: 0.2, end: 0),
                    
                    const SizedBox(height: 32),
                    
                    // --- Form Password Baru ---
                    _buildNewPasswordField()
                        .animate()
                        .fadeIn(delay: 600.ms)
                        .slideX(begin: -0.2, end: 0),
                    
                    const SizedBox(height: 16),
                    
                    // --- Form Konfirmasi Password ---
                    _buildConfirmPasswordField()
                        .animate()
                        .fadeIn(delay: 700.ms)
                        .slideX(begin: 0.2, end: 0),
                    
                    SizedBox(height: Get.height * 0.1),
                    
                    // --- Tombol Simpan ---
                    _buildResetButton(context)
                        .animate()
                        .fadeIn(delay: 800.ms),
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
      left: -150,
      child: Container(
        width: 300,
        height: 300,
        decoration: const BoxDecoration(
          color: kLightGreenBlob,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _buildIllustration() {
    // Placeholder untuk ilustrasi modern
    // 
    return Center(
      child: Container(
        padding: const EdgeInsets.all(40),
        decoration: const BoxDecoration(
          color: kLightGreenBlob, // Warna blob
          shape: BoxShape.circle,
        ),
        child: FaIcon(
          FontAwesomeIcons.key, // Icon ganti password
          size: Get.height * 0.1,
          color: kPrimaryDarkGreen,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Buat Password Baru',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: kDarkTextColor,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Password baru Anda harus berbeda dari password yang pernah digunakan sebelumnya.',
          style: TextStyle(
            fontSize: 17,
            color: kBodyTextColor,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  // (Best Practice: Helper ini sudah di-refactor agar bisa menerima suffixIcon)
  InputDecoration _inputDecoration(
    String hintText,
    IconData prefixIcon, {
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: kBodyTextColor),
      prefixIcon: Icon(prefixIcon, color: kBodyTextColor),
      suffixIcon: suffixIcon, // Tambahkan suffixIcon di sini
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

  Widget _buildNewPasswordField() {
    return Obx(() {
      return TextFormField(
        controller: controller.newPasswordController,
        validator: controller.validatePassword,
        obscureText: controller.isPasswordHidden.value,
        decoration: _inputDecoration(
          'Password Baru',
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
          'Konfirmasi Password Baru',
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

  Widget _buildResetButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => controller.resetPassword(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryDarkGreen,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: const Text(
        'Simpan Password Baru',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}