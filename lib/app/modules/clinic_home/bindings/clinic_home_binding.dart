import 'package:get/get.dart';

import '../controllers/clinic_home_controller.dart';

class ClinicHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClinicHomeController>(
      () => ClinicHomeController(),
    );
  }
}
