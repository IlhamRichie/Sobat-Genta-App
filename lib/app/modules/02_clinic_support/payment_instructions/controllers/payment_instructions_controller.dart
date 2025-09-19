// lib/app/modules/payment_instructions/controllers/payment_instructions_controller.dart

import 'dart:async';
import 'package:flutter/material.dart'; // Untuk Overlay
import 'package:get/get.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../data/models/payment_transaction_model.dart';
import '../../../../data/repositories/abstract/wallet_repository.dart';
import '../../../../routes/app_pages.dart';

class PaymentInstructionsController extends GetxController {

  // --- DEPENDENCIES ---
  final IWalletRepository _walletRepo = Get.find<IWalletRepository>();

  // --- STATE ---
  late final PaymentTransactionModel transaction;
  Timer? _timer;
  final RxString countdownText = "23:59:59".obs;
  final RxBool isCheckingStatus = false.obs;

  @override
  void onInit() {
    super.onInit();
    // 1. Ambil data transaksi dari halaman TopUp
    transaction = Get.arguments as PaymentTransactionModel;
    // 2. Mulai countdown (simulasi)
    _startCountdown();
  }

  @override
  void onClose() {
    _timer?.cancel(); // Wajib matikan timer
    super.onClose();
  }

  /// 2. Jalankan countdown palsu untuk expiry
  void _startCountdown() {
    // (Ini adalah simulasi UI, data expiry asli ada di transaction.expiryTime)
    Duration duration = const Duration(hours: 24);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      duration = duration - const Duration(seconds: 1);
      if (duration.isNegative) {
        timer.cancel();
        countdownText.value = "KEDALUWARSA";
      } else {
        countdownText.value = "${duration.inHours.toString().padLeft(2, '0')}:"
                            "${(duration.inMinutes % 60).toString().padLeft(2, '0')}:"
                            "${(duration.inSeconds % 60).toString().padLeft(2, '0')}";
      }
    });
  }

  /// 3. Aksi: Cek Status Pembayaran
  Future<void> checkPaymentStatus() async {
    isCheckingStatus.value = true;
    try {
      // Panggil repo (yang akan menambah saldo di fake DB)
      bool isSuccess = await _walletRepo.checkTopUpStatus(
        transaction.transactionId,
        transaction.amount,
      );
      
      if (isSuccess) {
        _timer?.cancel();
        // 4. Navigasi ke Halaman Sukses (Langkah berikutnya)
        Get.offNamed(
          Routes.PAYMENT_SUCCESS,
          arguments: transaction, // Kirim data transaksi agar halaman sukses tahu berapa yg di top up
        );
      } else {
        // (Fake repo kita tidak pernah fail, tapi kita siapkan)
        Get.snackbar("Info", "Pembayaran belum terdeteksi.");
      }

    } catch (e) {
      showTopSnackBar(
        Overlay.of(Get.context!),
        CustomSnackBar.error(message: "Error: $e"),
      );
    } finally {
      isCheckingStatus.value = false;
    }
  }

  /// 5. Aksi jika user membatalkan (kembali ke home)
  void cancelAndGoHome() {
    _timer?.cancel();
    Get.offAllNamed(Routes.MAIN_NAVIGATION); // Bersihkan stack
  }
}