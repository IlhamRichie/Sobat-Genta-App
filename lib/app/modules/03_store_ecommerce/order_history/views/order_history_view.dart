// lib/app/modules/order_history/views/order_history_view.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../data/models/order_model.dart';
import '../../../../theme/app_colors.dart';
import '../controllers/order_history_controller.dart';

class OrderHistoryView extends GetView<OrderHistoryController> {
  OrderHistoryView({Key? key}) : super(key: key);
  
  final rupiahFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Obx(() {
        if (controller.isLoading.value && controller.orderList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (controller.orderList.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          onRefresh: controller.fetchInitialOrders,
          child: ListView.builder(
            controller: controller.scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            itemCount: controller.orderList.length + 1,
            itemBuilder: (context, index) {
              if (index == controller.orderList.length) {
                return _buildLoader();
              }
              final order = controller.orderList[index];
              return _buildOrderCard(order);
            },
          ),
        );
      }),
    );
  }

  /// AppBar Kustom
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: BackButton(
        color: AppColors.textDark,
        onPressed: () => Get.back(),
      ),
      title: Text(
        "Riwayat Pesanan",
        style: Get.textTheme.headlineSmall?.copyWith(
          color: AppColors.textDark,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: false,
    );
  }

  /// Empty State yang Didesain Ulang
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FaIcon(FontAwesomeIcons.receipt, size: 96, color: AppColors.greyLight),
            const SizedBox(height: 32),
            Text(
              "Belum Ada Riwayat Pesanan",
              style: Get.textTheme.titleLarge?.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              "Yuk, jelajahi toko kami dan temukan produk menarik!",
              style: Get.textTheme.bodyMedium?.copyWith(
                fontSize: 16,
                color: AppColors.textLight,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Kartu untuk satu riwayat pesanan (Didesain Ulang)
  Widget _buildOrderCard(OrderModel order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Order ID: ${order.orderId}",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              _buildStatusBadge(order.status),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.greyLight),
          const SizedBox(height: 12),
          Text(
            DateFormat('d MMMM yyyy, HH:mm', 'id_ID').format(order.orderDate),
            style: Get.textTheme.bodyMedium?.copyWith(color: AppColors.textLight),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total Pembayaran",
                style: Get.textTheme.bodyMedium,
              ),
              Text(
                rupiahFormatter.format(order.grandTotal),
                style: Get.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () => controller.goToTrackingDetail(order),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text("Lihat Detail Pesanan"),
          ),
        ],
      ),
    );
  }

  /// Badge Status (Didesain Ulang)
  Widget _buildStatusBadge(String status) {
    Color color;
    String text;
    switch (status.toUpperCase()) {
      case "COMPLETED": color = Colors.green; text = "Selesai"; break;
      case "SHIPPED": color = Colors.blue; text = "Dikirim"; break;
      case "PAID": color = Colors.orange; text = "Diproses"; break;
      default: color = Colors.grey; text = "Pending";
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: Get.textTheme.bodySmall?.copyWith(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
  
  /// Loader (Identik dengan ProductReviewsView)
  Widget _buildLoader() {
    return Obx(() {
      if (controller.isLoadingMore.value) {
        return const Center(child: Padding(padding: EdgeInsets.all(24.0), child: CircularProgressIndicator()));
      }
      if (!controller.hasMoreData.value) {
        return const Center(child: Padding(padding: EdgeInsets.all(24.0), child: Text("Akhir dari riwayat.")));
      }
      return const SizedBox.shrink();
    });
  }
}