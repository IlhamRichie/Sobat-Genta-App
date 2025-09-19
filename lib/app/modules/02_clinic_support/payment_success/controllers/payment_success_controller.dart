// lib/app/modules/payment_success/controllers/payment_success_controller.dart

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../data/models/payment_transaction_model.dart';
import '../../../../routes/app_pages.dart';

class PaymentSuccessController extends GetxController {

  late final PaymentTransactionModel transaction;
  final rupiahFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  void onInit() {
    super.onInit();
    transaction = Get.arguments as PaymentTransactionModel;
  }

  /// Navigasi ke Dompet (untuk melihat saldo baru)
  void goToWallet() {
    // Ganti halaman sukses ini dengan halaman Dompet
    Get.offNamed(Routes.WALLET_MAIN); 
  }

  /// Navigasi kembali ke Beranda (Tab Utama)
  void goToHome() {
    // Bersihkan semua stack dan kembali ke Home
    Get.offAllNamed(Routes.MAIN_NAVIGATION);
  }
}