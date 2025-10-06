// lib/app/modules/order_tracking_detail/views/order_tracking_detail_view.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../data/models/cart_item_model.dart';
import '../../../../data/models/order_tracking_event_model.dart';
import '../../../../theme/app_colors.dart';
import '../controllers/order_tracking_detail_controller.dart';

class OrderTrackingDetailView extends GetView<OrderTrackingDetailController> {
  const OrderTrackingDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.order.value == null) {
          return const Center(child: Text("Pesanan tidak ditemukan."));
        }
        
        final order = controller.order.value!;
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("Status Pengiriman"),
              _buildTrackingTimeline(order.trackingEvents ?? []),
              
              _buildSectionTitle("Detail Pengiriman"),
              _buildAddressCard(order),
              
              _buildSectionTitle("Daftar Produk"),
              _buildProductList(order.items ?? []),

              _buildSectionTitle("Rincian Pembayaran"),
              _buildPaymentSummary(order),
              
              const SizedBox(height: 24),
            ],
          ),
        );
      }),
    );
  }

  /// AppBar Kustom dengan BackButton dan Tombol Home
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: BackButton(
        color: AppColors.textDark,
        onPressed: () => Get.back(),
      ),
      title: Text(
        "Lacak Pesanan",
        style: Get.textTheme.headlineSmall?.copyWith(
          color: AppColors.textDark,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: false,
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
      child: Text(
        title,
        style: Get.textTheme.titleLarge?.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// 1. Timeline Pelacakan (Didesain Ulang)
  Widget _buildTrackingTimeline(List<OrderTrackingEventModel> events) {
    if (events.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Text("Data pelacakan belum tersedia."),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
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
      child: ListView.builder(
        itemCount: events.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final event = events[index];
          return _OrderTimelineTile(
            event: event,
            isFirst: index == 0,
            isLast: index == events.length - 1,
          );
        },
      ),
    );
  }

  /// 2. Kartu Alamat Pengiriman (Didesain Ulang)
  Widget _buildAddressCard(order) {
    final addr = order.shippingAddress;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FaIcon(FontAwesomeIcons.locationDot, color: AppColors.primary, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${addr.recipientName} (${addr.label})",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  "${addr.fullAddress}, ${addr.city}, ${addr.postalCode}",
                  style: Get.textTheme.bodyMedium?.copyWith(color: AppColors.textDark),
                ),
                const SizedBox(height: 4),
                Text(
                  addr.phoneNumber,
                  style: Get.textTheme.bodyMedium?.copyWith(color: AppColors.textLight),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 3. Daftar Item Produk (Didesain Ulang)
  Widget _buildProductList(List<CartItemModel> items) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 24.0),
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
      child: ListView.builder(
        itemCount: items.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (ctx, index) {
          final item = items[index];
          return Padding(
            padding: EdgeInsets.only(bottom: index == items.length - 1 ? 0 : 16),
            child: _buildProductItemTile(item),
          );
        },
      ),
    );
  }
  
  Widget _buildProductItemTile(CartItemModel item) {
    return Row(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.greyLight,
            borderRadius: BorderRadius.circular(12),
            image: item.product.imageUrl != null && item.product.imageUrl!.isNotEmpty
                ? DecorationImage(image: NetworkImage(item.product.imageUrl!), fit: BoxFit.cover)
                : null,
          ),
          child: item.product.imageUrl == null || item.product.imageUrl!.isEmpty
              ? const Center(child: FaIcon(FontAwesomeIcons.image, color: Colors.grey))
              : null,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.product.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(
                "Jumlah: ${item.quantity} item",
                style: Get.textTheme.bodySmall?.copyWith(color: AppColors.textLight),
              ),
            ],
          ),
        ),
        Text(
          controller.rupiahFormatter.format(item.subTotal),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }

  /// 4. Ringkasan Biaya (Didesain Ulang)
  Widget _buildPaymentSummary(order) {
    final double shippingCost = 15000.0;
    final double subtotal = order.grandTotal - shippingCost;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0),
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
        children: [
          _buildSummaryRow("Subtotal Produk", controller.rupiahFormatter.format(subtotal)),
          const SizedBox(height: 12),
          _buildSummaryRow("Biaya Pengiriman", controller.rupiahFormatter.format(shippingCost)),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.greyLight),
          const SizedBox(height: 12),
          _buildSummaryRow(
            "Total Pembayaran", 
            controller.rupiahFormatter.format(order.grandTotal),
            isTotal: true
          ),
        ],
      ),
    );
  }
  
  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Get.textTheme.bodyMedium?.copyWith(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            fontSize: isTotal ? 16 : 14,
          ),
        ),
        Text(
          value,
          style: Get.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: isTotal ? 18 : 16,
            color: isTotal ? AppColors.primary : AppColors.textDark,
          ),
        ),
      ],
    );
  }
}

/// WIDGET REUSABLE: Untuk Timeline Tracking
class _OrderTimelineTile extends StatelessWidget {
  final OrderTrackingEventModel event;
  final bool isFirst;
  final bool isLast;
  
  const _OrderTimelineTile({
    required this.event,
    required this.isFirst,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Garis Timeline
          Container(
            width: 40,
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(child: Container(width: 2, color: isFirst ? Colors.transparent : AppColors.primary)),
                Container(
                  width: 16, height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isFirst ? AppColors.primary : AppColors.greyLight,
                    border: Border.all(color: isFirst ? AppColors.primary : AppColors.greyLight, width: 2)
                  ),
                  child: isFirst 
                      ? const Center(child: FaIcon(FontAwesomeIcons.check, size: 8, color: Colors.white))
                      : null,
                ),
                Expanded(child: Container(width: 2, color: isLast ? Colors.transparent : AppColors.primary)),
              ],
            ),
          ),
          // 2. Konten
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.statusTitle,
                    style: Get.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isFirst ? AppColors.primary : AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${event.formattedDate} - ${event.formattedTime}",
                    style: Get.textTheme.bodySmall?.copyWith(color: AppColors.textLight),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    event.description,
                    style: Get.textTheme.bodyMedium?.copyWith(color: AppColors.textLight),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}