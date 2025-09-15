import 'package:get/get.dart';

import '../controllers/clinic_expert_profile_controller.dart';

class ClinicExpertProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClinicExpertProfileController>(
      () => ClinicExpertProfileController(),
    );
  }
}
