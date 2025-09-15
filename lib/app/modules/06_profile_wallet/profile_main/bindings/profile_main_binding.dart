import 'package:get/get.dart';

import '../controllers/profile_main_controller.dart';

class ProfileMainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileMainController>(
      () => ProfileMainController(),
    );
  }
}
