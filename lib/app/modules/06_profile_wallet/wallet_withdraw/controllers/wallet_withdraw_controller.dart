// lib/app/modules/wallet_withdraw/controllers/wallet_withdraw_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../data/models/bank_account_model.dart';
import '../../../../data/models/wallet_model.dart';
import '../../../../data/repositories/abstract/bank_account_repository.dart';
import '../../../../data/repositories/abstract/payout_repository.dart';
import '../../../../data/repositories/abstract/wallet_repository.dart';
import '../../../../routes/app_pages.dart';

class WalletWithdrawController extends GetxController {

  // --- DEPENDENCIES ---
  final IWalletRepository _walletRepo = Get.find<IWalletRepository>();
  final IBankAccountRepository _bankRepo = Get.find<IBankAccountRepository>();
  final IPayoutRepository _payoutRepo = Get.find<IPayoutRepository>();

  // --- FORM & STATE ---
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController amountC = TextEditingController();
  final RxBool isLoadingData = true.obs; // Untuk load awal
  final RxBool isSubmitting = false.obs; // Untuk tombol submit

  // --- DATA STATE ---
  final Rx<WalletModel?> wallet = Rxn<WalletModel>();
  final Rx<BankAccountModel?> primaryAccount = Rxn<BankAccountModel>();

  // Helper
  final rupiahFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  // --- GETTERS (LOGIKA UI) ---
  double get availableBalance => wallet.value?.balance ?? 0.0;
  // Tombol submit hanya aktif jika semua data siap & ada saldo
  bool get canSubmitRequest => primaryAccount.value != null && availableBalance > 0;

  @override
  void onInit() {
    super.onInit();
    fetchPrerequisites();
  }

  @override
  void onClose() {
    amountC.dispose();
    super.onClose();
  }

  /// Ambil Saldo & Rekening Utama
  Future<void> fetchPrerequisites() async {
    isLoadingData.value = true;
    try {
      // Ambil keduanya secara paralel
      final responses = await Future.wait([
        _walletRepo.getMyWallet(),
        _bankRepo.getMyBankAccounts(),
      ]);

      wallet.value = responses[0] as WalletModel;
      final accounts = responses[1] as List<BankAccountModel>;
      
      // Temukan rekening utama
      primaryAccount.value = accounts.firstWhere(
        (acc) => acc.isPrimary,
        // orElse: () => null, // Jika tidak ada, biarkan null
      );

    } catch (e) {
      Get.snackbar("Error", "Gagal memuat data: $e");
    } finally {
      isLoadingData.value = false;
    }
  }

  /// Set jumlah ke maksimum (saldo penuh)
  void setMaxAmount() {
    amountC.text = availableBalance.toStringAsFixed(0);
  }

  /// Aksi utama: Kirim Permintaan Payout
  Future<void> submitWithdrawalRequest() async {
    if (!formKey.currentState!.validate()) return;
    if (!canSubmitRequest) return; // Pengaman ganda

    final double amount = double.tryParse(amountC.text) ?? 0.0;

    // Validasi jumlah vs saldo
    if (amount > availableBalance) {
      Get.snackbar("Gagal", "Jumlah penarikan melebihi saldo Anda.");
      return;
    }
    if (amount < 10000) { // Asumsi minimal withdraw
      Get.snackbar("Gagal", "Minimum penarikan adalah Rp 10.000.");
      return;
    }

    isSubmitting.value = true;
    try {
      await _payoutRepo.requestPayout(
        amount: amount,
        bankAccountId: primaryAccount.value!.accountId,
      );

      showTopSnackBar(
        Overlay.of(Get.context!),
        CustomSnackBar.success(
          message: "Permintaan penarikan terkirim dan akan diproses Admin 1x24 jam.",
          backgroundColor: Colors.green.shade700,
        ),
      );

      // Kembali ke halaman Payout dan kirim sinyal 'success' untuk refresh
      Get.back(result: 'success');

    } catch (e) {
      Get.snackbar("Error", "Gagal mengirim permintaan: $e");
    } finally {
      isSubmitting.value = false;
    }
  }
  
  /// Navigasi ke manajemen bank jika user perlu menambah/mengubah
  void goToManageAccounts() {
     Get.toNamed(Routes.MANAGE_BANK_ACCOUNTS);
  }
}