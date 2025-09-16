import 'package:get/get.dart';

// Import semua controller yang akan Anda gunakan di dalam MainNavigation
import '../../../02_clinic_support/clinic_home/controllers/clinic_home_controller.dart';
import '../../../03_store_ecommerce/store_home/controllers/store_home_controller.dart';
import '../../../04_tender_needs/tender_marketplace/controllers/tender_marketplace_controller.dart';
import '../../../06_profile_wallet/profile_main/controllers/profile_main_controller.dart';
import '../../home_dashboard/controllers/home_dashboard_controller.dart';
import '../controllers/main_navigation_controller.dart';

class MainNavigationBinding extends Bindings {
  @override
  void dependencies() {
    // 1. Controller untuk Shell/Induk (permanent: true)
    Get.lazyPut(() => MainNavigationController());

    // 2. Controller untuk 5 Tab (agar siap saat dibutuhkan)
    Get.lazyPut(() => HomeDashboardController());
    Get.lazyPut(() => ClinicHomeController());
    Get.lazyPut(() => StoreHomeController());
    Get.lazyPut(() => TenderMarketplaceController());
    Get.lazyPut(() => ProfileMainController());
  }
}