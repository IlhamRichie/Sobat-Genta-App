import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/register_role_chooser_controller.dart';

class RegisterRoleChooserView extends GetView<RegisterRoleChooserController> {
  const RegisterRoleChooserView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RegisterRoleChooserView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'RegisterRoleChooserView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
