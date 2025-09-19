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
      appBar: AppBar(
        title: const Text("Detail Lacak Pesanan"),
      ),
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
              _buildTrackingTimeline(order.trackingEvents ?? []), // 1. Timeline
              
              _buildSectionTitle("Detail Pengiriman"),
              _buildAddressCard(order), // 2. Alamat
              
              _buildSectionTitle("Daftar Produk"),
              _buildProductList(order.items ?? []), // 3. Item List

              _buildSectionTitle("Rincian Pembayaran"),
              _buildPaymentSummary(order), // 4. Rincian Biaya
              
              const SizedBox(height: 24),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Text(title, style: Get.textTheme.titleLarge?.copyWith(fontSize: 18)),
    );
  }

  /// 1. Timeline Pelacakan (Data Dinamis)
  Widget _buildTrackingTimeline(List<OrderTrackingEventModel> events) {
    if (events.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Text("Data pelacakan belum tersedia."),
      );
    }
    // Render Timeline
    return ListView.builder(
      itemCount: events.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final event = events[index];
        // (Kita REUSE arsitektur UI dari InvestorPortfolioDetailView)
        return _OrderTimelineTile(
          event: event,
          isFirst: index == 0,
          isLast: index == events.length - 1,
        );
      },
    );
  }

  /// 2. Kartu Alamat Pengiriman
  Widget _buildAddressCard(order) {
    final addr = order.shippingAddress;
     return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade300)
        ),
        leading: const FaIcon(FontAwesomeIcons.locationDot, color: AppColors.primary),
        title: Text("${addr.recipientName} (${addr.label})", style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("${addr.fullAddress}, ${addr.city} \n${addr.phoneNumber}"),
        isThreeLine: true,
      ),
    );
  }

  /// 3. Daftar Item Produk (Data Berat)
  Widget _buildProductList(List<CartItemModel> items) {
     return ListView.builder(
      itemCount: items.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (ctx, index) {
        final item = items[index];
        return ListTile(
          leading: Container(
            width: 50, height: 50,
            decoration: BoxDecoration(color: AppColors.greyLight, borderRadius: BorderRadius.circular(8)),
          ),
          title: Text(item.product.name, maxLines: 2),
          subtitle: Text("${item.quantity} item"),
          trailing: Text(
            controller.rupiahFormatter.format(item.subTotal),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }

  /// 4. Ringkasan Biaya (dari Order)
  Widget _buildPaymentSummary(order) {
    // (Asumsi ongkir disimpan, kita ambil dari data mock CheckoutPayment)
    final double shippingCost = 15000.0; 
    final double subtotal = order.grandTotal - shippingCost;
    
    return Padding(
       padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
           _buildSummaryRow("Subtotal Produk", controller.rupiahFormatter.format(subtotal)),
          _buildSummaryRow("Biaya Pengiriman", controller.rupiahFormatter.format(shippingCost)),
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
     return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Get.textTheme.bodyMedium?.copyWith(color: AppColors.textLight)),
          Text(value, style: Get.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold, fontSize: isTotal ? 18 : 16
          )),
        ],
      ),
    );
  }
}


/// WIDGET REUSABLE: Untuk Timeline Tracking
/// (Ini adalah copy-paste/adaptasi dari InvestorPortfolioDetailView.
/// Idealnya ini di-refactor ke /widgets/timeline_tile.dart generik)
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
            padding: const EdgeInsets.only(left: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(child: Container(width: 2, color: isFirst ? Colors.transparent : Colors.grey.shade300)),
                Container(
                  width: 16, height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isFirst ? AppColors.primary : Colors.grey.shade300,
                  ),
                ),
                Expanded(child: Container(width: 2, color: isLast ? Colors.transparent : Colors.grey.shade300)),
              ],
            ),
          ),
          // 2. Konten
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(event.statusTitle, style: Get.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: isFirst ? AppColors.primary : AppColors.textDark)),
                  const SizedBox(height: 4),
                  Text("${event.formattedDate} - ${event.formattedTime}", style: Get.textTheme.bodySmall),
                  const SizedBox(height: 8),
                  Text(event.description, style: Get.textTheme.bodyMedium?.copyWith(color: AppColors.textLight)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}