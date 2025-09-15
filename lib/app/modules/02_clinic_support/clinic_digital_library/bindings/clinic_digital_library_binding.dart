import 'package:get/get.dart';

import '../controllers/clinic_digital_library_controller.dart';

class ClinicDigitalLibraryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClinicDigitalLibraryController>(
      () => ClinicDigitalLibraryController(),
    );
  }
}
