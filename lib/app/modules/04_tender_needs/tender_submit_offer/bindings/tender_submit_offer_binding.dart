import 'package:get/get.dart';

import '../controllers/tender_submit_offer_controller.dart';

class TenderSubmitOfferBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TenderSubmitOfferController>(
      () => TenderSubmitOfferController(),
    );
  }
}
