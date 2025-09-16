import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../../../data/models/expert_model.dart';
import '../../../../routes/app_pages.dart';
import '../../../01_main_navigation/main_navigation/controllers/main_navigation_controller.dart';

class ClinicExpertProfileController extends GetxController {
  
  // --- State Dependencies ---
  late MainNavigationController mainNavController;
  late ExpertModel expertData;

  @override
  void onInit() {
    super.onInit();
    // 1. Tangkap data ExpertModel yang dikirim dari halaman list
    expertData = Get.arguments as ExpertModel;
    
    // 2. Temukan controller induk untuk cek status KYC
    mainNavController = Get.find<MainNavigationController>();
  }

  // --- Aksi Tombol CTA (Call to Action) ---
  void startConsultation(BuildContext context) {
    // Cek status KYC dari Main Controller
    if (mainNavController.kycStatus.value == UserKycStatus.verified) {
      
      // [PERBAIKAN] JANGAN LANGSUNG KE CHAT
      // Get.toNamed(Routes.CONSULTATION_CHAT_ROOM, arguments: expertData);

      // [YANG BENAR] Arahkan ke Halaman Ringkasan Pembayaran
      Get.toNamed(
        Routes.PAYMENT_SUMMARY, // <-- Rute BARU yang akan kita buat
        arguments: expertData, // Kirim data pakar ke halaman checkout
      );

    } else {
      // Jika TERKUNCI: Tampilkan Snackbar Informatif (ini sudah benar)
      _showKycSnackbar(context);
    }
  }

  // Helper Snackbar (Sesuai permintaan Anda)
  void _showKycSnackbar(BuildContext context) {
    // Cek status KYC dari controller induk
    final kycStatus = mainNavController.kycStatus.value;
    
    String message = "Fitur terkunci. Harap lengkapi verifikasi KYC Anda untuk memulai konsultasi.";

    // [LOGIC BARU] Sesuaikan pesan snackbar
    if (kycStatus == UserKycStatus.inReview) {
      message = "Fitur terkunci. Data KYC Anda sedang ditinjau. Harap tunggu persetujuan Admin.";
    }

    showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.error(
        message: message,
      ),
      displayDuration: 2.seconds,
    );
  }
}