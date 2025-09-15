import 'package:get/get.dart';

import '../controllers/store_home_controller.dart';

class StoreHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StoreHomeController>(
      () => StoreHomeController(),
    );
  }
}
