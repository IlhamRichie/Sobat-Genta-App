import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/checkout_address_controller.dart';

class CheckoutAddressView extends GetView<CheckoutAddressController> {
  const CheckoutAddressView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CheckoutAddressView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'CheckoutAddressView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
