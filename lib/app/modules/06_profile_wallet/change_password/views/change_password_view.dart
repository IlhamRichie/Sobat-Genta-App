// lib/app/modules/change_password/views/change_password_view.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../controllers/change_password_controller.dart';

class ChangePasswordView extends GetView<ChangePasswordController> {
  const ChangePasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ubah Password"),
      ),
      bottomNavigationBar: _buildBottomButton(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Jaga keamanan akun Anda dengan mengubah password secara berkala.",
                style: Get.textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              
              // 1. Password Saat Ini
              Obx(() => TextFormField(
                controller: controller.currentPassC,
                obscureText: controller.isCurrentPassHidden.value,
                decoration: _inputDecoration(
                  "Password Saat Ini",
                  FontAwesomeIcons.lock,
                  IconButton(
                    icon: FaIcon(controller.isCurrentPassHidden.value ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye, size: 20),
                    onPressed: controller.toggleCurrentPass,
                  )
                ),
                validator: (v) => (v == null || v.isEmpty) ? "Wajib diisi" : null,
              )),
              
              const Divider(height: 32),
              
              // 2. Password Baru
              Obx(() => TextFormField(
                controller: controller.newPassC,
                obscureText: controller.isNewPassHidden.value,
                decoration: _inputDecoration(
                  "Password Baru",
                  FontAwesomeIcons.key,
                  IconButton(
                    icon: FaIcon(controller.isNewPassHidden.value ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye, size: 20),
                    onPressed: controller.toggleNewPass,
                  )
                ),
                validator: (v) {
                  if (v == null || v.length < 6) return 'Password minimal 6 karakter';
                  return null;
                },
              )),
              const SizedBox(height: 16),
              
              // 3. Konfirmasi Password Baru
              Obx(() => TextFormField(
                controller: controller.confirmNewPassC,
                obscureText: controller.isConfirmNewPassHidden.value,
                decoration: _inputDecoration(
                  "Konfirmasi Password Baru",
                  FontAwesomeIcons.key,
                  IconButton(
                    icon: FaIcon(controller.isConfirmNewPassHidden.value ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye, size: 20),
                    onPressed: controller.toggleConfirmNewPass,
                  )
                ),
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

  InputDecoration _inputDecoration(String label, IconData icon, Widget? suffixIcon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: FaIcon(icon, size: 20),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      suffixIcon: suffixIcon,
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Obx(() => FilledButton(
        onPressed: controller.isLoading.value ? null : controller.submitChangePassword,
        child: controller.isLoading.value
            ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white))
            : const Text("Simpan Perubahan Password"),
      )),
    );
  }
}