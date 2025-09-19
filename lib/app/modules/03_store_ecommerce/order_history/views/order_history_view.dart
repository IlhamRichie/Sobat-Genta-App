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
      appBar: AppBar(
        title: const Text("Riwayat Pesanan Toko"),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (controller.orderList.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(FontAwesomeIcons.receipt, size: 80, color: AppColors.greyLight),
                SizedBox(height: 16),
                Text("Belum ada riwayat pesanan."),
              ],
            ),
          );
        }

        // Render ListView
        return RefreshIndicator(
          onRefresh: controller.fetchInitialOrders,
          child: ListView.builder(
            controller: controller.scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: controller.orderList.length + 1, // +1 untuk loader
            itemBuilder: (context, index) {
              if (index == controller.orderList.length) {
                return _buildLoader(); // Loader di akhir list
              }
              final order = controller.orderList[index];
              return _buildOrderCard(order);
            },
          ),
        );
      }),
    );
  }

  /// Kartu untuk satu riwayat pesanan
  Widget _buildOrderCard(OrderModel order) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => controller.goToTrackingDetail(order),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Order ID: ${order.orderId}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  _buildStatusBadge(order.status),
                ],
              ),
              const Divider(height: 20),
              Text(
                DateFormat('d MMMM yyyy, HH:mm', 'id_ID').format(order.orderDate),
                style: Get.textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Text(
                "Total Pembayaran:",
                style: Get.textTheme.bodyMedium,
              ),
              Text(
                rupiahFormatter.format(order.grandTotal),
                style: Get.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () => controller.goToTrackingDetail(order),
                child: const Text("Lihat Detail Pesanan"),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// Badge Status
  Widget _buildStatusBadge(String status) {
    Color color;
    String text;
    switch (status.toUpperCase()) {
      case "COMPLETED":
        color = Colors.green; text = "Selesai"; break;
      case "SHIPPED":
        color = Colors.blue; text = "Dikirim"; break;
      case "PAID":
        color = Colors.orange; text = "Diproses"; break;
      default:
        color = Colors.grey; text = "Pending";
    }
    return Chip(
      label: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      visualDensity: VisualDensity.compact,
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