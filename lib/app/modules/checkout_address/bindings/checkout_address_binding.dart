import 'package:get/get.dart';

import '../controllers/checkout_address_controller.dart';

class CheckoutAddressBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CheckoutAddressController>(
      () => CheckoutAddressController(),
    );
  }
}
