import 'package:get/get.dart';

import '../controllers/register_expert_controller.dart';

class RegisterExpertBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterExpertController>(
      () => RegisterExpertController(),
    );
  }
}
