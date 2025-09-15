import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/register_investor_controller.dart';

class RegisterInvestorView extends GetView<RegisterInvestorController> {
  const RegisterInvestorView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RegisterInvestorView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'RegisterInvestorView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
