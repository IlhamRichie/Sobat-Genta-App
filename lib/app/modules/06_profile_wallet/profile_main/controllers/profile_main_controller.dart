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

  /// Aksi Utama: Logout (DIPERBAIKI)
  /// Fungsi ini HANYA memanggil service logout. Konfirmasi dialog
  /// dilakukan di View untuk kontrol tampilan yang lebih baik.
  void logout() {
    sessionService.logoutUser();
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