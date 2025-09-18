// lib/app/modules/farmer_my_projects_list/controllers/farmer_my_projects_list_controller.dart

import 'package:get/get.dart';

import '../../../../data/models/project_model.dart';
import '../../../../data/repositories/abstract/project_repository.dart';
import '../../../../routes/app_pages.dart';

class FarmerMyProjectsListController extends GetxController {

  // --- DEPENDENCIES ---
  final IProjectRepository _projectRepo = Get.find<IProjectRepository>();

  // --- STATE ---
  final RxBool isLoading = true.obs;
  final RxList<ProjectModel> projectList = <ProjectModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchMyProjects();
  }

  /// Mengambil daftar proyek dari repository
  Future<void> fetchMyProjects() async {
    isLoading.value = true;
    
    try {
      final projects = await _projectRepo.getMyProjects();
      projectList.assignAll(projects);
    } catch (e) {
      Get.snackbar("Error", "Gagal mengambil data proyek: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Navigasi ke detail proyek
  void goToProjectDetail(ProjectModel project) {
    // KITA BELUM BUAT HALAMAN INI
    // Kita akan gunakan halaman INVESTOR_PROJECT_DETAIL nanti (reusable)
    Get.toNamed(Routes.INVESTOR_PROJECT_DETAIL, arguments: project.projectId);
  }
}