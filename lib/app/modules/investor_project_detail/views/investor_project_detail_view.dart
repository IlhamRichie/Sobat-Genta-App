import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/investor_project_detail_controller.dart';

class InvestorProjectDetailView
    extends GetView<InvestorProjectDetailController> {
  const InvestorProjectDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('InvestorProjectDetailView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'InvestorProjectDetailView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
