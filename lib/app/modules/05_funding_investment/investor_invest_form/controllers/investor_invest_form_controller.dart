import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
// Hapus import top_snackbar_flutter karena kita ganti pakai Get.snackbar bawaan
// import 'package:top_snackbar_flutter/custom_snack_bar.dart';
// import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../data/models/project_model.dart';
import '../../../../data/models/wallet_model.dart';
import '../../../../data/repositories/abstract/project_repository.dart';
import '../../../../data/repositories/abstract/wallet_repository.dart';
import '../../../../routes/app_pages.dart';

class InvestorInvestFormController extends GetxController {

  // --- DEPENDENCIES ---
  final IProjectRepository _projectRepo = Get.find<IProjectRepository>();
  final IWalletRepository _walletRepo = Get.find<IWalletRepository>();

  // --- STATE ---
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController amountC = TextEditingController();
  final RxBool isLoading = false.obs;
  final RxBool isLoadingPage = true.obs;
  
  late final ProjectModel project;
  final Rx<WalletModel?> myWallet = Rx<WalletModel?>(null);

  final rupiahFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  // --- GETTERS ---
  double get remainingNeeded => project.targetFund - project.collectedFund;
  double get availableBalance => myWallet.value?.balance ?? 0.0;
  
  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
       project = Get.arguments as ProjectModel;
    }
    _loadWalletData();
  }

  @override
  void onClose() {
    amountC.dispose();
    super.onClose();
  }

  Future<void> _loadWalletData() async {
    isLoadingPage.value = true;
    try {
      myWallet.value = await _walletRepo.getMyWallet();
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat data dompet.");
    } finally {
      isLoadingPage.value = false;
    }
  }

  // --- AKSI FORM ---

  void setAmountFromChip(double amount) {
    if (amount > remainingNeeded) {
      setMaxAmount();
      return;
    }
    if (amount > availableBalance) {
      Get.snackbar("Info", "Saldo Anda tidak mencukupi.", snackPosition: SnackPosition.BOTTOM);
      setMaxAmount();
      return;
    }
    amountC.text = amount.toStringAsFixed(0);
  }

  void setMaxAmount() {
    double maxPossible = [remainingNeeded, availableBalance].reduce((a, b) => a < b ? a : b);
    amountC.text = maxPossible.toStringAsFixed(0);
  }

  Future<void> submitInvestment() async {
    // Pastikan formKey attached sebelum validate
    if (formKey.currentState == null || !formKey.currentState!.validate()) return;
    
    final double amount = double.tryParse(amountC.text.replaceAll('.', '')) ?? 0.0; // Hapus titik jika ada format

    if (amount <= 0) {
      _showError("Jumlah investasi harus lebih dari nol.");
      return;
    }
    if (amount > availableBalance) {
      _showError("Saldo dompet Anda tidak mencukupi.");
      return;
    }
    if (amount > remainingNeeded) {
      _showError("Jumlah investasi Anda melebihi dana yang dibutuhkan proyek.");
      return;
    }

    isLoading.value = true;
    try {
      await _projectRepo.investInProject(project.projectId, amount);

      // --- PERBAIKAN DI SINI ---
      // Ganti showTopSnackBar dengan Get.snackbar
      Get.snackbar(
        "Berhasil!",
        "Investasi senilai ${rupiahFormatter.format(amount)} berhasil!",
        backgroundColor: Colors.green.shade700,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
        borderRadius: 10,
        icon: const Icon(Icons.check_circle, color: Colors.white),
        duration: const Duration(seconds: 3),
      );

      // Delay sedikit biar snackbar kebaca sebelum pindah (Opsional)
      await Future.delayed(const Duration(seconds: 2));
      
      Get.offNamed(Routes.INVESTOR_PORTFOLIO);

    } catch (e) {
      _showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
  
  void _showError(String message) {
    Get.snackbar(
      "Gagal",
      message,
      backgroundColor: Colors.red.shade600,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 10,
      icon: const Icon(Icons.error_outline, color: Colors.white),
    );
  }
}