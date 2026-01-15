import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../theme/app_colors.dart';
import 'base_register_controller.dart';

class BaseRegisterForm extends StatelessWidget {
  final BaseRegisterController controller;
  final String headerText, nameHint, emailHint;
  
  const BaseRegisterForm({
    Key? key,
    required this.controller,
    required this.headerText,
    required this.nameHint,
    required this.emailHint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Text (Optional)
            if (headerText.isNotEmpty) ...[
              Text(
                headerText,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
            ],
            
            // --- FORM FIELDS ---
            _buildInputGroup("Nama Lengkap", _buildNameField()),
            const SizedBox(height: 20),
            
            _buildInputGroup("Email Address", _buildEmailField()),
            const SizedBox(height: 20),
            
            _buildInputGroup("Nomor WhatsApp", _buildPhoneField()),
            const SizedBox(height: 20),
            
            _buildInputGroup("Password", _buildPasswordField()),
            const SizedBox(height: 20),
            
            _buildInputGroup("Konfirmasi Password", _buildConfirmPasswordField()),
            const SizedBox(height: 40),
            
            // --- ACTION BUTTON ---
            _buildRegisterButton(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // --- HELPER BUILDERS ---

  /// Membungkus Label + Input Field agar rapi
  Widget _buildInputGroup(String label, Widget field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Color(0xFF2D3436), // Warna teks label dark grey
            ),
          ),
        ),
        field,
      ],
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: controller.nameC,
      keyboardType: TextInputType.name,
      style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF2D3436)),
      decoration: _modernInputDecoration(nameHint, FontAwesomeIcons.user),
      validator: (value) => (value == null || value.isEmpty) ? 'Nama wajib diisi' : null,
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: controller.emailC,
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF2D3436)),
      decoration: _modernInputDecoration(emailHint, FontAwesomeIcons.envelope),
      validator: (value) => (value == null || !GetUtils.isEmail(value)) ? 'Email tidak valid' : null,
    );
  }
  
  Widget _buildPhoneField() {
    return TextFormField(
      controller: controller.phoneC,
      keyboardType: TextInputType.phone,
      style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF2D3436)),
      decoration: _modernInputDecoration('0812xxxx', FontAwesomeIcons.whatsapp),
      validator: (value) => (value == null || !GetUtils.isPhoneNumber(value)) ? 'Nomor tidak valid' : null,
    );
  }

  Widget _buildPasswordField() {
    return Obx(() => TextFormField(
      controller: controller.passwordC,
      obscureText: controller.isPasswordHidden.value,
      style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF2D3436)),
      decoration: _modernInputDecoration(
        'Minimal 6 karakter',
        FontAwesomeIcons.lock,
        isPassword: true,
        isHidden: controller.isPasswordHidden.value,
        onToggle: controller.togglePasswordVisibility,
      ),
      validator: (value) => (value == null || value.length < 6) ? 'Password minimal 6 karakter' : null,
    ));
  }

  Widget _buildConfirmPasswordField() {
    return Obx(() => TextFormField(
      controller: controller.confirmPasswordC,
      obscureText: controller.isConfirmPasswordHidden.value,
      style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF2D3436)),
      decoration: _modernInputDecoration(
        'Ulangi password',
        FontAwesomeIcons.lock,
        isPassword: true,
        isHidden: controller.isConfirmPasswordHidden.value,
        onToggle: controller.toggleConfirmPasswordVisibility,
      ),
      validator: (value) {
        if (value != controller.passwordC.text) return 'Password tidak cocok';
        return null;
      },
    ));
  }

  Widget _buildRegisterButton() {
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
      child: ElevatedButton(
        onPressed: controller.isLoading.value ? null : controller.register,
        style: ElevatedButton.styleFrom(
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
                'Daftar Sekarang',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
      ),
    ));
  }
  
  // --- MODERN INPUT DECORATION ---
  InputDecoration _modernInputDecoration(
    String hintText, 
    IconData prefixIcon, {
    bool isPassword = false,
    bool isHidden = false,
    VoidCallback? onToggle,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
      filled: true,
      fillColor: const Color(0xFFF9F9F9), // Abu sangat muda
      
      prefixIcon: Padding(
        padding: const EdgeInsets.all(14),
        child: FaIcon(prefixIcon, size: 18, color: Colors.grey.shade400),
      ),
      
      suffixIcon: isPassword
          ? IconButton(
              icon: Icon(
                isHidden ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: Colors.grey.shade400,
                size: 20,
              ),
              onPressed: onToggle,
            )
          : null,
          
      // Border States
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
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
    );
  }
}