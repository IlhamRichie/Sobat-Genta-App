import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/investor_portfolio_detail_controller.dart';

class InvestorPortfolioDetailView
    extends GetView<InvestorPortfolioDetailController> {
  const InvestorPortfolioDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('InvestorPortfolioDetailView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'InvestorPortfolioDetailView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
