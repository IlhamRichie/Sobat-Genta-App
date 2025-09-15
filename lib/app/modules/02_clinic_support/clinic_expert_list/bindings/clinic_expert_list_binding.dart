import 'package:get/get.dart';

import '../controllers/clinic_expert_list_controller.dart';

class ClinicExpertListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClinicExpertListController>(
      () => ClinicExpertListController(),
    );
  }
}
