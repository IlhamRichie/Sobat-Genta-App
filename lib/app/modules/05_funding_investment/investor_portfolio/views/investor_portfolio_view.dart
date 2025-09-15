import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/investor_portfolio_controller.dart';

class InvestorPortfolioView extends GetView<InvestorPortfolioController> {
  const InvestorPortfolioView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('InvestorPortfolioView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'InvestorPortfolioView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
