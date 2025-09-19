// lib/app/modules/payment_success/views/payment_success_view.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../theme/app_colors.dart';
import '../controllers/payment_success_controller.dart';

class PaymentSuccessView extends GetView<PaymentSuccessController> {
  const PaymentSuccessView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.goToHome(); // Paksa ke Home jika tekan back
        return false;
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
                  const Icon(FontAwesomeIcons.circleCheck, size: 100, color: Colors.green),
                  const SizedBox(height: 24),
                  Text(
                    "Top Up Berhasil!",
                    style: Get.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Saldo Anda telah berhasil ditambahkan.",
                    style: Get.textTheme.bodyLarge?.copyWith(color: AppColors.textLight),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  // Ringkasan
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _buildSummaryRow("Jumlah Top Up", controller.rupiahFormatter.format(controller.transaction.amount)),
                        _buildSummaryRow("Metode", controller.transaction.paymentProvider),
                        _buildSummaryRow("ID Transaksi", controller.transaction.transactionId),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),
                  // Tombol Aksi
                  FilledButton(
                    onPressed: controller.goToWallet, // Arahkan ke Dompet
                    child: const Text("Lihat Dompet Saya"),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: controller.goToHome,
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
  
   Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textLight)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
          ),
        ],
      ),
    );
  }
}