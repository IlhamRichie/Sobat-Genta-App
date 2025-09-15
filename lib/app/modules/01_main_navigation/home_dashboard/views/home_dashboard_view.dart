import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_dashboard_controller.dart';

class HomeDashboardView extends GetView<HomeDashboardController> {
  const HomeDashboardView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeDashboardView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'HomeDashboardView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
