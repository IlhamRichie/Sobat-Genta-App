import 'package:get/get.dart';

import '../controllers/consultation_chat_room_controller.dart';

class ConsultationChatRoomBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConsultationChatRoomController>(
      () => ConsultationChatRoomController(),
    );
  }
}
