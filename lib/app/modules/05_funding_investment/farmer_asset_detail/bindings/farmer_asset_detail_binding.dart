import 'package:get/get.dart';

import '../controllers/farmer_asset_detail_controller.dart';

class FarmerAssetDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FarmerAssetDetailController>(
      () => FarmerAssetDetailController(),
    );
  }
}
