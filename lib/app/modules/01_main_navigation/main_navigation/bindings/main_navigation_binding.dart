import 'package:get/get.dart';

// Import semua controller yang akan Anda gunakan di dalam MainNavigation
import '../../../02_clinic_support/clinic_home/controllers/clinic_home_controller.dart';
import '../../../02_clinic_support/expert_dashboard/controllers/expert_dashboard_controller.dart';
import '../../../03_store_ecommerce/store_home/controllers/store_home_controller.dart';
import '../../../04_tender_needs/tender_marketplace/controllers/tender_marketplace_controller.dart';
import '../../../05_funding_investment/investor_funding_marketplace/controllers/investor_funding_marketplace_controller.dart';
import '../../../05_funding_investment/investor_portfolio/controllers/investor_portfolio_controller.dart';
import '../../../06_profile_wallet/profile_main/controllers/profile_main_controller.dart';
import '../../../consultation_history/controllers/consultation_history_controller.dart';
import '../../home_dashboard/controllers/home_dashboard_controller.dart';
import '../controllers/main_navigation_controller.dart';

class MainNavigationBinding extends Bindings {
  @override
  void dependencies() {
    // 1. Controller Utama (Induk)
    Get.lazyPut<MainNavigationController>(
      () => MainNavigationController(),
    );

    // --- 2. SEMUA Controller Anak (untuk Tabs) ---
    
    // Tab yang digunakan oleh Petani (Role: Farmer) [cite: 92]
    Get.lazyPut<HomeDashboardController>(
      () => HomeDashboardController(),
    );
    
    // Tab yang digunakan oleh Petani & Investor (Role: Farmer, Investor) [cite: 92, 130]
    Get.lazyPut<ClinicHomeController>(
      () => ClinicHomeController(),
    );
    Get.lazyPut<StoreHomeController>(
      () => StoreHomeController(),
    );
    Get.lazyPut<TenderMarketplaceController>(
      () => TenderMarketplaceController(),
    );
    
    // Tab yang digunakan oleh Investor (Role: Investor) [cite: 130]
    Get.lazyPut<InvestorFundingMarketplaceController>(
      () => InvestorFundingMarketplaceController(),
    );
    Get.lazyPut<InvestorPortfolioController>(
      () => InvestorPortfolioController(),
    );

    // Tab yang digunakan oleh Pakar (Role: Expert) [cite: 156]
    Get.lazyPut<ExpertDashboardController>(
      () => ExpertDashboardController(),
    );
    // (Tambahkan controller untuk 'Daftar Konsultasi' Pakar di sini jika sudah ada)
    
    // Tab yang digunakan oleh SEMUA Peran
    Get.lazyPut<ProfileMainController>(
      () => ProfileMainController(),
    );

    Get.lazyPut<ConsultationHistoryController>( // <-- TAMBAHKAN INI
      () => ConsultationHistoryController(),
    ); 
  }
}