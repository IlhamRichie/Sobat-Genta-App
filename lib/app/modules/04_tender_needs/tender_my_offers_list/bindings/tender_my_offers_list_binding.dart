import 'package:get/get.dart';

import '../controllers/tender_my_offers_list_controller.dart';

class TenderMyOffersListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TenderMyOffersListController>(
      () => TenderMyOffersListController(),
    );
  }
}
