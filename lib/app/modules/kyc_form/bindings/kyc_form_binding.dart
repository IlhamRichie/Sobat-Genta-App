import 'package:get/get.dart';

import '../controllers/kyc_form_controller.dart';

class KycFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KycFormController>(
      () => KycFormController(),
    );
  }
}
