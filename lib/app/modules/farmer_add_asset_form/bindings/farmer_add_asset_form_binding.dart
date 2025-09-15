import 'package:get/get.dart';

import '../controllers/farmer_add_asset_form_controller.dart';

class FarmerAddAssetFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FarmerAddAssetFormController>(
      () => FarmerAddAssetFormController(),
    );
  }
}
