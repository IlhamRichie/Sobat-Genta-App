import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/payment_success_controller.dart';

class PaymentSuccessView extends GetView<PaymentSuccessController> {
  const PaymentSuccessView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PaymentSuccessView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'PaymentSuccessView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}