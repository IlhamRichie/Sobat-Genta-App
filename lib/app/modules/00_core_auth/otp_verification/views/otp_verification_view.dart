// lib/app/modules/otp_verification/views/otp_verification_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import '../../../../theme/app_colors.dart';
import '../controllers/otp_verification_controller.dart';

class OtpVerificationView extends GetView<OtpVerificationController> {
  const OtpVerificationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Definisikan tema untuk 'pinput'
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: Get.textTheme.titleLarge?.copyWith(fontSize: 22, color: AppColors.textDark),
      decoration: BoxDecoration(
        color: AppColors.greyLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.transparent),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Verifikasi OTP"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: AppColors.textDark),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            const SizedBox(height: 32),
            _buildPinput(defaultPinTheme),
            const SizedBox(height: 32),
            _buildVerifyButton(),
            const SizedBox(height: 24),
            _buildResendCode(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          "Masukkan Kode Verifikasi",
          style: Get.textTheme.titleLarge?.copyWith(fontSize: 24),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          "Kami telah mengirimkan 6 digit kode OTP ke",
          style: Get.textTheme.bodyMedium?.copyWith(fontSize: 16),
          textAlign: TextAlign.center,
        ),
        Text(
          controller.email, // Ambil email dari controller
          style: Get.textTheme.bodyMedium?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildPinput(PinTheme defaultPinTheme) {
    return Center(
      child: Pinput(
        controller: controller.otpC,
        length: 6,
        autofocus: true,
        defaultPinTheme: defaultPinTheme,
        // Tema saat di-fokus
        focusedPinTheme: defaultPinTheme.copyWith(
          decoration: defaultPinTheme.decoration!.copyWith(
            border: Border.all(color: AppColors.primary),
          ),
        ),
        // Tema saat sudah di-submit
        submittedPinTheme: defaultPinTheme.copyWith(
          decoration: defaultPinTheme.decoration!.copyWith(
            color: AppColors.primary.withOpacity(0.1),
          ),
        ),
        validator: (s) {
          return s?.length == 6 ? null : 'Harap isi 6 digit OTP';
        },
        // Otomatis verifikasi saat 6 digit terisi
        onCompleted: (pin) => controller.verifyOtp(),
      ),
    );
  }

  Widget _buildVerifyButton() {
    return Obx(() => FilledButton(
          onPressed: controller.isLoading.value ? null : controller.verifyOtp,
          child: controller.isLoading.value
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                )
              : const Text('Verifikasi'),
        ));
  }

  Widget _buildResendCode() {
    // Gunakan Obx untuk mendengarkan perubahan 'countdown'
    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Tidak menerima kode?',
              style: Get.textTheme.bodyMedium,
            ),
            TextButton(
              // Tombol non-aktif jika countdown > 0
              onPressed: controller.countdown.value == 0
                  ? controller.resendOtp
                  : null,
              child: Text(
                controller.countdown.value == 0
                    ? 'Kirim Ulang'
                    // Tampilkan timer
                    : 'Kirim Ulang (${controller.countdown.value}s)',
                style: TextStyle(
                  color: controller.countdown.value == 0
                      ? AppColors.primary
                      : AppColors.textLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ));
  }
}