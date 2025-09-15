import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/profile_main_controller.dart';

class ProfileMainView extends GetView<ProfileMainController> {
  const ProfileMainView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ProfileMainView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ProfileMainView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
