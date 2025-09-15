import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/expert_availability_settings_controller.dart';

class ExpertAvailabilitySettingsView
    extends GetView<ExpertAvailabilitySettingsController> {
  const ExpertAvailabilitySettingsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ExpertAvailabilitySettingsView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ExpertAvailabilitySettingsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
