import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/tender_detail_controller.dart';

class TenderDetailView extends GetView<TenderDetailController> {
  const TenderDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TenderDetailView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'TenderDetailView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
