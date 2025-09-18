// lib/app/modules/otp_verification/controllers/otp_verification_controller.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../data/repositories/abstract/auth_repository.dart';
import '../../../../routes/app_pages.dart';

class OtpVerificationController extends GetxController {
  
  final IAuthRepository _authRepo = Get.find<IAuthRepository>();

  // --- FORM & STATE ---
  final TextEditingController otpC = TextEditingController();
  final RxBool isLoading = false.obs;
  
  // --- PAGE ARGUMENTS ---
  // Variabel ini akan diisi saat onInit
  late final String email;
  late final String purpose; // 'registration' atau 'reset_password'

  // --- COUNTDOWN TIMER ---
  Timer? _timer;
  final RxInt countdown = 60.obs;

  @override
  void onInit() {
    super.onInit();
    
    // Ambil argumen yang dikirim dari halaman sebelumnya
    if (Get.arguments is Map) {
      email = Get.arguments['email'] as String;
      purpose = Get.arguments['purpose'] as String;
    } else {
      // Fallback jika argumen tidak ada (seharusnya tidak terjadi)
      email = 'Email tidak ditemukan';
      purpose = '';
      Get.back(); // Kembali jika tidak ada data
    }
    
    startCountdown();
  }

  @override
  void onClose() {
    _timer?.cancel(); // Selalu matikan timer
    otpC.dispose();
    super.onClose();
  }

  /// Memulai timer countdown
  void startCountdown() {
    countdown.value = 60;
    _timer?.cancel(); // Matikan timer lama jika ada
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown.value > 0) {
        countdown.value--;
      } else {
        timer.cancel(); // Hentikan timer jika sudah 0
      }
    });
  }

  /// Meminta kirim ulang OTP
  Future<void> resendOtp() async {
    if (countdown.value > 0) return; // Jangan kirim jika timer masih jalan

    isLoading.value = true;
    try {
      await _authRepo.resendOtp(email, purpose);
      showTopSnackBar(
        Overlay.of(Get.context!),
        CustomSnackBar.success(message: "OTP baru telah dikirim ke $email"),
      );
      startCountdown(); // Mulai ulang countdown
    } catch (e) {
      showTopSnackBar(
        Overlay.of(Get.context!),
        CustomSnackBar.error(message: e.toString().replaceAll("Exception: ", "")),
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Memverifikasi OTP yang dimasukkan
  Future<void> verifyOtp() async {
    if (otpC.text.length != 6) {
      showTopSnackBar(
        Overlay.of(Get.context!),
        CustomSnackBar.info(message: "Harap isi 6 digit kode OTP"),
      );
      return;
    }
    
    isLoading.value = true;
    try {
      // Panggil repository
      final resultToken = await _authRepo.verifyOtp(email, otpC.text, purpose);
      
      _timer?.cancel(); // Matikan timer
      
      // --- INI LOGIKA UTAMA-NYA ---
      // Tentukan navigasi berdasarkan 'purpose'
      
      if (purpose == 'registration') {
        // Alur registrasi selesai
        showTopSnackBar(
          Overlay.of(Get.context!),
          CustomSnackBar.success(message: "Verifikasi berhasil! Silakan login."),
        );
        // Hapus semua stack, lempar ke Login
        Get.offAllNamed(Routes.LOGIN); 
        
      } else if (purpose == 'reset_password') {
        // Alur lupa password berlanjut
        showTopSnackBar(
          Overlay.of(Get.context!),
          CustomSnackBar.success(message: "Verifikasi berhasil!"),
        );
        // Buka halaman Buat Password Baru
        Get.toNamed(
          Routes.CREATE_NEW_PASSWORD,
          arguments: {
            'email': email,
            'token': resultToken, // Kirim 'token reset' yang kita dapat dari repo
          },
        );
      }

    } catch (e) {
      showTopSnackBar(
        Overlay.of(Get.context!),
        CustomSnackBar.error(message: e.toString().replaceAll("Exception: ", "")),
      );
    } finally {
      isLoading.value = false;
    }
  }
}