import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../theme/app_colors.dart';
import '../controllers/order_confirmation_controller.dart';

class OrderConfirmationView extends GetView<OrderConfirmationController> {
  const OrderConfirmationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Bikin status bar jadi terang biar bersih
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    // Cegah tombol back fisik
    return WillPopScope(
      onWillPop: () async {
        controller.goToHome();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40), // Spacer atas
                _buildSuccessAnimation(),
                const SizedBox(height: 32),
                
                Text(
                  "Pembayaran Berhasil!",
                  style: Get.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  "Terima kasih, Sobat Genta!\nPesanan Anda telah kami terima dan akan segera diproses oleh penjual.",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade500,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 40),
                _buildOrderReceiptCard(),
                
                const SizedBox(height: 50),
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Icon Sukses dengan Efek Ring (Lebih Mewah)
  Widget _buildSuccessAnimation() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Ring Luar (Transparan Pudar)
        Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
        ),
        // Ring Tengah (Transparan)
        Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
        ),
        // Lingkaran Utama Solid
        Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 20,
                offset: Offset(0, 10),
              )
            ],
          ),
          child: const Center(
            child: FaIcon(FontAwesomeIcons.check, size: 40, color: Colors.white),
          ),
        ),
      ],
    );
  }

  /// Card Informasi Order (Style Struk Belanja)
  Widget _buildOrderReceiptCard() {
    final order = controller.confirmedOrder;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9), // Abu sangat muda
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Kode Pesanan", style: TextStyle(color: Colors.grey)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "#${order.orderId.substring(0, 8).toUpperCase()}", // Potong ID biar pendek
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(height: 1), // Garis putus-putus (Simulasi struk)
          const SizedBox(height: 16),
          _buildSummaryRow("Status", order.status, isStatus: true),
          const SizedBox(height: 12),
          _buildSummaryRow("Total Bayar", controller.rupiahFormatter.format(order.grandTotal), isBold: true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isStatus = false, bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
        Text(
          value,
          style: TextStyle(
            fontWeight: (isBold || isStatus) ? FontWeight.bold : FontWeight.normal,
            fontSize: isBold ? 18 : 14,
            color: isStatus 
                ? Colors.green.shade700 
                : (isBold ? AppColors.primary : Colors.black87),
          ),
        ),
      ],
    );
  }

  /// Tombol CTA
  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: controller.goToOrderHistory,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0, // Flat design modern
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text("Lacak Pesanan Saya", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton(
            onPressed: controller.goToHome,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.grey.shade600,
              side: BorderSide(color: Colors.grey.shade300),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text("Kembali ke Beranda", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }
}