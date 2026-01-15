import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../data/models/pakar_profile_model.dart';
import '../../../../data/repositories/abstract/consultation_repository.dart';
import '../../../../routes/app_pages.dart';

class ClinicExpertProfileController extends GetxController {

  // --- DEPENDENCIES ---
  final IConsultationRepository _consultationRepo = Get.find<IConsultationRepository>();

  // --- STATE (STATIS DARI ARGUMEN) ---
  late final PakarProfileModel pakar;
  
  // --- STATE (TRANSAKSI) ---
  final RxBool isProcessingPayment = false.obs;

  @override
  void onInit() {
    super.onInit();
    pakar = Get.arguments as PakarProfileModel;
  }

  Future<void> startConsultation() async {
    if (!pakar.isAvailable) return;

    isProcessingPayment.value = true;
    
    try {
      // 1. Proses Transaksi
      final newConsultation = await _consultationRepo.createConsultationSession(
        pakar.pakarId,
        pakar.consultationFee,
      );

      // --- PERBAIKAN DI SINI (SUKSES) ---
      // Gunakan Get.overlayContext! agar Overlay ditemukan
      if (Get.overlayContext != null) {
        showTopSnackBar(
          Overlay.of(Get.overlayContext!), 
          CustomSnackBar.success(
            message: "Pembayaran berhasil! Menghubungkan ke ${pakar.user.fullName}...",
            backgroundColor: Colors.green.shade700,
          ),
        );
      }
      
      // 2. Navigasi ke Ruang Chat
      Get.offNamed(
        Routes.CONSULTATION_CHAT_ROOM,
        arguments: newConsultation,
      );
      
    } catch (e) {
      String errorMessage = e.toString().replaceAll("Exception: ", "");
      
      // --- PERBAIKAN DI SINI (ERROR) ---
      // Ini juga harus diganti biar kalau error gak bikin crash aplikasi
      if (Get.overlayContext != null) {
        showTopSnackBar(
          Overlay.of(Get.overlayContext!),
          CustomSnackBar.error(message: errorMessage),
        );
      } else {
        // Fallback kalau overlay tetap gak ketemu (jarang terjadi)
        Get.snackbar("Error", errorMessage, backgroundColor: Colors.red, colorText: Colors.white);
      }
      
      if (errorMessage.contains("Saldo Dompet tidak cukup")) {
        await Future.delayed(const Duration(seconds: 1));
        Get.toNamed(Routes.WALLET_TOP_UP);
      }
      
    } finally {
      isProcessingPayment.value = false;
    }
  }
  
  void showNotAvailableDialog() {
    Get.defaultDialog(
      title: "Pakar Sedang Offline",
      middleText: "${pakar.user.fullName} sedang tidak tersedia. Silakan cek jadwal praktiknya atau cari pakar lain yang sedang online.",
      textConfirm: "OK",
      confirmTextColor: Colors.white,
      onConfirm: () => Get.back(),
    );
  }
}