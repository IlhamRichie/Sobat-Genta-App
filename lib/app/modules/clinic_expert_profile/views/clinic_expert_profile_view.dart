import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/clinic_expert_profile_controller.dart';

class ClinicExpertProfileView extends GetView<ClinicExpertProfileController> {
  const ClinicExpertProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ClinicExpertProfileView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ClinicExpertProfileView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
