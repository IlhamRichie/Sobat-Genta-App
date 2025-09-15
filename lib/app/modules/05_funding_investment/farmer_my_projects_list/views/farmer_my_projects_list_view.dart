import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/farmer_my_projects_list_controller.dart';

class FarmerMyProjectsListView extends GetView<FarmerMyProjectsListController> {
  const FarmerMyProjectsListView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FarmerMyProjectsListView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'FarmerMyProjectsListView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
