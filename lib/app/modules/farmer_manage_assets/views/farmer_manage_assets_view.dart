import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/farmer_manage_assets_controller.dart';

class FarmerManageAssetsView extends GetView<FarmerManageAssetsController> {
  const FarmerManageAssetsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FarmerManageAssetsView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'FarmerManageAssetsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
