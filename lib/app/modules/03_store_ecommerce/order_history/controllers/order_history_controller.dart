// lib/app/modules/order_history/controllers/order_history_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/models/order_model.dart';
import '../../../../data/repositories/abstract/order_repository.dart';
import '../../../../routes/app_pages.dart';

class OrderHistoryController extends GetxController {

  // --- DEPENDENCIES ---
  final IOrderRepository _orderRepo = Get.find<IOrderRepository>();

  // --- STATE ---
  final RxBool isLoading = true.obs;
  final RxList<OrderModel> orderList = <OrderModel>[].obs;

  // --- PAGINATION STATE ---
  final ScrollController scrollController = ScrollController();
  final RxBool isLoadingMore = false.obs;
  final RxInt currentPage = 1.obs;
  final RxBool hasMoreData = true.obs;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_scrollListener);
    fetchInitialOrders();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  /// 1. Ambil data halaman pertama
  Future<void> fetchInitialOrders() async {
    isLoading.value = true;
    hasMoreData.value = true;
    currentPage.value = 1;
    orderList.clear(); // Hapus data lama saat refresh
    
    try {
      final orders = await _orderRepo.getMyOrders(1);
      if (orders.isEmpty) {
        hasMoreData.value = false;
      }
      orderList.assignAll(orders);
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat riwayat pesanan: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// 2. Listener scroll
  void _scrollListener() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent &&
        !isLoadingMore.value &&
        hasMoreData.value) {
      loadMoreOrders();
    }
  }

  /// 3. Ambil data halaman berikutnya
  Future<void> loadMoreOrders() async {
    isLoadingMore.value = true;
    currentPage.value++;

    try {
      final newOrders = await _orderRepo.getMyOrders(currentPage.value);
      if (newOrders.isEmpty) {
        hasMoreData.value = false;
      } else {
        orderList.addAll(newOrders);
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat data tambahan: $e");
    } finally {
      isLoadingMore.value = false;
    }
  }

  /// 4. Navigasi ke Detail Tracking
  void goToTrackingDetail(OrderModel order) {
    // Kirim HANYA ID. Halaman detail harus fetch datanya sendiri
    // (termasuk daftar item dan data tracking)
    Get.toNamed(Routes.ORDER_TRACKING_DETAIL, arguments: order.orderId);
  }
}