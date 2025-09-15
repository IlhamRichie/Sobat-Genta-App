import 'package:get/get.dart';

import '../controllers/investor_funding_marketplace_controller.dart';

class InvestorFundingMarketplaceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InvestorFundingMarketplaceController>(
      () => InvestorFundingMarketplaceController(),
    );
  }
}
