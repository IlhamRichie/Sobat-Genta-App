import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/tender_marketplace_controller.dart';

class TenderMarketplaceView extends GetView<TenderMarketplaceController> {
  const TenderMarketplaceView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TenderMarketplaceView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'TenderMarketplaceView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
