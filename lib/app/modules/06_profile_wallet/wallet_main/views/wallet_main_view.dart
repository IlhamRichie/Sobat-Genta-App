import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/wallet_main_controller.dart';

class WalletMainView extends GetView<WalletMainController> {
  const WalletMainView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WalletMainView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'WalletMainView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
