// lib/app/modules/investor_portfolio_detail/controllers/investor_portfolio_detail_controller.dart

import 'package:get/get.dart';

import '../../../../data/models/investment_model.dart';
import '../../../../data/models/project_update_model.dart';
import '../../../../data/repositories/abstract/project_repository.dart';

class InvestorPortfolioDetailController extends GetxController {

  // --- DEPENDENCIES ---
  final IProjectRepository _projectRepo = Get.find<IProjectRepository>();

  // --- STATE (STATIS DARI ARGUMEN) ---
  late final InvestmentModel investment; // Ini berisi info investasi & info proyek

  // --- STATE (DINAMIS DARI FETCH) ---
  final RxBool isLoadingUpdates = true.obs;
  final RxList<ProjectUpdateModel> updateList = <ProjectUpdateModel>[].obs;

  // Helper
  double get estimatedReturnAmount => 
      investment.amountInvested * (investment.project.roiEstimate / 100);

  @override
  void onInit() {
    super.onInit();
    // 1. Ambil data investasi LENGKAP dari argumen
    investment = Get.arguments as InvestmentModel;
    
    // 2. Ambil data timeline update (fetch baru)
    fetchProjectUpdates();
  }

  /// Mengambil data timeline progres dari repository
  Future<void> fetchProjectUpdates() async {
    isLoadingUpdates.value = true;
    try {
      final updates = await _projectRepo.getProjectUpdates(investment.project.projectId);
      updateList.assignAll(updates);
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat progres proyek: $e");
    } finally {
      isLoadingUpdates.value = false;
    }
  }
}