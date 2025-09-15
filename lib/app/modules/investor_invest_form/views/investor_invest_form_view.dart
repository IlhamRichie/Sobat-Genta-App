import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/investor_invest_form_controller.dart';

class InvestorInvestFormView extends GetView<InvestorInvestFormController> {
  const InvestorInvestFormView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('InvestorInvestFormView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'InvestorInvestFormView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
