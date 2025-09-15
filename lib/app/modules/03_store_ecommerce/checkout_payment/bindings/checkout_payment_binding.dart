import 'package:get/get.dart';

import '../controllers/checkout_payment_controller.dart';

class CheckoutPaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CheckoutPaymentController>(
      () => CheckoutPaymentController(),
    );
  }
}
