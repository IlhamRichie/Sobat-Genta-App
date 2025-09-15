import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/order_tracking_detail_controller.dart';

class OrderTrackingDetailView extends GetView<OrderTrackingDetailController> {
  const OrderTrackingDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OrderTrackingDetailView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'OrderTrackingDetailView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
