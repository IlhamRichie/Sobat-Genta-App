import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../controllers/payment_success_controller.dart';

// (Konstanta warna tema konsisten)
const kPrimaryDarkGreen = Color(0xFF3A8A40);
const kLightGreenBlob = Color(0xFFEAF4EB);
const kDarkTextColor = Color(0xFF1B2C1E);
const kBodyTextColor = Color(0xFF5A6A5C);
const kTextFieldBorder = Color(0xFFD9D9D9);

class PaymentSuccessView extends GetView<PaymentSuccessController> {
  const PaymentSuccessView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(), // Dorong konten ke tengah
              
              _buildCheckAnimation(), // Animasi Checkmark
              
              const SizedBox(height: 24),
              
              _buildHeader(), // Teks "Pembayaran Berhasil"
              
              const SizedBox(height: 32),
              
              _buildDetailsCard(), // Kartu Rincian
              
              const Spacer(), // Dorong tombol ke bawah
              
              _buildPrimaryButton(), // Tombol "Kirim Pesan"
              const SizedBox(height: 12),
              _buildSecondaryButton(), // Tombol "Kembali ke Beranda"
            ],
          ),
        ),
      ),
    );
  }

  // --- Helper Widgets (Best Practice) ---

  Widget _buildCheckAnimation() {
    return Center(
      child: Container(
        width: 100,
        height: 100,
        decoration: const BoxDecoration(
          color: kPrimaryDarkGreen,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.check_rounded,
          color: Colors.white,
          size: 60,
        ),
      ),
    ) // Animasi 'pop' saat muncul
    .animate().scale(
      delay: 200.ms,
      duration: 500.ms,
      curve: Curves.elasticOut,
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const Text(
          'Pembayaran Berhasil!',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: kDarkTextColor,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Rp ${controller.totalPayment.toStringAsFixed(0)}',
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: kPrimaryDarkGreen,
          ),
        ),
      ],
    ).animate().fadeIn(delay: 400.ms, duration: 400.ms);
  }

  Widget _buildDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: kLightGreenBlob.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kTextFieldBorder),
      ),
      child: Obx(() { // Obx untuk data reaktif (orderId, orderTime)
        return Column(
          children: [
            _buildDetailRow('No. Pesanan', controller.orderId.value),
            _buildDetailRow('Waktu Mulai', controller.orderTime.value),
            _buildDetailRow('Pakar', controller.expertData.name),
            _buildDetailRow('Metode Pembayaran', controller.paymentMethod.name,
                isLast: true),
          ],
        );
      }),
    ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2);
  }

  Widget _buildDetailRow(String label, String value, {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: kBodyTextColor, fontSize: 16)),
          Text(
            value,
            style: const TextStyle(
                color: kDarkTextColor, fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.end,
          ),
        ],
      ),
    );
  }

  Widget _buildPrimaryButton() {
    return ElevatedButton(
      onPressed: controller.goToChatRoom, // Aksi 1
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryDarkGreen,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: const Text(
        'Kirim Pesan Sekarang',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    ).animate().fadeIn(delay: 800.ms);
  }

  Widget _buildSecondaryButton() {
    return TextButton(
      onPressed: controller.goToHome, // Aksi 2
      child: const Text(
        'Kembali ke Beranda',
        style: TextStyle(
          color: kBodyTextColor,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ).animate().fadeIn(delay: 900.ms);
  }
}