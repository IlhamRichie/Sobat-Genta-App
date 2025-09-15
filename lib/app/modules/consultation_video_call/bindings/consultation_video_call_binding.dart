import 'package:get/get.dart';

import '../controllers/consultation_video_call_controller.dart';

class ConsultationVideoCallBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConsultationVideoCallController>(
      () => ConsultationVideoCallController(),
    );
  }
}
