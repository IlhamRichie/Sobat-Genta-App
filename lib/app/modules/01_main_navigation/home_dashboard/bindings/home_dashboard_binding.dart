import 'package:get/get.dart';

import '../controllers/home_dashboard_controller.dart';

class HomeDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeDashboardController>(
      () => HomeDashboardController(),
    );
  }
}
