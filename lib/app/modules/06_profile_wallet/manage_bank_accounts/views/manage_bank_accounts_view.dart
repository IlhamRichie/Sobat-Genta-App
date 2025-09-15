import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/manage_bank_accounts_controller.dart';

class ManageBankAccountsView extends GetView<ManageBankAccountsController> {
  const ManageBankAccountsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ManageBankAccountsView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ManageBankAccountsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
