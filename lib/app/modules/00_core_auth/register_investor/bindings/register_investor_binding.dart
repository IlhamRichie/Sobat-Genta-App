import 'package:get/get.dart';

import '../controllers/register_investor_controller.dart';

class RegisterInvestorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterInvestorController>(
      () => RegisterInvestorController(),
    );
  }
}
