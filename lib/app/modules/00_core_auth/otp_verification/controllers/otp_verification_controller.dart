import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../../../routes/app_pages.dart';

class OtpVerificationController extends GetxController {
  
  // Controller untuk Pinput
  late TextEditingController pinController;

  // Email didapat dari halaman sebelumnya (ForgotPasswordPage)
  final RxString userEmail = "".obs;

  // Logic Timer Countdown
  late Timer _timer;
  final RxInt countdown = 60.obs;
  final RxBool isResendActive = false.obs;

  @override
  void onInit() {
    super.onInit();
    pinController = TextEditingController();
    
    // Ambil email dari arguments
    if (Get.arguments != null) {
      userEmail.value = Get.arguments as String;
    }
    
    // Langsung mulai timer saat halaman dibuka
    startTimer();
  }

  @override
  void onClose() {
    pinController.dispose();
    _timer.cancel(); // Matikan timer saat controller ditutup
    super.onClose();
  }

  // --- Logic Timer ---
  void startTimer() {
    isResendActive.value = false;
    countdown.value = 60; // Reset timer
    _timer = Timer.periodic(1.seconds, (timer) {
      if (countdown.value > 0) {
        countdown.value--;
      } else {
        timer.cancel();
        isResendActive.value = true;
      }
    });
  }

  // --- Aksi Tombol ---

  void resendCode(BuildContext context) {
    if (isResendActive.value) {
      // (LOGIC API KIRIM ULANG OTP NANTI DI SINI)
      
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.success(
          message: "Kode OTP baru telah dikirim ulang.",
        ),
      );
      startTimer(); // Mulai ulang timer
    }
  }

  void verifyOtp(String pin, BuildContext context) {
    // (LOGIC API VERIFIKASI OTP NANTI DI SINI)

    // --- (UI SEMENTARA) ---
    // Kita anggap kode sukses adalah '123456'
    if (pin == '123456') {
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.success(
          message: "Verifikasi Berhasil! Silakan buat password baru.",
        ),
      );
      
      _timer.cancel(); // Hentikan timer
      
      // Lanjut ke halaman berikutnya
      Get.offNamed(
        Routes.CREATE_NEW_PASSWORD,
        arguments: userEmail.value, // Kirim email/token ke halaman berikutnya
      );

    } else {
      // Jika GAGAL
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.error(
          message: "Kode OTP salah. Silakan coba lagi.",
        ),
      );
      pinController.clear(); // Bersihkan input
    }
  }
}