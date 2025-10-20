// lib/app/modules/change_password/views/change_password_view.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../theme/app_colors.dart';
import '../controllers/change_password_controller.dart';

class ChangePasswordView extends GetView<ChangePasswordController> {
  const ChangePasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      bottomNavigationBar: _buildBottomButton(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Jaga keamanan akun Anda dengan mengubah password secara berkala.",
                style: Get.textTheme.bodyLarge?.copyWith(color: AppColors.textLight),
              ),
              const SizedBox(height: 32),
              
              // 1. Password Saat Ini
              _buildSectionTitle("Password Saat Ini"),
              Obx(() => _buildTextFormField(
                controller: controller.currentPassC,
                label: "Password Lama",
                icon: FontAwesomeIcons.lock,
                isHidden: controller.isCurrentPassHidden.value,
                onToggle: controller.toggleCurrentPass,
                validator: (v) => (v == null || v.isEmpty) ? "Wajib diisi" : null,
              )),
              
              const SizedBox(height: 32),
              
              // 2. Password Baru
              _buildSectionTitle("Password Baru"),
              Obx(() => _buildTextFormField(
                controller: controller.newPassC,
                label: "Password Baru",
                icon: FontAwesomeIcons.key,
                isHidden: controller.isNewPassHidden.value,
                onToggle: controller.toggleNewPass,
                validator: (v) {
                  if (v == null || v.length < 6) return 'Password minimal 6 karakter';
                  return null;
                },
              )),
              const SizedBox(height: 16),
              
              // 3. Konfirmasi Password Baru
              Obx(() => _buildTextFormField(
                controller: controller.confirmNewPassC,
                label: "Konfirmasi Password Baru",
                icon: FontAwesomeIcons.key,
                isHidden: controller.isConfirmNewPassHidden.value,
                onToggle: controller.toggleConfirmNewPass,
                validator: (v) {
                  if (v != controller.newPassC.text) {
                    return 'Password baru tidak cocok';
                  }
                  return null;
                },
              )),
            ],
          ),
        ),
      ),
    );
  }

  /// AppBar Kustom
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: BackButton(onPressed: () => Get.back(), color: AppColors.textDark),
      title: Text(
        "Ubah Password",
        style: Get.textTheme.headlineSmall?.copyWith(
          color: AppColors.textDark,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: false,
    );
  }

  /// Helper untuk Judul Section
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: Get.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
        ),
      ),
    );
  }

  /// Helper untuk TextFormField (Didesain Ulang)
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isHidden,
    required VoidCallback onToggle,
    required String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isHidden,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: FaIcon(icon, size: 20, color: AppColors.textLight),
        suffixIcon: IconButton(
          icon: FaIcon(isHidden ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye, size: 20, color: AppColors.textLight),
          onPressed: onToggle,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.greyLight)),
      ),
      validator: validator,
    );
  }

  /// Tombol CTA Bawah (Didesain Ulang)
  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Obx(() => FilledButton(
        onPressed: controller.isLoading.value ? null : controller.submitChangePassword,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
        ),
        child: controller.isLoading.value
            ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : const Text("Simpan Perubahan Password", style: TextStyle(fontWeight: FontWeight.bold)),
      )),
    );
  }
}