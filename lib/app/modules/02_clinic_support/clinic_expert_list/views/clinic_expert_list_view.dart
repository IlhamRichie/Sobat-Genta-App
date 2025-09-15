import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/clinic_expert_list_controller.dart';

class ClinicExpertListView extends GetView<ClinicExpertListController> {
  const ClinicExpertListView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ClinicExpertListView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ClinicExpertListView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
