import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/tender_my_offers_list_controller.dart';

class TenderMyOffersListView extends GetView<TenderMyOffersListController> {
  const TenderMyOffersListView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TenderMyOffersListView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'TenderMyOffersListView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
