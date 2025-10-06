// lib/app/modules/payment_success/views/payment_success_view.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../theme/app_colors.dart';
import '../controllers/payment_success_controller.dart';

class PaymentSuccessView extends GetView<PaymentSuccessController> {
  PaymentSuccessView({Key? key}) : super(key: key);

  final rupiahFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.goToHome();
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- Ikon Keberhasilan (Didesain Ulang) ---
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: FaIcon(
                        FontAwesomeIcons.circleCheck,
                        size: 64,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // --- Teks Keberhasilan ---
                  Text(
                    "Pembayaran Berhasil!",
                    style: Get.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Terima kasih, saldo Anda telah berhasil ditambahkan.",
                    style: Get.textTheme.bodyLarge?.copyWith(
                      color: AppColors.textLight,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  
                  // --- Ringkasan Transaksi (Didesain Ulang) ---
                  _buildSummaryCard(),
                  
                  const SizedBox(height: 40),
                  
                  // --- Tombol Aksi (Didesain Ulang) ---
                  FilledButton(
                    onPressed: controller.goToWallet,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 4,
                    ),
                    child: const Text(
                      "Lihat Dompet Saya",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: controller.goToHome,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textLight,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: AppColors.greyLight),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text("Kembali ke Beranda"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  /// Widget Kartu Ringkasan Transaksi (Baru)
  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(24),
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
          _buildSummaryRow("Jumlah Top Up", rupiahFormatter.format(controller.transaction.amount)),
          const SizedBox(height: 12),
          const Divider(height: 1, thickness: 1, color: AppColors.greyLight),
          const SizedBox(height: 12),
          _buildSummaryRow("Metode", controller.transaction.paymentProvider),
          const SizedBox(height: 12),
          const Divider(height: 1, thickness: 1, color: AppColors.greyLight),
          const SizedBox(height: 12),
          _buildSummaryRow("ID Transaksi", controller.transaction.transactionId),
        ],
      ),
    );
  }
  
  /// Widget Baris Ringkasan (Disesuaikan)
  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Get.textTheme.bodyMedium?.copyWith(
            color: AppColors.textLight,
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: Get.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
        ),
      ],
    );
  }
}