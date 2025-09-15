import 'package:get/get.dart';

import '../controllers/expert_dashboard_controller.dart';

class ExpertDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExpertDashboardController>(
      () => ExpertDashboardController(),
    );
  }
}
