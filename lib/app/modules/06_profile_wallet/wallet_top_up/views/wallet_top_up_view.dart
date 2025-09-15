import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/wallet_top_up_controller.dart';

class WalletTopUpView extends GetView<WalletTopUpController> {
  const WalletTopUpView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WalletTopUpView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'WalletTopUpView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
