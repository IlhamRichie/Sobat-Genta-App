import 'package:get/get.dart';

import '../controllers/expert_availability_settings_controller.dart';

class ExpertAvailabilitySettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExpertAvailabilitySettingsController>(
      () => ExpertAvailabilitySettingsController(),
    );
  }
}
