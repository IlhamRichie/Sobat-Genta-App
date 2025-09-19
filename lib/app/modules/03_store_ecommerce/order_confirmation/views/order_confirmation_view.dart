// lib/app/modules/order_confirmation/views/order_confirmation_view.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../theme/app_colors.dart';
import '../controllers/order_confirmation_controller.dart';

class OrderConfirmationView extends GetView<OrderConfirmationController> {
  const OrderConfirmationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ARSITEKTUR: Kita bungkus dengan WillPopScope untuk mencegat
    // tombol 'back' fisik Android. Pengguna tidak boleh kembali dari sini,
    // mereka harus memilih aksi (ke Home atau ke Riwayat).
    return WillPopScope(
      onWillPop: () async {
        controller.goToHome(); // Jika ditekan back, paksa ke Home
        return false; // Jangan biarkan pop default terjadi
      },
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildSuccessIcon(),
                  const SizedBox(height: 24),
                  _buildSuccessText(),
                  const SizedBox(height: 32),
                  _buildOrderSummary(),
                  const SizedBox(height: 48),
                  _buildActionButtons(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Icon Sukses
  Widget _buildSuccessIcon() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.green.shade700,
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: FaIcon(FontAwesomeIcons.check, size: 50, color: Colors.white),
      ),
    );
  }

  /// Teks Sukses
  Widget _buildSuccessText() {
    return Column(
      children: [
        Text(
          "Pembayaran Berhasil!",
          style: Get.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          "Pesanan Anda sedang diproses. Terima kasih telah berbelanja.",
          style: Get.textTheme.bodyLarge?.copyWith(color: AppColors.textLight),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Ringkasan Order
  Widget _buildOrderSummary() {
    final order = controller.confirmedOrder;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildSummaryRow("Order ID", order.orderId),
          _buildSummaryRow("Total Pembayaran", controller.rupiahFormatter.format(order.grandTotal)),
          _buildSummaryRow("Status", order.status, isStatus: true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isStatus = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textLight)),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold, 
              color: isStatus ? Colors.green.shade700 : AppColors.textDark
            ),
          ),
        ],
      ),
    );
  }

  /// Tombol Aksi (CTA)
  Widget _buildActionButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Tombol Lacak Pesanan
        FilledButton(
          onPressed: controller.goToOrderHistory,
          child: const Text("Lacak Pesanan Saya"),
        ),
        const SizedBox(height: 12),
        // 2. Tombol Kembali ke Beranda
        OutlinedButton(
          onPressed: controller.goToHome,
          child: const Text("Kembali ke Beranda"),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary),
          ),
        ),
      ],
    );
  }
}