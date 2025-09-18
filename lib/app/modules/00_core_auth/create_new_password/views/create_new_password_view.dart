// lib/app/modules/create_new_password/views/create_new_password_view.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../theme/app_colors.dart';
import '../controllers/create_new_password_controller.dart';

class CreateNewPasswordView extends GetView<CreateNewPasswordController> {
  const CreateNewPasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Buat Password Baru"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: AppColors.textDark),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              const SizedBox(height: 32),
              _buildPasswordField(),
              const SizedBox(height: 16),
              _buildConfirmPasswordField(),
              const SizedBox(height: 32),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        FaIcon(FontAwesomeIcons.shieldHalved, size: 64, color: AppColors.primary),
        const SizedBox(height: 24),
        Text(
          "Satu Langkah Terakhir",
          style: Get.textTheme.titleLarge?.copyWith(fontSize: 24),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          "Masukkan password baru Anda. Pastikan password kuat dan mudah diingat.",
          style: Get.textTheme.bodyMedium?.copyWith(fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Obx(() => TextFormField(
          controller: controller.newPasswordC,
          obscureText: controller.isPasswordHidden.value,
          decoration: InputDecoration(
            labelText: 'Password Baru',
            prefixIcon: const FaIcon(FontAwesomeIcons.lock, size: 20),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            suffixIcon: IconButton(
              icon: FaIcon(
                controller.isPasswordHidden.value
                    ? FontAwesomeIcons.eyeSlash
                    : FontAwesomeIcons.eye,
                size: 20,
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
          decoration: InputDecoration(
            labelText: 'Konfirmasi Password Baru',
            prefixIcon: const FaIcon(FontAwesomeIcons.lock, size: 20),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            suffixIcon: IconButton(
              icon: FaIcon(
                controller.isConfirmPasswordHidden.value
                    ? FontAwesomeIcons.eyeSlash
                    : FontAwesomeIcons.eye,
                size: 20,
              ),
              onPressed: controller.toggleConfirmPasswordVisibility,
            ),
          ),
          validator: (value) {
            // Validasi pencocokan password
            if (value != controller.newPasswordC.text) {
              return 'Password tidak cocok';
            }
            return null;
          },
        ));
  }

  Widget _buildSubmitButton() {
    return Obx(() => FilledButton(
          onPressed: controller.isLoading.value ? null : controller.submitNewPassword,
          child: controller.isLoading.value
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                )
              : const Text('Simpan Password Baru'),
        ));
  }
}