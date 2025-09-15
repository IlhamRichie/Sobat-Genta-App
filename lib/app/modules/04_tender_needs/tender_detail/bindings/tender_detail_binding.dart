import 'package:get/get.dart';

import '../controllers/tender_detail_controller.dart';

class TenderDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TenderDetailController>(
      () => TenderDetailController(),
    );
  }
}
