import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart'; // Import package Pinput
import '../controllers/otp_verification_controller.dart';

// (Best Practice: Pindahkan ini ke lib/app/theme/app_colors.dart)
const kPrimaryDarkGreen = Color(0xFF3A8A40);
const kLightGreenBlob = Color(0xFFEAF4EB);
const kTextFieldBorder = Color(0xFFD9D9D9);
const kDarkTextColor = Color(0xFF1B2C1E);
const kBodyTextColor = Color(0xFF5A6A5C);

class OtpVerificationView extends GetView<OtpVerificationController> {
  const OtpVerificationView({Key? key}) : super(key: key);

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
                // Key tidak terlalu dibutuhkan di sini, tapi OK
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: Get.height * 0.1),
                    
                    _buildHeader()
                        .animate()
                        .fadeIn(delay: 300.ms)
                        .slideY(begin: 0.2, end: 0),
                    
                    const SizedBox(height: 16),
                    
                    _buildSubHeader()
                        .animate()
                        .fadeIn(delay: 500.ms)
                        .slideY(begin: 0.2, end: 0),
                    
                    const SizedBox(height: 40),
                    
                    _buildPinInput(context)
                        .animate()
                        .fadeIn(delay: 700.ms)
                        .slideX(begin: 0.2, end: 0),
                    
                    const SizedBox(height: 32),
                    
                    _buildResendCode(context)
                        .animate()
                        .fadeIn(delay: 800.ms),
                    
                    SizedBox(height: Get.height * 0.1),
                    
                    _buildVerifyButton(context)
                        .animate()
                        .fadeIn(delay: 900.ms),
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
      top: Get.height * 0.4,
      right: -150,
      child: Container(
        width: 400,
        height: 400,
        decoration: const BoxDecoration(
          color: kLightGreenBlob,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Text(
      'Verifikasi Kode OTP',
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: kDarkTextColor,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSubHeader() {
    // Obx agar text email reaktif
    return Obx(() {
      return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: 'Masukkan 6 digit kode yang telah kami kirimkan ke ',
          style: const TextStyle(
            fontSize: 17,
            color: kBodyTextColor,
            height: 1.5,
            fontFamily: 'Inter', // Pastikan font konsisten
          ),
          children: [
            TextSpan(
              text: controller.userEmail.value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: kDarkTextColor,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildPinInput(BuildContext context) {
    // Tema untuk Pinput (Default)
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: const TextStyle(
        fontSize: 22,
        color: kDarkTextColor,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: kTextFieldBorder, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
    );

    // Tema untuk Pinput (Focused)
    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: kPrimaryDarkGreen, width: 2),
      ),
    );

    return Pinput(
      controller: controller.pinController,
      length: 6, // 6 digit OTP
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: focusedPinTheme,
      // Panggil controller saat 6 digit terisi
      onCompleted: (pin) => controller.verifyOtp(pin, context),
      autofocus: true,
      hapticFeedbackType: HapticFeedbackType.lightImpact,
    );
  }

  Widget _buildResendCode(BuildContext context) {
    // Obx agar UI reaktif terhadap timer
    return Obx(() {
      return Center(
        child: RichText(
          text: TextSpan(
            text: 'Tidak menerima kode? ',
            style: const TextStyle(
              color: kBodyTextColor,
              fontSize: 16,
              fontFamily: 'Inter',
            ),
            children: [
              if (controller.isResendActive.value)
                TextSpan(
                  text: 'Kirim ulang',
                  style: const TextStyle(
                    color: kPrimaryDarkGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => controller.resendCode(context),
                )
              else
                TextSpan(
                  text: 'Kirim ulang (${controller.countdown.value}s)',
                  style: const TextStyle(
                    color: kBodyTextColor, // Abu-abu saat non-aktif
                    fontSize: 16,
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildVerifyButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => controller.verifyOtp(controller.pinController.text, context),
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryDarkGreen,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: const Text(
        'Verifikasi',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}