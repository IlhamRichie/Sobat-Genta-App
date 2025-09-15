import 'package:get/get.dart';

import '../controllers/clinic_ai_scan_controller.dart';

class ClinicAiScanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClinicAiScanController>(
      () => ClinicAiScanController(),
    );
  }
}
