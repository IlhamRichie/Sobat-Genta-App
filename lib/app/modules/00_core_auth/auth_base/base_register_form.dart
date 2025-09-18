// lib/app/modules/auth_base/base_register_form.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'base_register_controller.dart';

class BaseRegisterForm extends StatelessWidget {
  // Terima controller via constructor
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
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              headerText,
              style: Get.textTheme.bodyMedium?.copyWith(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            // Semua field di bawah ini sekarang menggunakan 'controller.'
            // yang di-pass dari constructor.
            _buildNameField(),
            const SizedBox(height: 16),
            _buildEmailField(),
            const SizedBox(height: 16),
            _buildPhoneField(),
            const SizedBox(height: 16),
            _buildPasswordField(),
            const SizedBox(height: 16),
            _buildConfirmPasswordField(),
            const SizedBox(height: 32),
            _buildRegisterButton(),
          ],
        ),
      ),
    );
  }

  // --- SEMUA WIDGET FORM DI BAWAH INI IDENTIK DENGAN SEBELUMNYA ---
  // (Mereka sekarang membaca dari 'controller.' yang dilempar)

  Widget _buildNameField() {
    return TextFormField(
      controller: controller.nameC,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        labelText: 'Nama Lengkap',
        hintText: nameHint,
        prefixIcon: const FaIcon(FontAwesomeIcons.solidUser, size: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
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
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: emailHint,
        prefixIcon: const FaIcon(FontAwesomeIcons.solidEnvelope, size: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
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
      decoration: InputDecoration(
        labelText: 'Nomor Telepon (WhatsApp)',
        hintText: '08123456789',
        prefixIcon: const FaIcon(FontAwesomeIcons.phone, size: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
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
          decoration: InputDecoration(
            labelText: 'Password',
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
            labelText: 'Konfirmasi Password',
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
          child: controller.isLoading.value
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                )
              : const Text('Daftar'),
        ));
  }
}