// lib/app/modules/login/views/login_view.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../routes/app_pages.dart';
import '../../../../theme/app_colors.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // AppBar transparan agar menyatu dengan body
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: AppColors.textDark),
      ),
      body: SingleChildScrollView(
        // Best practice: Selalu bungkus form dengan SingleChildScrollView
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: controller.formKey, // Hubungkan form dengan formKey di controller
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              const SizedBox(height: 32),
              _buildEmailField(),
              const SizedBox(height: 16),
              _buildPasswordField(),
              const SizedBox(height: 16),
              _buildForgotPasswordLink(),
              const SizedBox(height: 32),
              _buildLoginButton(),
              const SizedBox(height: 24),
              _buildRegisterLink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          "Selamat Datang Kembali",
          style: Get.textTheme.titleLarge?.copyWith(fontSize: 24),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          "Login untuk melanjutkan ke akun SobatGenta Anda.",
          style: Get.textTheme.bodyMedium?.copyWith(fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: controller.emailC,
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'contoh: budi@petani.com',
        prefixIcon: const FaIcon(FontAwesomeIcons.envelope, size: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Email tidak boleh kosong';
        }
        if (!GetUtils.isEmail(value)) {
          return 'Format email tidak valid';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    // Bungkus dengan Obx agar UI di-build ulang saat
    // controller.isPasswordHidden berubah
    return Obx(() => TextFormField(
          controller: controller.passwordC,
          autocorrect: false,
          obscureText: controller.isPasswordHidden.value,
          decoration: InputDecoration(
            labelText: 'Password',
            prefixIcon: const FaIcon(FontAwesomeIcons.lock, size: 20),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            suffixIcon: IconButton(
              icon: FaIcon(
                // Ganti ikon berdasarkan state
                controller.isPasswordHidden.value
                    ? FontAwesomeIcons.eyeSlash
                    : FontAwesomeIcons.eye,
                size: 20,
              ),
              onPressed: controller.togglePasswordVisibility,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Password tidak boleh kosong';
            }
            if (value.length < 6) {
              return 'Password minimal 6 karakter';
            }
            return null;
          },
        ));
  }

  Widget _buildForgotPasswordLink() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          Get.toNamed(Routes.FORGOT_PASSWORD);
        },
        child: const Text(
          'Lupa Password?',
          style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    // Bungkus tombol dengan Obx untuk merespon state isLoading
    return Obx(() => FilledButton(
          // Nonaktifkan tombol jika sedang loading
          onPressed: controller.isLoading.value ? null : controller.login,
          child: controller.isLoading.value
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                )
              : const Text('Login'),
        ));
  }

  Widget _buildRegisterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Belum punya akun?', style: Get.textTheme.bodyMedium),
        TextButton(
          onPressed: () {
            // Arahkan ke halaman pemilih peran
            Get.toNamed(Routes.REGISTER_ROLE_CHOOSER);
          },
          child: const Text(
            'Daftar di sini',
            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}