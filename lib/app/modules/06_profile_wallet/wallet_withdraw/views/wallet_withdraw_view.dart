import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/wallet_withdraw_controller.dart';

class WalletWithdrawView extends GetView<WalletWithdrawController> {
  const WalletWithdrawView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WalletWithdrawView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'WalletWithdrawView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
