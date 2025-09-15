import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/checkout_payment_controller.dart';

class CheckoutPaymentView extends GetView<CheckoutPaymentController> {
  const CheckoutPaymentView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CheckoutPaymentView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'CheckoutPaymentView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
