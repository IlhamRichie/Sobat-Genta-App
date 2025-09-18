import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/payment_instructions_controller.dart';

class PaymentInstructionsView extends GetView<PaymentInstructionsController> {
  const PaymentInstructionsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PaymentInstructionsView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'PaymentInstructionsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}