// lib/app/modules/00_core_auth/auth_base/base_register_form.dart

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
    // Menggunakan SingleChildScrollView agar aman saat keyboard muncul
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Text (Opsional, jika ingin text spesifik di dalam form)
            if (headerText.isNotEmpty) ...[
              Text(
                headerText,
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.textLight,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
            ],
            
            _buildLabel("Nama Lengkap"),
            _buildNameField(),
            const SizedBox(height: 20),
            
            _buildLabel("Email Address"),
            _buildEmailField(),
            const SizedBox(height: 20),
            
            _buildLabel("Nomor WhatsApp"),
            _buildPhoneField(),
            const SizedBox(height: 20),
            
            _buildLabel("Password"),
            _buildPasswordField(),
            const SizedBox(height: 20),
            
            _buildLabel("Konfirmasi Password"),
            _buildConfirmPasswordField(),
            const SizedBox(height: 40),
            
            _buildRegisterButton(),
            const SizedBox(height: 30), // Bottom padding extra
          ],
        ),
      ),
    );
  }

  // --- HELPER WIDGETS ---
  
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

  Widget _buildNameField() {
    return TextFormField(
      controller: controller.nameC,
      keyboardType: TextInputType.name,
      style: const TextStyle(color: AppColors.textDark),
      decoration: _modernInputDecoration(nameHint, FontAwesomeIcons.user),
      validator: (value) => (value == null || value.isEmpty) ? 'Nama wajib diisi' : null,
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: controller.emailC,
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(color: AppColors.textDark),
      decoration: _modernInputDecoration(emailHint, FontAwesomeIcons.envelope),
      validator: (value) => (value == null || !GetUtils.isEmail(value)) ? 'Email tidak valid' : null,
    );
  }
  
  Widget _buildPhoneField() {
    return TextFormField(
      controller: controller.phoneC,
      keyboardType: TextInputType.phone,
      style: const TextStyle(color: AppColors.textDark),
      decoration: _modernInputDecoration('0812xxxx', FontAwesomeIcons.whatsapp),
      validator: (value) => (value == null || !GetUtils.isPhoneNumber(value)) ? 'Nomor tidak valid' : null,
    );
  }

  Widget _buildPasswordField() {
    return Obx(() => TextFormField(
      controller: controller.passwordC,
      obscureText: controller.isPasswordHidden.value,
      style: const TextStyle(color: AppColors.textDark),
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
      style: const TextStyle(color: AppColors.textDark),
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
      child: FilledButton(
        onPressed: controller.isLoading.value ? null : controller.register,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0, // Shadow dihandle container
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
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
      filled: true,
      fillColor: AppColors.greyLight, // Latar abu muda (Modern Style)
      
      prefixIcon: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Icon(prefixIcon, size: 18, color: AppColors.textLight),
      ),
      prefixIconConstraints: const BoxConstraints(minWidth: 50),
      
      suffixIcon: isPassword
          ? IconButton(
              icon: Icon(
                isHidden ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: AppColors.textLight,
                size: 20,
              ),
              onPressed: onToggle,
            )
          : null,
          
      // Border States
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none, // Hilangkan border default
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