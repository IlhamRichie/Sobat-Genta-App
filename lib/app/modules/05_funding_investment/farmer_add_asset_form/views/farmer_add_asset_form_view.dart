import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/farmer_add_asset_form_controller.dart';

class FarmerAddAssetFormView extends GetView<FarmerAddAssetFormController> {
  const FarmerAddAssetFormView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FarmerAddAssetFormView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'FarmerAddAssetFormView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
