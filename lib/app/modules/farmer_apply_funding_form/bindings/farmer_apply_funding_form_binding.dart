import 'package:get/get.dart';

import '../controllers/farmer_apply_funding_form_controller.dart';

class FarmerApplyFundingFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FarmerApplyFundingFormController>(
      () => FarmerApplyFundingFormController(),
    );
  }
}
