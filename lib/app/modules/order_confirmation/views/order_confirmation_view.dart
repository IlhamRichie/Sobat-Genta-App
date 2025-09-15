import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/order_confirmation_controller.dart';

class OrderConfirmationView extends GetView<OrderConfirmationController> {
  const OrderConfirmationView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OrderConfirmationView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'OrderConfirmationView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
