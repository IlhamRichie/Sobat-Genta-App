import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/models/investment_model.dart';
import '../../../../data/models/project_model.dart';
import '../../../../data/repositories/abstract/investment_repository.dart';
import '../../../../routes/app_pages.dart'; 

class InvestorPortfolioController extends GetxController {

  // --- DEPENDENCIES ---
  final IInvestmentRepository _investmentRepo = Get.find<IInvestmentRepository>();

  // --- STATE ---
  final RxBool isLoading = true.obs;
  final RxList<InvestmentModel> investmentList = <InvestmentModel>[].obs;
  
  // --- SUMMARY STATE ---
  final RxDouble totalInvestment = 0.0.obs;
  final RxDouble estimatedReturn = 0.0.obs;
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
      // Simulasi delay sedikit biar loading kelihatan (UX)
      await Future.delayed(const Duration(milliseconds: 500));
      
      final investments = await _investmentRepo.getMyInvestments();
      investmentList.assignAll(investments);
      
      _calculateSummary(investments);

    } catch (e) {
      // GANTI showTopSnackBar dengan Get.snackbar (AMAN DARI CRASH)
      Get.snackbar(
        "Gagal Memuat",
        "Terjadi kesalahan saat mengambil data portofolio.",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(20),
        borderRadius: 10,
      );
      print("Portfolio Error: $e"); // Log error asli ke console
    } finally {
      isLoading.value = false;
    }
  }

  void _calculateSummary(List<InvestmentModel> investments) {
    double tempTotal = 0.0;
    double tempReturn = 0.0;
    int tempActiveCount = 0;
    
    for (var inv in investments) {
      tempTotal += inv.amountInvested;
      
      // Hitung proyek aktif (Status FUNDED atau PUBLISHED dianggap aktif berjalan)
      if (inv.project.status == ProjectStatus.FUNDED || inv.project.status == ProjectStatus.PUBLISHED) {
        tempActiveCount++;
        // Hitung estimasi return hanya dari proyek aktif
        tempReturn += inv.amountInvested * (inv.project.roiEstimate / 100);
      }
    }
    
    totalInvestment.value = tempTotal;
    estimatedReturn.value = tempReturn;
    activeProjectsCount.value = tempActiveCount;
  }

  void goToPortfolioDetail(InvestmentModel investment) {
    Get.toNamed(Routes.INVESTOR_PORTFOLIO_DETAIL, arguments: investment);
  }
}