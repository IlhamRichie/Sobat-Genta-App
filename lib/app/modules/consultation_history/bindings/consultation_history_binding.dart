import 'package:get/get.dart';

import '../controllers/consultation_history_controller.dart';

class ConsultationHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConsultationHistoryController>(
      () => ConsultationHistoryController(),
    );
  }
}
