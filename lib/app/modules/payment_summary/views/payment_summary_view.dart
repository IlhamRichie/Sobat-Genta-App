import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../data/models/expert_model.dart';
import '../controllers/payment_summary_controller.dart';

// (Konstanta warna tema konsisten)
const kPrimaryDarkGreen = Color(0xFF3A8A40);
const kLightGreenBlob = Color(0xFFEAF4EB);
const kDarkTextColor = Color(0xFF1B2C1E);
const kBodyTextColor = Color(0xFF5A6A5C);
const kTextFieldBorder = Color(0xFFD9D9D9);

class PaymentSummaryView extends GetView<PaymentSummaryController> {
  const PaymentSummaryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightGreenBlob, // Background abu-abu muda
      appBar: AppBar(
        title: const Text('Checkout',
            style: TextStyle(color: kDarkTextColor, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: kDarkTextColor),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. Ringkasan Pesanan (Kartu Pakar) ---
            _buildSectionTitle('Ringkasan Pesanan'),
            const SizedBox(height: 12),
            _buildOrderSummary(controller.expertData)
                .animate().fadeIn(delay: 300.ms).slideX(begin: -0.2),

            // --- 2. Metode Pembayaran (Reaktif) ---
            const SizedBox(height: 24),
            _buildSectionTitle('Metode Pembayaran'),
            const SizedBox(height: 12),
            _buildPaymentMethodSection()
                .animate().fadeIn(delay: 500.ms),

            // --- 3. Rincian Pembayaran (Reaktif) ---
            const SizedBox(height: 24),
            _buildSectionTitle('Rincian Pembayaran'),
            const SizedBox(height: 12),
            _buildPaymentDetails()
                .animate().fadeIn(delay: 700.ms),
                
          ],
        ),
      ),
      // --- Tombol Sticky di Bawah ---
      bottomNavigationBar: _buildStickyCheckoutButton(),
    );
  }

  // --- Helper Widgets (Best Practice) ---

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kDarkTextColor),
    );
  }

  // 1. Kartu Ringkasan Pesanan
  Widget _buildOrderSummary(ExpertModel expert) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kTextFieldBorder.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(expert.imageUrl),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expert.name,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kDarkTextColor),
                ),
                const SizedBox(height: 4),
                Text(
                  expert.specialtyName,
                  style: const TextStyle(fontSize: 14, color: kBodyTextColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 2. Tombol Pilihan Metode Pembayaran (Reaktif)
  Widget _buildPaymentMethodSection() {
    return InkWell(
      onTap: controller.openPaymentMethodSheet,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: kTextFieldBorder.withOpacity(0.5)),
        ),
        child: Obx(() { // Obx agar UI reaktif
          final method = controller.selectedMethod.value;
          
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (method == null)
                // Tampilan jika belum memilih
                const Text(
                  'Pilih Metode Pembayaran',
                  style: TextStyle(fontSize: 16, color: kBodyTextColor, fontWeight: FontWeight.w500),
                )
              else
                // Tampilan jika sudah memilih
                Row(
                  children: [
                    Image.asset(method.logoAsset, width: 30, height: 30),
                    const SizedBox(width: 12),
                    Text(
                      method.name,
                      style: const TextStyle(fontSize: 16, color: kDarkTextColor, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              
              const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: kBodyTextColor),
            ],
          );
        }),
      ),
    );
  }

  // 3. Kartu Rincian Biaya (Reaktif)
  Widget _buildPaymentDetails() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kTextFieldBorder.withOpacity(0.5)),
      ),
      child: Obx(() { // Obx agar harga reaktif
        return Column(
          children: [
            _buildDetailRow('Subtotal Konsultasi', 'Rp ${controller.subtotal.value.toStringAsFixed(0)}'),
            const SizedBox(height: 12),
            _buildDetailRow('Biaya Admin', 'Rp ${controller.adminFee.toStringAsFixed(0)}'),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Divider(color: kTextFieldBorder, height: 1),
            ),
            _buildDetailRow(
              'Total Pembayaran',
              'Rp ${controller.total.value.toStringAsFixed(0)}',
              isTotal: true,
            ),
          ],
        );
      }),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: isTotal ? kDarkTextColor : kBodyTextColor,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            color: isTotal ? kPrimaryDarkGreen : kDarkTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // 4. Tombol Bawah (Sticky)
  Widget _buildStickyCheckoutButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 15)],
      ),
      child: ElevatedButton(
        onPressed: controller.onChoosePaymentPressed, // Aksi utama
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryDarkGreen,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Obx(() { // Obx agar teks tombol reaktif
          return Text(
            'Bayar Sekarang (Rp ${controller.total.value.toStringAsFixed(0)})',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          );
        }),
      ),
    ).animate().fadeIn(delay: 900.ms).slideY(begin: 0.5);
  }
}