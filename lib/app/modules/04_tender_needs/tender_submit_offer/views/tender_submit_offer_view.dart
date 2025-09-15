import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/tender_submit_offer_controller.dart';

class TenderSubmitOfferView extends GetView<TenderSubmitOfferController> {
  const TenderSubmitOfferView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TenderSubmitOfferView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'TenderSubmitOfferView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
