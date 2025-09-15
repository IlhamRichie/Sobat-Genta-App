import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/expert_dashboard_controller.dart';

class ExpertDashboardView extends GetView<ExpertDashboardController> {
  const ExpertDashboardView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ExpertDashboardView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ExpertDashboardView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
