import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/clinic_home_controller.dart';

class ClinicHomeView extends GetView<ClinicHomeController> {
  const ClinicHomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ClinicHomeView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ClinicHomeView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
