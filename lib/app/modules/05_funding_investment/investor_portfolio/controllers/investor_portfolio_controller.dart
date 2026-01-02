// lib/app/modules/investor_portfolio/controllers/investor_portfolio_controller.dart

import 'package:get/get.dart';

import '../../../../data/models/investment_model.dart';
import '../../../../data/models/project_model.dart';
import '../../../../data/repositories/abstract/investment_repository.dart';
import '../../../../routes/app_pages.dart'; // Butuh enum status

class InvestorPortfolioController extends GetxController {

  // --- DEPENDENCIES ---
  final IInvestmentRepository _investmentRepo = Get.find<IInvestmentRepository>();

  // --- STATE ---
  final RxBool isLoading = true.obs;
  final RxList<InvestmentModel> investmentList = <InvestmentModel>[].obs;
  
  // --- SUMMARY STATE ---
  final RxDouble totalInvestment = 0.0.obs;
  final RxDouble estimatedReturn = 0.0.obs; // Kalkulasi ROI
  final RxInt activeProjectsCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMyPortfolio();
  }

  /// Mengambil semua data investasi & menghitung ringkasan
  Future<void> fetchMyPortfolio() async {
    isLoading.value = true;
    try {
      final investments = await _investmentRepo.getMyInvestments();
      investmentList.assignAll(investments);
      
      // Lakukan kalkulasi ringkasan
      _calculateSummary(investments);

    } catch (e) {
      Get.snackbar("Error", "Gagal memuat portofolio: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Helper untuk menghitung data di header
  void _calculateSummary(List<InvestmentModel> investments) {
    double tempTotal = 0.0;
    double tempReturn = 0.0;
    int tempActiveCount = 0;
    
    for (var inv in investments) {
      tempTotal += inv.amountInvested;
      
      // Hitung estimasi return
      tempReturn += inv.amountInvested * (inv.project.roiEstimate / 100);
      
      // Hitung proyek aktif
      if (inv.project.status == ProjectStatus.PUBLISHED || inv.project.status == ProjectStatus.FUNDED) {
        tempActiveCount++;
      }
    }
    
    totalInvestment.value = tempTotal;
    estimatedReturn.value = tempReturn;
    activeProjectsCount.value = tempActiveCount;
  }

  /// Navigasi ke detail investasi
  void goToPortfolioDetail(InvestmentModel investment) {
    // Kirim seluruh objek InvestmentModel ke halaman detail
    Get.toNamed(Routes.INVESTOR_PORTFOLIO_DETAIL, arguments: investment);
  }
}