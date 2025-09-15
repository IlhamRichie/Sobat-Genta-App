import 'package:get/get.dart';

import '../controllers/expert_payout_controller.dart';

class ExpertPayoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExpertPayoutController>(
      () => ExpertPayoutController(),
    );
  }
}
