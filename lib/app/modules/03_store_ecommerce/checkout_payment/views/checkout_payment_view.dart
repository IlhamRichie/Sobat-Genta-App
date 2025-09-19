// lib/app/modules/checkout_payment/views/checkout_payment_view.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../theme/app_colors.dart';
import '../controllers/checkout_payment_controller.dart';

class CheckoutPaymentView extends GetView<CheckoutPaymentController> {
  const CheckoutPaymentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ringkasan Pembayaran"),
      ),
      bottomNavigationBar: _buildBottomPayBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Alamat Pengiriman"),
            _buildAddressCard(),
            const Divider(height: 24),
            _buildSectionTitle("Ringkasan Produk"),
            _buildProductList(),
            const Divider(height: 24),
            _buildSectionTitle("Metode Pembayaran"),
            _buildPaymentOptions(),
            const Divider(height: 24),
            _buildPaymentSummary(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: Text(title, style: Get.textTheme.titleLarge?.copyWith(fontSize: 18)),
    );
  }

  /// 1. Tampilan Alamat (Read-only)
  Widget _buildAddressCard() {
    final addr = controller.selectedAddress;
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

  /// 2. Daftar Produk (Read-only)
  Widget _buildProductList() {
    return ListView.builder(
      itemCount: controller.cartItems.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (ctx, index) {
        final item = controller.cartItems[index];
        return ListTile(
          leading: Container(
            width: 50, height: 50,
            decoration: BoxDecoration(color: AppColors.greyLight, borderRadius: BorderRadius.circular(8)),
            // TODO: Gambar produk
          ),
          title: Text(item.product.name, maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Text("${item.quantity} item x ${controller.rupiahFormatter.format(item.product.price)}"),
          trailing: Text(
            controller.rupiahFormatter.format(item.subTotal),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }

  /// 3. Opsi Pembayaran (Dinamis)
  Widget _buildPaymentOptions() {
    return Obx(() => Column(
      children: [
        // Opsi 1: Dompet Genta
        RadioListTile<String>(
          value: 'WALLET',
          groupValue: controller.selectedPaymentMethod.value,
          onChanged: controller.isLoadingWallet.value
              ? null // Jangan biarkan diubah saat loading
              : (val) => controller.selectPaymentMethod(val),
          title: const Text("Genta Wallet", style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: controller.isLoadingWallet.value
              ? const Text("Memeriksa saldo...")
              : Text(
                  "Saldo: ${controller.rupiahFormatter.format(controller.myWallet.value?.balance ?? 0)}",
                  style: TextStyle(
                    color: controller.canPayWithWallet ? Colors.green.shade700 : Colors.red.shade700,
                  ),
                ),
          secondary: const FaIcon(FontAwesomeIcons.wallet, color: AppColors.primary),
        ),
        // Opsi 2: Payment Gateway
        RadioListTile<String>(
          value: 'GATEWAY',
          groupValue: controller.selectedPaymentMethod.value,
          onChanged: (val) => controller.selectPaymentMethod(val),
          title: const Text("Virtual Account / QRIS", style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: const Text("Bayar melalui Bank Transfer atau E-Wallet."),
          secondary: const FaIcon(FontAwesomeIcons.creditCard, color: AppColors.textLight),
        ),
      ],
    ));
  }

  /// 4. Rincian Biaya
  Widget _buildPaymentSummary() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          _buildSummaryRow("Subtotal Produk", controller.rupiahFormatter.format(controller.cartSubtotal.value)),
          _buildSummaryRow("Biaya Pengiriman (Flat)", controller.rupiahFormatter.format(controller.shippingCost)),
          const Divider(height: 24),
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
     return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Get.textTheme.bodyMedium?.copyWith(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            fontSize: isTotal ? 16 : 14,
          )),
          Text(value, style: Get.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: isTotal ? 18 : 16,
          )),
        ],
      ),
    );
  }

  /// 5. Tombol Bayar di Bawah
  Widget _buildBottomPayBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Obx(() => FilledButton(
        onPressed: controller.isPlacingOrder.value ? null : controller.placeOrder,
        child: controller.isPlacingOrder.value
            ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white))
            : const Text("Bayar Sekarang"),
      )),
    );
  }
}