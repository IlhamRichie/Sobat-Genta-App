import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/kyc_form_controller.dart';

class KycFormView extends GetView<KycFormController> {
  const KycFormView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KycFormView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'KycFormView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
