import 'package:get/get.dart';

import '../controllers/investor_portfolio_controller.dart';

class InvestorPortfolioBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InvestorPortfolioController>(
      () => InvestorPortfolioController(),
    );
  }
}
