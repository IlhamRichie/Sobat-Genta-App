import 'package:get/get.dart';

import '../controllers/register_role_chooser_controller.dart';

class RegisterRoleChooserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterRoleChooserController>(
      () => RegisterRoleChooserController(),
    );
  }
}
