// lib/app/modules/wallet_top_up/controllers/wallet_top_up_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../data/repositories/abstract/wallet_repository.dart';
import '../../../../routes/app_pages.dart';

class WalletTopUpController extends GetxController {

  // --- DEPENDENCIES ---
  final IWalletRepository _walletRepo = Get.find<IWalletRepository>();

  // --- STATE ---
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController amountC = TextEditingController();
  final RxBool isLoading = false.obs;

  // Nilai minimal Top Up
  final double minTopUp = 10000.0;

  @override
  void onClose() {
    amountC.dispose();
    super.onClose();
  }

  /// Set jumlah dari chip cepat
  void setAmountFromChip(double amount) {
    amountC.text = amount.toStringAsFixed(0);
  }

  /// Aksi utama: Memulai transaksi Top Up
  Future<void> submitTopUpRequest() async {
    if (!formKey.currentState!.validate()) return;
    
    final double amount = double.tryParse(amountC.text) ?? 0.0;

    // Validasi tambahan
    if (amount < minTopUp) {
      Get.snackbar("Jumlah Tidak Valid", "Minimum top up adalah Rp 10.000.");
      return;
    }

    isLoading.value = true;
    try {
      // 1. Panggil Repo untuk membuat transaksi
      final transactionDetails = await _walletRepo.requestTopUp(amount);

      // 2. Navigasi ke Halaman Instruksi
      // (Kita gunakan 'offNamed' untuk MENGGANTI halaman form ini,
      // agar user tidak bisa 'back' dan submit form yang sama dua kali)
      Get.offNamed(
        Routes.PAYMENT_INSTRUCTIONS, 
        arguments: transactionDetails, // Kirim data VA/QRIS ke halaman berikutnya
      );
      
    } catch (e) {
      showTopSnackBar(
        Overlay.of(Get.context!),
        CustomSnackBar.error(message: "Gagal membuat transaksi: $e"),
      );
    } finally {
      isLoading.value = false;
    }
  }
}