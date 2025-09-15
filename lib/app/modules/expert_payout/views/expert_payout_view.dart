import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/expert_payout_controller.dart';

class ExpertPayoutView extends GetView<ExpertPayoutController> {
  const ExpertPayoutView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ExpertPayoutView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ExpertPayoutView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
