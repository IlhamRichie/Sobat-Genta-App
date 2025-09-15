import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/register_expert_controller.dart';

class RegisterExpertView extends GetView<RegisterExpertController> {
  const RegisterExpertView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RegisterExpertView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'RegisterExpertView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
