// lib/app/modules/wallet_main/controllers/wallet_main_controller.dart

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../data/models/user_model.dart';
import '../../../../data/models/wallet_model.dart';
import '../../../../data/repositories/abstract/wallet_repository.dart';
import '../../../../routes/app_pages.dart';
import '../../../../services/session_service.dart';

class WalletMainController extends GetxController {

  // --- DEPENDENCIES ---
  final IWalletRepository _walletRepo = Get.find<IWalletRepository>();
  final SessionService _sessionService = Get.find<SessionService>();

  // --- STATE ---
  final RxBool isLoading = true.obs;
  final Rx<WalletModel?> wallet = Rxn<WalletModel>();
  late final UserRole userRole;

  // Helper
  final rupiahFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  // --- LOGIKA KUNCI (Computed Getter) ---
  /// Menentukan apakah tombol Tarik Dana & Rekening Bank tampil
  /// (Hanya Investor. Petani tidak menarik dana dari sini).
  bool get shouldShowWithdrawFeatures => userRole == UserRole.INVESTOR;

  @override
  void onInit() {
    super.onInit();
    // 1. Ambil peran dari sesi
    userRole = _sessionService.userRole;
    // 2. Ambil data saldo
    fetchWalletData();
  }

  /// 1. Ambil data saldo dompet
  Future<void> fetchWalletData() async {
    isLoading.value = true;
    try {
      wallet.value = await _walletRepo.getMyWallet();
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat data dompet.");
    } finally {
      isLoading.value = false;
    }
  }
  
  /// 2. Navigasi ke Riwayat
  void goToWalletHistory() {
    Get.toNamed(Routes.WALLET_HISTORY);
  }
  
  /// 3. Navigasi ke Top Up
  Future<void> goToTopUp() async {
    // Await untuk refresh jika Top Up berhasil
    final result = await Get.toNamed(Routes.WALLET_TOP_UP);
    if (result != null) { // (Halaman sukses akan mengirim result)
      fetchWalletData(); // Refresh saldo
    }
  }

  /// 4. Navigasi ke Withdraw (Khusus Investor)
  Future<void> goToWithdraw() async {
    final result = await Get.toNamed(Routes.WALLET_WITHDRAW);
    if (result == 'success') {
      fetchWalletData(); // Refresh saldo (menampilkan saldo tertahan/berkurang)
    }
  }
  
  /// 5. Navigasi ke Bank (Khusus Investor)
  void goToBankAccounts() {
     Get.toNamed(Routes.MANAGE_BANK_ACCOUNTS);
  }
}