import 'package:get/get.dart';

import '../controllers/payment_instructions_controller.dart';

class PaymentInstructionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentInstructionsController>(
      () => PaymentInstructionsController(),
    );
  }
}
