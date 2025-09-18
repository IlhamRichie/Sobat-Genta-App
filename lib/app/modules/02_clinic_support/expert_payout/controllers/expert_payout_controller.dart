// lib/app/modules/expert_payout/controllers/expert_payout_controller.dart

import 'package:get/get.dart';

import '../../../../data/models/bank_account_model.dart';
import '../../../../data/models/wallet_model.dart';
import '../../../../data/repositories/abstract/bank_account_repository.dart';
import '../../../../data/repositories/abstract/wallet_repository.dart';
import '../../../../routes/app_pages.dart';

class ExpertPayoutController extends GetxController {

  // --- DEPENDENCIES ---
  final IWalletRepository _walletRepo = Get.find<IWalletRepository>();
  final IBankAccountRepository _bankRepo = Get.find<IBankAccountRepository>();

  // --- STATE ---
  final RxBool isLoading = true.obs;
  final Rx<WalletModel?> wallet = Rxn<WalletModel>();
  final RxList<BankAccountModel> accountList = <BankAccountModel>[].obs;
  
  /// LOGIKA KUNCI: User hanya bisa tarik dana jika punya saldo DAN rekening
  bool get canWithdraw => (wallet.value?.balance ?? 0) > 0 && accountList.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    fetchPayoutData();
  }

  /// Ambil data dompet & rekening secara paralel
  Future<void> fetchPayoutData() async {
    isLoading.value = true;
    try {
      // Jalankan kedua fetch secara bersamaan
      final responses = await Future.wait([
        _walletRepo.getMyWallet(),
        _bankRepo.getMyBankAccounts(),
      ]);
      
      wallet.value = responses[0] as WalletModel;
      accountList.assignAll(responses[1] as List<BankAccountModel>);
      
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat data payout: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Navigasi ke halaman manajemen rekening bank
  Future<void> goToManageAccounts() async {
    // Gunakan 'await' agar kita bisa refresh jika user menambah/menghapus rekening
    final result = await Get.toNamed(Routes.MANAGE_BANK_ACCOUNTS);
    if (result == 'updated') {
      fetchPayoutData(); // Refresh datanya
    }
  }

  /// Navigasi ke form tarik dana
  void goToWithdrawForm() {
    if (canWithdraw) {
      Get.toNamed(Routes.WALLET_WITHDRAW);
    } else {
      Get.snackbar("Tidak Bisa", "Anda harus memiliki saldo dan rekening bank terdaftar untuk tarik dana.");
    }
  }
}