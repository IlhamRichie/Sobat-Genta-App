import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/investor_funding_marketplace_controller.dart';

class InvestorFundingMarketplaceView
    extends GetView<InvestorFundingMarketplaceController> {
  const InvestorFundingMarketplaceView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('InvestorFundingMarketplaceView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'InvestorFundingMarketplaceView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
