// lib/app/modules/investor_invest_form/controllers/investor_invest_form_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

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

  // Helper untuk format
  final rupiahFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  // --- GETTERS (LOGIKA VALIDASI) ---
  /// Sisa dana yang dibutuhkan proyek
  double get remainingNeeded => project.targetFund - project.collectedFund;
  /// Saldo dompet yang dimiliki investor
  double get availableBalance => myWallet.value?.balance ?? 0.0;
  
  @override
  void onInit() {
    super.onInit();
    // Ambil objek proyek dari halaman detail
    project = Get.arguments as ProjectModel;
    _loadWalletData();
  }

  @override
  void onClose() {
    amountC.dispose();
    super.onClose();
  }

  /// Ambil data dompet investor
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

  /// Set jumlah investasi dari chip
  void setAmountFromChip(double amount) {
    // Validasi cepat: jangan biarkan chip melebihi saldo/kebutuhan
    if (amount > remainingNeeded) {
      setMaxAmount();
      return;
    }
    if (amount > availableBalance) {
      Get.snackbar("Info", "Saldo Anda tidak mencukupi untuk jumlah ini.");
      setMaxAmount();
      return;
    }
    amountC.text = amount.toStringAsFixed(0);
  }

  /// Set ke jumlah maksimum yang diizinkan
  void setMaxAmount() {
    // Ambil nilai terkecil antara saldo ATAU sisa kebutuhan
    double maxPossible = [remainingNeeded, availableBalance].reduce((a, b) => a < b ? a : b);
    amountC.text = maxPossible.toStringAsFixed(0);
  }

  /// Aksi utama: Eksekusi Investasi (Langkah I6)
  Future<void> submitInvestment() async {
    if (!formKey.currentState!.validate()) return;
    
    final double amount = double.tryParse(amountC.text) ?? 0.0;

    // --- VALIDASI KRITIS ---
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
      // Panggil repository (transaksi palsu)
      await _projectRepo.investInProject(project.projectId, amount);

      showTopSnackBar(
        Overlay.of(Get.context!),
        CustomSnackBar.success(
          message: "Investasi senilai ${rupiahFormatter.format(amount)} berhasil!",
          backgroundColor: Colors.green.shade700,
        ),
      );

      // Selesai. Navigasi ke Portofolio (Langkah I7)
      Get.offNamed(Routes.INVESTOR_PORTFOLIO);

    } catch (e) {
      _showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
  
  void _showError(String message) {
     showTopSnackBar(
      Overlay.of(Get.context!),
      CustomSnackBar.error(message: message.replaceAll("Exception: ", "")),
    );
  }
}