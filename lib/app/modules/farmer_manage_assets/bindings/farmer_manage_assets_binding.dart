import 'package:get/get.dart';

import '../controllers/farmer_manage_assets_controller.dart';

class FarmerManageAssetsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FarmerManageAssetsController>(
      () => FarmerManageAssetsController(),
    );
  }
}
