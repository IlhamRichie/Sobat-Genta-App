import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/wallet_history_controller.dart';

class WalletHistoryView extends GetView<WalletHistoryController> {
  const WalletHistoryView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WalletHistoryView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'WalletHistoryView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
