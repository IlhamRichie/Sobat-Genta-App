import 'package:get/get.dart';

import '../controllers/tender_marketplace_controller.dart';

class TenderMarketplaceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TenderMarketplaceController>(
      () => TenderMarketplaceController(),
    );
  }
}
