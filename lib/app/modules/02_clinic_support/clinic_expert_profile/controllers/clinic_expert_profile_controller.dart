// lib/app/modules/clinic_expert_profile/controllers/clinic_expert_profile_controller.dart

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
    // Ambil data pakar lengkap dari halaman list
    pakar = Get.arguments as PakarProfileModel;
  }

  /// Aksi utama: Memulai Konsultasi (Bayar & Masuk Ruangan)
  /// (Langkah I5 & I6 Skenario 3)
  Future<void> startConsultation() async {
    if (!pakar.isAvailable) return; // Pengaman ganda

    isProcessingPayment.value = true;
    
    try {
      // 1. Panggil repo transaksi
      // Repo ini akan (secara palsu) cek dompet, mendebit, dan membuat sesi
      final newConsultation = await _consultationRepo.createConsultationSession(
        pakar.pakarId,
        pakar.consultationFee,
      );

      showTopSnackBar(
        Overlay.of(Get.context!),
        CustomSnackBar.success(
          message: "Pembayaran berhasil! Menghubungkan ke ${pakar.user.fullName}...",
          backgroundColor: Colors.green.shade700,
        ),
      );
      
      // 2. NAVIGASI KE RUANG CHAT (Flow C)
      // Kita gunakan offNamed agar user tidak bisa 'back' ke profil
      Get.offNamed(
        Routes.CONSULTATION_CHAT_ROOM,
        arguments: newConsultation, // Kirim data sesi yang baru dibuat
      );
      
    } catch (e) {
      String errorMessage = e.toString().replaceAll("Exception: ", "");
      
      showTopSnackBar(
        Overlay.of(Get.context!),
        CustomSnackBar.error(message: errorMessage),
      );
      
      // ARSITEKTUR PENTING: Jika error-nya karena saldo, arahkan ke Top Up
      if (errorMessage.contains("Saldo Dompet tidak cukup")) {
        await Future.delayed(const Duration(seconds: 1));
        Get.toNamed(Routes.WALLET_TOP_UP); // Navigasi ke top up
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