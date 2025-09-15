import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/consultation_chat_room_controller.dart';

class ConsultationChatRoomView extends GetView<ConsultationChatRoomController> {
  const ConsultationChatRoomView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ConsultationChatRoomView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ConsultationChatRoomView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
