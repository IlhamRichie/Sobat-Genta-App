import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/farmer_apply_funding_form_controller.dart';

class FarmerApplyFundingFormView
    extends GetView<FarmerApplyFundingFormController> {
  const FarmerApplyFundingFormView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FarmerApplyFundingFormView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'FarmerApplyFundingFormView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
