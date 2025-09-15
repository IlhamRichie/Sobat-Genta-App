import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/clinic_library_reader_controller.dart';

class ClinicLibraryReaderView extends GetView<ClinicLibraryReaderController> {
  const ClinicLibraryReaderView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ClinicLibraryReaderView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ClinicLibraryReaderView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
