import 'package:get/get.dart';

import '../controllers/investor_portfolio_detail_controller.dart';

class InvestorPortfolioDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InvestorPortfolioDetailController>(
      () => InvestorPortfolioDetailController(),
    );
  }
}
