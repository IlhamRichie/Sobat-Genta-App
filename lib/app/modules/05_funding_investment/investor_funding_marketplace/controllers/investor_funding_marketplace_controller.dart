// lib/app/modules/investor_funding_marketplace/controllers/investor_funding_marketplace_controller.dart

import 'package:get/get.dart';

import '../../../../data/models/project_model.dart';
import '../../../../data/repositories/abstract/project_repository.dart';
import '../../../../routes/app_pages.dart';

class InvestorFundingMarketplaceController extends GetxController {

  // --- DEPENDENCIES ---
  final IProjectRepository _projectRepo = Get.find<IProjectRepository>();

  // --- STATE ---
  final RxBool isLoading = true.obs;
  final RxList<ProjectModel> projectList = <ProjectModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPublishedProjects();
  }

  /// Mengambil daftar proyek yang 'published'
  Future<void> fetchPublishedProjects() async {
    isLoading.value = true;
    
    try {
      final projects = await _projectRepo.getPublishedProjects();
      projectList.assignAll(projects);
    } catch (e) {
      Get.snackbar("Error", "Gagal mengambil data proyek: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Navigasi ke detail proyek (Langkah I5)
  void goToProjectDetail(ProjectModel project) {
    // Kita kirim ID-nya saja, agar halaman detail bisa
    // mengambil data yang paling fresh (termasuk progres pendanaan)
    Get.toNamed(Routes.INVESTOR_PROJECT_DETAIL, arguments: project.projectId);
  }
}