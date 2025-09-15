import 'package:get/get.dart';

import '../controllers/investor_project_detail_controller.dart';

class InvestorProjectDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InvestorProjectDetailController>(
      () => InvestorProjectDetailController(),
    );
  }
}
