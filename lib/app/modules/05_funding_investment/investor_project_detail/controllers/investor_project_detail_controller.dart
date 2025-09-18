// lib/app/modules/investor_project_detail/controllers/investor_project_detail_controller.dart

import 'package:get/get.dart';
import '../../../../data/models/project_model.dart';
import '../../../../data/repositories/abstract/project_repository.dart';
import '../../../../routes/app_pages.dart';

class InvestorProjectDetailController extends GetxController {
  
  // --- DEPENDENCIES ---
  final IProjectRepository _projectRepo = Get.find<IProjectRepository>();

  // --- STATE ---
  final RxBool isLoading = true.obs;
  final Rx<ProjectModel?> project = Rx<ProjectModel?>(null);
  
  late final String _projectId;

  @override
  void onInit() {
    super.onInit();
    // 1. Ambil ID dari navigasi
    _projectId = Get.arguments as String;
    // 2. Ambil data detail terbaru
    fetchProjectDetail();
  }

  /// Mengambil data detail
  Future<void> fetchProjectDetail() async {
    isLoading.value = true;
    try {
      final data = await _projectRepo.getProjectById(_projectId);
      project.value = data;
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat detail proyek: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Aksi "Danai Sekarang" (Langkah I6)
  void goToInvestForm() {
    if (project.value != null) {
      // Kirim seluruh objek proyek ke form investasi
      Get.toNamed(Routes.INVESTOR_INVEST_FORM, arguments: project.value);
    }
  }
}