import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/consultation_video_call_controller.dart';

class ConsultationVideoCallView
    extends GetView<ConsultationVideoCallController> {
  const ConsultationVideoCallView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ConsultationVideoCallView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ConsultationVideoCallView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
