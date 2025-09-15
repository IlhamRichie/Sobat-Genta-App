import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/register_farmer_controller.dart';

class RegisterFarmerView extends GetView<RegisterFarmerController> {
  const RegisterFarmerView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RegisterFarmerView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'RegisterFarmerView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
