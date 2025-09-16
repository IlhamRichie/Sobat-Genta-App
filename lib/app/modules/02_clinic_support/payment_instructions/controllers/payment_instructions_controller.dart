import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import untuk Clipboard
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../../../data/models/expert_model.dart';
import '../../../../data/models/payment_method_model.dart'; // Import model
import '../../../../routes/app_pages.dart'; // Import routes

class PaymentInstructionsController extends GetxController {
  
  // --- State Data Diterima ---
  late ExpertModel expertData;
  late PaymentMethodModel paymentMethod;
  late double totalPayment;

  // --- State Halaman ---
  final String virtualAccount = '8808 1234 5678 9012'; // (Dummy VA Number)
  late Timer _timer;
  final Rx<Duration> countdown = const Duration(minutes: 10).obs;

  @override
  void onInit() {
    super.onInit();
    
    // 1. Tangkap semua arguments
    final args = Get.arguments as Map<String, dynamic>;
    expertData = args['expert'];
    paymentMethod = args['payment'];
    totalPayment = args['total'];

    // 2. Mulai timer
    startTimer();
  }

  @override
  void onClose() {
    _timer.cancel(); // Wajib dispose timer
    super.onClose();
  }

  // --- Logic Timer ---
  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (countdown.value.inSeconds > 0) {
        countdown.value = countdown.value - Duration(seconds: 1);
      } else {
        timer.cancel();
        // (Nanti di sini ada logic 'transaksi expired')
      }
    });
  }

  // Helper untuk format timer (09:59)
  String get formattedCountdown {
    final minutes = countdown.value.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = countdown.value.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  // --- Aksi Tombol ---

  // Aksi untuk menyalin VA ke clipboard
  void copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: virtualAccount));
    showTopSnackBar(
      Overlay.of(context),
      const CustomSnackBar.success(
        message: "Nomor Virtual Account berhasil disalin!",
      ),
      displayDuration: Duration(seconds: 1),
    );
  }

  // Aksi untuk tombol "Proses Pembayaran"
  void checkPaymentStatus(BuildContext context) {
    // (LOGIC API CEK STATUS NANTI DI SINI)
    
    // (UI SEMENTARA: Langsung anggap sukses)
    showTopSnackBar(
      Overlay.of(context),
      const CustomSnackBar.success(
        message: "Pembayaran terdeteksi! Transaksi berhasil.",
      ),
    );

    _timer.cancel(); // Hentikan timer

    // Arahkan ke halaman Sukses (sesuai image_8fc7cb.png)
    Future.delayed(1500.ms, () {
      Get.offNamed( // 'offNamed' agar tidak bisa kembali ke halaman ini
        Routes.PAYMENT_SUCCESS,
        arguments: {
          'expert': expertData,
          'payment': paymentMethod,
          'total': totalPayment,
        },
      );
    });
  }
}