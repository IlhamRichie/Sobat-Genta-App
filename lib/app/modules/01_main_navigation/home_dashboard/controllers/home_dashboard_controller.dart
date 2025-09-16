import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../../00_core_auth/register_role_chooser/controllers/register_role_chooser_controller.dart';
import '../../main_navigation/controllers/main_navigation_controller.dart';

// (Kita akan dapatkan UserRole dari AuthService nanti,
//  untuk saat ini kita gunakan enum dari role_chooser)

class HomeDashboardController extends GetxController {
  
  // Best Practice: Temukan controller induk (MainNavigation)
  // untuk mendapatkan state global aplikasi (seperti status KYC)
  late MainNavigationController mainNavController;

  // --- (SIMULASI DATA PENGGUNA) ---
  // (Nanti, data ini akan diambil dari AuthService/UserService)
  final RxString userName = "Budi Santoso".obs;
  final RxString userRoleName = "Petani".obs;
  final Rx<UserRole> userRole = UserRole.farmer.obs; 
  // ---------------------------------

  @override
  void onInit() {
    super.onInit();
    // Temukan controller yang sudah 'hidup'
    mainNavController = Get.find<MainNavigationController>();
  }

  // Aksi yang dipanggil jika pengguna mengklik fitur yang terkunci
  void showKycSnackbar(BuildContext context) {
    // Cek status KYC dari controller induk
    final kycStatus = mainNavController.kycStatus.value;

    String message = "Fitur terkunci. Harap lengkapi verifikasi KYC Anda.";

    // [LOGIC BARU] Sesuaikan pesan snackbar
    if (kycStatus == UserKycStatus.inReview) {
      message = "Fitur terkunci. Data KYC Anda sedang ditinjau oleh Admin.";
    }

    showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.error(
        message: message,
      ),
      displayDuration: 2.seconds,
    );
  }


  // --- Navigasi Aksi Cepat ---
  // (Nanti, ini akan pindah ke tab yang sesuai)
  void goToFundingMarketplace() {
    mainNavController.onItemTapped(4); // Pindah ke Tab Profil (Contoh)
  }
  void goToClinic() {
    mainNavController.onItemTapped(1); // Pindah ke Tab Klinik
  }
  void goToStore() {
    mainNavController.onItemTapped(2); // Pindah ke Tab Toko
  }
}