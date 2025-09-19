// lib/app/modules/profile_main/controllers/profile_main_controller.dart

import 'package:get/get.dart';

import '../../../../data/models/user_model.dart';
import '../../../../routes/app_pages.dart';
import '../../../../services/session_service.dart';

class ProfileMainController extends GetxController {

  // --- DEPENDENSI KE SERVICE GLOBAL ---
  final SessionService sessionService = Get.find<SessionService>();

  // --- DATA PENGGUNA (Langsung dari Service) ---
  User? get currentUser => sessionService.currentUser.value;
  UserRole get userRole => sessionService.userRole;

  /// Aksi Utama: Logout (Delegasikan ke Service)
  void logout() {
    Get.defaultDialog(
      title: "Konfirmasi Logout",
      middleText: "Anda yakin ingin keluar dari akun Anda?",
      textConfirm: "Ya, Logout",
      textCancel: "Batal",
      onConfirm: () {
        Get.back(); // Tutup dialog
        sessionService.logoutUser(); // Panggil logika logout terpusat
      },
    );
  }

  // --- NAVIGASI (Helper untuk menu dinamis) ---
  
  // Alur Petani
  void goToManageAssets() => Get.toNamed(Routes.FARMER_MANAGE_ASSETS);
  
  // Alur Investor
  void goToPortfolio() => Get.toNamed(Routes.INVESTOR_PORTFOLIO);
  
  // Alur Petani/Investor (Toko)
  void goToOrderHistory() => Get.toNamed(Routes.ORDER_HISTORY);

  // Alur Pakar/Investor (Dompet/Bank)
  void goToPayout() => Get.toNamed(Routes.EXPERT_PAYOUT);
  void goToWallet() => Get.toNamed(Routes.WALLET_MAIN); // (Ini belum kita buat, tapi kita siapkan)
  void goToBankAccounts() => Get.toNamed(Routes.MANAGE_BANK_ACCOUNTS);
  
  // Alur Pakar
  void goToAvailability() => Get.toNamed(Routes.EXPERT_AVAILABILITY_SETTINGS);
  
  // Alur Umum
  void goToChangePassword() => Get.toNamed(Routes.CHANGE_PASSWORD);
}