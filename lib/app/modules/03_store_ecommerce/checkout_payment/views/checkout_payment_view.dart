// lib/app/modules/checkout_payment/views/checkout_payment_view.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../data/models/cart_item_model.dart';
import '../../../../theme/app_colors.dart';
import '../controllers/checkout_payment_controller.dart';

class CheckoutPaymentView extends GetView<CheckoutPaymentController> {
  const CheckoutPaymentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      bottomNavigationBar: _buildBottomPayBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Alamat Pengiriman"),
            const SizedBox(height: 12),
            _buildAddressCard(),
            const SizedBox(height: 24),
            _buildSectionTitle("Ringkasan Produk"),
            const SizedBox(height: 12),
            _buildProductList(),
            const SizedBox(height: 24),
            _buildSectionTitle("Metode Pembayaran"),
            const SizedBox(height: 12),
            _buildPaymentOptions(),
            const SizedBox(height: 24),
            _buildSectionTitle("Ringkasan Pembayaran"),
            const SizedBox(height: 12),
            _buildPaymentSummary(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  /// AppBar Kustom
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      title: Text(
        "Pembayaran",
        style: Get.textTheme.headlineSmall?.copyWith(
          color: AppColors.textDark,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: false,
    );
  }

  /// 1. Tampilan Alamat (Didesain Ulang)
  Widget _buildAddressCard() {
    final addr = controller.selectedAddress;
    return Container(
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

  /// 2. Daftar Produk (Didesain Ulang)
  Widget _buildProductList() {
    return Container(
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
      child: ListView.builder(
        itemCount: controller.cartItems.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (ctx, index) {
          final item = controller.cartItems[index];
          return Padding(
            padding: EdgeInsets.only(bottom: index == controller.cartItems.length - 1 ? 0 : 16),
            child: _buildProductItemTile(item),
          );
        },
      ),
    );
  }

  /// Helper untuk item produk di list
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
                "${item.quantity} item x ${controller.rupiahFormatter.format(item.product.price)}",
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

  /// 3. Opsi Pembayaran (Didesain Ulang)
  Widget _buildPaymentOptions() {
    return Obx(() => Container(
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
          _buildPaymentOptionCard(
            'WALLET',
            title: "Genta Wallet",
            subtitle: controller.isLoadingWallet.value
                ? "Memeriksa saldo..."
                : "Saldo: ${controller.rupiahFormatter.format(controller.myWallet.value?.balance ?? 0)}",
            secondaryText: controller.canPayWithWallet ? null : "Saldo Tidak Cukup",
            secondaryColor: Colors.red.shade700,
            icon: FontAwesomeIcons.wallet,
            enabled: controller.canPayWithWallet,
          ),
          const SizedBox(height: 12),
          _buildPaymentOptionCard(
            'GATEWAY',
            title: "Virtual Account / QRIS",
            subtitle: "Bayar melalui Bank Transfer\natau E-Wallet.",
            icon: FontAwesomeIcons.creditCard,
            enabled: true,
          ),
        ],
      ),
    ));
  }

  /// Helper untuk kartu opsi pembayaran
  Widget _buildPaymentOptionCard(
    String value, {
    required String title,
    required String subtitle,
    required IconData icon,
    bool enabled = true,
    String? secondaryText,
    Color? secondaryColor,
  }) {
    return GestureDetector(
      onTap: enabled ? () => controller.selectPaymentMethod(value) : null,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: controller.selectedPaymentMethod.value == value ? AppColors.primary.withOpacity(0.1) : AppColors.background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: controller.selectedPaymentMethod.value == value ? AppColors.primary : AppColors.greyLight,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            FaIcon(icon, size: 24, color: enabled ? AppColors.primary : AppColors.textLight),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: enabled ? AppColors.textDark : AppColors.textLight,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        subtitle,
                        style: Get.textTheme.bodySmall?.copyWith(
                          color: enabled ? AppColors.textLight : AppColors.textLight.withOpacity(0.7),
                        ),
                      ),
                      if (secondaryText != null)
                        Text(
                          " ($secondaryText)",
                          style: Get.textTheme.bodySmall?.copyWith(
                            color: secondaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            if (controller.selectedPaymentMethod.value == value)
              const FaIcon(FontAwesomeIcons.solidCircleCheck, color: AppColors.primary),
          ],
        ),
      ),
    );
  }

  /// 4. Rincian Biaya (Didesain Ulang)
  Widget _buildPaymentSummary() {
    return Container(
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
          _buildSummaryRow("Subtotal Produk", controller.rupiahFormatter.format(controller.cartSubtotal.value)),
          const SizedBox(height: 12),
          _buildSummaryRow("Biaya Pengiriman", controller.rupiahFormatter.format(controller.shippingCost)),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.greyLight),
          const SizedBox(height: 12),
          _buildSummaryRow(
            "Total Pembayaran", 
            controller.rupiahFormatter.format(controller.grandTotal),
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

  /// 5. Tombol Bayar di Bawah (Didesain Ulang)
  Widget _buildBottomPayBar() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Obx(() => FilledButton(
        onPressed: controller.isPlacingOrder.value || controller.selectedPaymentMethod.value == null ? null : controller.placeOrder,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: controller.isPlacingOrder.value
            ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : const Text("Bayar Sekarang", style: TextStyle(fontWeight: FontWeight.bold)),
      )),
    );
  }

  /// Helper untuk judul section
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Get.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: AppColors.textDark,
      ),
    );
  }
}