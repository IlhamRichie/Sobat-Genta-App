import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/main_navigation_controller.dart';

class MainNavigationView extends GetView<MainNavigationController> {
  const MainNavigationView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MainNavigationView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'MainNavigationView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
