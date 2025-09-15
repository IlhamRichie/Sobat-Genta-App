import 'package:get/get.dart';

import '../controllers/register_farmer_controller.dart';

class RegisterFarmerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterFarmerController>(
      () => RegisterFarmerController(),
    );
  }
}
