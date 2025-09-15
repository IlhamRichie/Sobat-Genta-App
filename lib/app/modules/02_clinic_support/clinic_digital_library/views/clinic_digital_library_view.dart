import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/clinic_digital_library_controller.dart';

class ClinicDigitalLibraryView extends GetView<ClinicDigitalLibraryController> {
  const ClinicDigitalLibraryView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ClinicDigitalLibraryView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ClinicDigitalLibraryView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
