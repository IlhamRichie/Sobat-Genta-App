// lib/app/modules/auth_base/base_register_form.dart

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
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              headerText,
              style: Get.textTheme.titleMedium?.copyWith(
                fontSize: 18,
                color: AppColors.textLight,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            
            _buildNameField(),
            const SizedBox(height: 16),
            _buildEmailField(),
            const SizedBox(height: 16),
            _buildPhoneField(),
            const SizedBox(height: 16),
            _buildPasswordField(),
            const SizedBox(height: 16),
            _buildConfirmPasswordField(),
            const SizedBox(height: 40),
            
            _buildRegisterButton(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // --- HELPER WIDGETS ---
  
  Widget _buildNameField() {
    return TextFormField(
      controller: controller.nameC,
      keyboardType: TextInputType.name,
      decoration: _inputDecoration('Nama Lengkap', nameHint, FontAwesomeIcons.solidUser),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Nama tidak boleh kosong';
        }
        return null;
      },
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: controller.emailC,
      keyboardType: TextInputType.emailAddress,
      decoration: _inputDecoration('Email', emailHint, FontAwesomeIcons.solidEnvelope),
      validator: (value) {
        if (value == null || !GetUtils.isEmail(value)) {
          return 'Format email tidak valid';
        }
        return null;
      },
    );
  }
  
  Widget _buildPhoneField() {
    return TextFormField(
      controller: controller.phoneC,
      keyboardType: TextInputType.phone,
      decoration: _inputDecoration('Nomor Telepon (WhatsApp)', '08123456789', FontAwesomeIcons.phone),
      validator: (value) {
        if (value == null || !GetUtils.isPhoneNumber(value)) {
          return 'Nomor telepon tidak valid';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return Obx(() => TextFormField(
      controller: controller.passwordC,
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

  Widget _buildConfirmPasswordField() {
    return Obx(() => TextFormField(
      controller: controller.confirmPasswordC,
      obscureText: controller.isConfirmPasswordHidden.value,
      decoration: _inputDecoration(
        'Konfirmasi Password',
        'Ulangi password di atas',
        FontAwesomeIcons.lock,
        suffixIcon: IconButton(
          icon: FaIcon(
            controller.isConfirmPasswordHidden.value
                ? FontAwesomeIcons.eyeSlash
                : FontAwesomeIcons.eye,
            size: 20,
            color: AppColors.textLight,
          ),
          onPressed: controller.toggleConfirmPasswordVisibility,
        ),
      ),
      validator: (value) {
        if (value != controller.passwordC.text) {
          return 'Password tidak cocok';
        }
        return null;
      },
    ));
  }

  Widget _buildRegisterButton() {
    return Obx(() => FilledButton(
      onPressed: controller.isLoading.value ? null : controller.register,
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
              'Daftar',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
    ));
  }
  
  // Custom InputDecoration untuk konsistensi
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