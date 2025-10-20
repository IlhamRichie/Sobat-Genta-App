// lib/app/modules/home_dashboard/controllers/home_dashboard_controller.dart

import 'package:get/get.dart';

import '../../../../data/models/user_model.dart';
import '../../../../routes/app_pages.dart';
import '../../../../services/session_service.dart';

class HomeDashboardController extends GetxController {
  
  // --- DEPENDENCIES ---
  final SessionService _sessionService = Get.find<SessionService>();
  
  // --- STATE ---
  late final String userName;
  final RxBool isLoading = true.obs;

  /// Getter untuk mengecek status KYC secara reaktif
  KycStatus get kycStatus => _sessionService.kycStatus;
  bool get isKycPending => _sessionService.kycStatus == KycStatus.PENDING_KYC;
  
  // --- DATA (Akan di-fetch) ---
  final RxString walletBalance = "Rp 0".obs;
  final RxInt landCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // Ambil nama user dari sesi
    userName = _sessionService.currentUser.value?.fullName ?? "SobatGenta";
    
    // Panggil method untuk fetch data dashboard
    fetchDashboardData();
  }

  /// Mengambil data untuk dashboard
  /// BEST PRACTICE: Bungkus dengan Future<void> agar bisa dipakai di RefreshIndicator
  Future<void> fetchDashboardData() async {
    isLoading.value = true;

    // --- CATATAN ARSITEKTUR ---
    // Saat ini kita gunakan data palsu.
    // Nanti, kita akan inject `IWalletRepository` dan `ILandRepository`
    // dan mengganti `Future.delayed` ini dengan panggilan API asli.
    
    // 1. Simulasi panggil API (Fake Repos)
    await Future.delayed(const Duration(seconds: 1));
    
    // 2. Set data palsu (sesuai Skenario Budi)
    walletBalance.value = "Rp 31.256.430";
    landCount.value = 2; // "Lahan Bawang Kejayaan" + 1 lahan lain

    isLoading.value = false;
  }

  // --- NAVIGATION METHODS ---
  // (Fungsi-fungsi ini akan dipanggil oleh tombol shortcut di View)

  void goToWallet() {
    Get.toNamed(Routes.WALLET_MAIN);
  }

  void goToWalletTopUp() {
    Get.toNamed(Routes.WALLET_TOP_UP);
  }

  void goToStore() {
    // Kita tidak pakai Get.toNamed, karena Toko sudah ada di
    // bottom nav. Kita hanya perlu pindah tab.
    // TODO: Implementasi pindah tab via MainNavigationController
    Get.toNamed(Routes.STORE_HOME); // Sementara
  }

  void goToClinic() {
    Get.toNamed(Routes.CLINIC_HOME); // Sementara
  }

  void goToTender() {
    Get.toNamed(Routes.TENDER_MARKETPLACE); // Sementara
  }
  
  void goToManageAssets() {
    Get.toNamed(Routes.FARMER_MANAGE_ASSETS);
  }

  void goToKycForm() {
    Get.toNamed(Routes.KYC_FORM);
  }
}