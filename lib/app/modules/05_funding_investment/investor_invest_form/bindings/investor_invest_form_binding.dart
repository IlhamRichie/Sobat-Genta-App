import 'package:get/get.dart';

import '../controllers/investor_invest_form_controller.dart';

class InvestorInvestFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InvestorInvestFormController>(
      () => InvestorInvestFormController(),
    );
  }
}
