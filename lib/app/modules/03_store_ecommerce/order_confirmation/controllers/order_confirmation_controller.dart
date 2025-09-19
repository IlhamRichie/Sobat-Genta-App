// lib/app/modules/order_confirmation/controllers/order_confirmation_controller.dart

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../data/models/order_model.dart';
import '../../../../routes/app_pages.dart';

class OrderConfirmationController extends GetxController {

  // --- STATE (Diterima dari argumen) ---
  late final OrderModel confirmedOrder;
  
  // Helper
  final rupiahFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  void onInit() {
    super.onInit();
    // 1. Ambil data pesanan lengkap dari halaman pembayaran
    confirmedOrder = Get.arguments as OrderModel;
  }

  /// 2. Navigasi ke Riwayat Pesanan
  void goToOrderHistory() {
    // Gunakan 'offNamed' untuk MENGGANTI halaman ini.
    // Ini memastikan jika user 'back' dari Riwayat, mereka kembali ke Home,
    // BUKAN ke halaman sukses ini.
    Get.offNamed(Routes.ORDER_HISTORY);
  }

  /// 3. Navigasi kembali ke Beranda (Tab Utama)
  void goToHome() {
    // offAllNamed untuk membersihkan stack dan kembali ke root navigasi
    Get.offAllNamed(Routes.MAIN_NAVIGATION);
  }
}