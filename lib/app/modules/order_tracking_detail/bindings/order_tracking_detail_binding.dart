import 'package:get/get.dart';

import '../controllers/order_tracking_detail_controller.dart';

class OrderTrackingDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderTrackingDetailController>(
      () => OrderTrackingDetailController(),
    );
  }
}
