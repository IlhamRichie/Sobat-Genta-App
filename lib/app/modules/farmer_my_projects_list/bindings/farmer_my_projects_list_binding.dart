import 'package:get/get.dart';

import '../controllers/farmer_my_projects_list_controller.dart';

class FarmerMyProjectsListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FarmerMyProjectsListController>(
      () => FarmerMyProjectsListController(),
    );
  }
}
