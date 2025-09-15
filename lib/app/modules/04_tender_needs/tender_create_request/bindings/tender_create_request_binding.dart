import 'package:get/get.dart';

import '../controllers/tender_create_request_controller.dart';

class TenderCreateRequestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TenderCreateRequestController>(
      () => TenderCreateRequestController(),
    );
  }
}
