import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/otp_verification_controller.dart';

class OtpVerificationView extends GetView<OtpVerificationController> {
  const OtpVerificationView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OtpVerificationView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'OtpVerificationView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
