import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/farmer_asset_detail_controller.dart';

class FarmerAssetDetailView extends GetView<FarmerAssetDetailController> {
  const FarmerAssetDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FarmerAssetDetailView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'FarmerAssetDetailView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
