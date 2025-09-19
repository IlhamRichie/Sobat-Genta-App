// lib/app/modules/order_tracking_detail/controllers/order_tracking_detail_controller.dart

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../data/models/order_model.dart';
import '../../../../data/repositories/abstract/order_repository.dart';

class OrderTrackingDetailController extends GetxController {

  // --- DEPENDENCIES ---
  final IOrderRepository _orderRepo = Get.find<IOrderRepository>();

  // --- STATE ---
  final RxBool isLoading = true.obs;
  final Rx<OrderModel?> order = Rxn<OrderModel>();
  late final String _orderId;

  // Helper
  final rupiahFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  void onInit() {
    super.onInit();
    _orderId = Get.arguments as String;
    fetchOrderDetail();
  }

  /// Ambil data detail lengkap (termasuk item & tracking)
  Future<void> fetchOrderDetail() async {
    isLoading.value = true;
    try {
      final data = await _orderRepo.getOrderDetailById(_orderId);
      order.value = data;
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat detail pesanan: $e");
    } finally {
      isLoading.value = false;
    }
  }
}