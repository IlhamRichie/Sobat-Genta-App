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
      backgroundColor: const Color(0xFFF5F6F8), // Background light grey
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Pembayaran",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      bottomNavigationBar: _buildBottomPayBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Alamat Pengiriman
            _buildSectionHeader("Alamat Pengiriman", icon: FontAwesomeIcons.locationDot),
            const SizedBox(height: 12),
            _buildAddressCard(),
            
            const SizedBox(height: 24),
            
            // 2. Ringkasan Produk
            _buildSectionHeader("Ringkasan Pesanan", icon: FontAwesomeIcons.bagShopping),
            const SizedBox(height: 12),
            _buildProductList(),
            
            const SizedBox(height: 24),
            
            // 3. Metode Pembayaran
            _buildSectionHeader("Metode Pembayaran", icon: FontAwesomeIcons.wallet),
            const SizedBox(height: 12),
            _buildPaymentOptions(),
            
            const SizedBox(height: 24),
            
            // 4. Rincian Biaya
            _buildSectionHeader("Rincian Biaya", icon: FontAwesomeIcons.receipt),
            const SizedBox(height: 12),
            _buildPaymentSummary(),
            
            // Space extra biar ga ketutup bottom bar kalo di scroll mentok
            const SizedBox(height: 100), 
          ],
        ),
      ),
    );
  }

  /// Header Section dengan Icon Kecil
  Widget _buildSectionHeader(String title, {required IconData icon}) {
    return Row(
      children: [
        FaIcon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2D3436),
          ),
        ),
      ],
    );
  }

  Widget _buildAddressCard() {
    final addr = controller.selectedAddress;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Dikirim ke:",
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  addr.label.toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.primary, 
                    fontWeight: FontWeight.bold, 
                    fontSize: 10
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 8),
          Text(
            addr.recipientName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            addr.phoneNumber,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
          const Divider(height: 24),
          Text(
            "${addr.fullAddress}, ${addr.city}, ${addr.postalCode}",
            style: const TextStyle(color: Colors.black87, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildProductList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.cartItems.length,
        separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey.shade100),
        itemBuilder: (context, index) {
          final item = controller.cartItems[index];
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey.shade100,
                    child: (item.product.imageUrl != null && item.product.imageUrl!.isNotEmpty)
                        ? Image.network(item.product.imageUrl!, fit: BoxFit.cover)
                        : const Center(child: Icon(Icons.image, color: Colors.grey)),
                  ),
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
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${item.quantity} x ${controller.rupiahFormatter.format(item.product.price)}",
                        style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Text(
                  controller.rupiahFormatter.format(item.subTotal),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPaymentOptions() {
    return Obx(() => Column(
      children: [
        _paymentOptionTile(
          value: 'WALLET',
          title: "Genta Wallet",
          subtitle: "Saldo: ${controller.rupiahFormatter.format(controller.myWallet.value?.balance ?? 0)}",
          icon: FontAwesomeIcons.wallet,
          isEnabled: controller.canPayWithWallet,
          trailing: controller.canPayWithWallet 
              ? null 
              : const Text("Kurang", style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 12),
        _paymentOptionTile(
          value: 'GATEWAY',
          title: "Transfer Bank / QRIS",
          subtitle: "BCA, Mandiri, Gopay, OVO",
          icon: FontAwesomeIcons.buildingColumns,
          isEnabled: true,
        ),
      ],
    ));
  }

  Widget _paymentOptionTile({
    required String value,
    required String title,
    required String subtitle,
    required IconData icon,
    bool isEnabled = true,
    Widget? trailing,
  }) {
    bool isSelected = controller.selectedPaymentMethod.value == value;
    return GestureDetector(
      onTap: isEnabled ? () => controller.selectPaymentMethod(value) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isEnabled ? (isSelected ? AppColors.primary : Colors.grey.shade100) : Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: FaIcon(
                icon, 
                size: 18, 
                color: isEnabled ? (isSelected ? Colors.white : Colors.grey.shade600) : Colors.grey.shade400
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Opacity(
                opacity: isEnabled ? 1.0 : 0.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                  ],
                ),
              ),
            ),
            if (trailing != null) trailing,
            if (isSelected && trailing == null)
              const FaIcon(FontAwesomeIcons.circleCheck, color: AppColors.primary, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          _summaryRow("Subtotal Produk", controller.rupiahFormatter.format(controller.cartSubtotal.value)),
          const SizedBox(height: 12),
          _summaryRow("Biaya Layanan", "Rp 1.000"), // Contoh dummy fee
          const SizedBox(height: 12),
          _summaryRow("Ongkos Kirim", controller.rupiahFormatter.format(controller.shippingCost)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Divider(height: 1), // Pake package border kalo mau dashed beneran, ini solid aja cukup
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total Pembayaran", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Obx(() => Text(
                controller.rupiahFormatter.format(controller.grandTotal + 1000), // Ditambah fee dummy
                style: const TextStyle(
                  fontWeight: FontWeight.w800, 
                  fontSize: 18, 
                  color: AppColors.primary
                ),
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
      ],
    );
  }

  Widget _buildBottomPayBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: Obx(() => ElevatedButton(
            onPressed: (controller.isPlacingOrder.value || controller.selectedPaymentMethod.value == null) 
                ? null 
                : controller.placeOrder,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey.shade300,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: controller.isPlacingOrder.value
                ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                : const Text("Bayar Sekarang", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          )),
        ),
      ),
    );
  }
}