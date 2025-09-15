import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/clinic_ai_scan_controller.dart';

class ClinicAiScanView extends GetView<ClinicAiScanController> {
  const ClinicAiScanView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ClinicAiScanView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ClinicAiScanView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
