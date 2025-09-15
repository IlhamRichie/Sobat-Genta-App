import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/store_home_controller.dart';

class StoreHomeView extends GetView<StoreHomeController> {
  const StoreHomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StoreHomeView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'StoreHomeView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
