import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/tender_create_request_controller.dart';

class TenderCreateRequestView extends GetView<TenderCreateRequestController> {
  const TenderCreateRequestView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TenderCreateRequestView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'TenderCreateRequestView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
