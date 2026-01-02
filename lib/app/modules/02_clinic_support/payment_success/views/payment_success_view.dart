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
        body: Stack(
          children: [
            // 1. CONFETTI DECORATION (Static Placeholder)
            Positioned(
              top: -50,
              left: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              top: 100,
              right: -30,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // 2. MAIN CONTENT
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // --- Success Icon Animation ---
                      Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 15,
                                  offset: Offset(0, 5),
                                )
                              ],
                            ),
                            child: const Center(
                              child: FaIcon(
                                FontAwesomeIcons.check,
                                size: 50,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      // --- Success Text ---
                      Text(
                        "Pembayaran Berhasil!",
                        style: Get.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppColors.textDark,
                          fontSize: 26,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          "Hore! Saldo dompet Anda telah berhasil ditambahkan. Anda sudah bisa menggunakannya sekarang.",
                          style: Get.textTheme.bodyLarge?.copyWith(
                            color: AppColors.textLight,
                            fontSize: 15,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // --- Transaction Summary Card ---
                      _buildSummaryCard(),
                      
                      const SizedBox(height: 40),
                      
                      // --- Action Buttons ---
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: controller.goToWallet,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 0,
                            shadowColor: AppColors.primary.withOpacity(0.5),
                          ),
                          child: const Text(
                            "Lihat Dompet Saya",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: controller.goToHome,
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.textLight,
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                        ),
                        child: const Text("Kembali ke Beranda", style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// Summary Card
  Widget _buildSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.greyLight.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            "Total Top Up",
            style: TextStyle(color: AppColors.textLight, fontSize: 13),
          ),
          const SizedBox(height: 8),
          Text(
            rupiahFormatter.format(controller.transaction.amount),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          const Divider(height: 1, color: AppColors.greyLight),
          const SizedBox(height: 16),
          
          _buildSummaryRow("Metode", controller.transaction.paymentProvider),
          const SizedBox(height: 12),
          _buildSummaryRow("ID Transaksi", controller.transaction.transactionId),
          const SizedBox(height: 12),
          _buildSummaryRow("Waktu", DateFormat('dd MMM yyyy, HH:mm').format(DateTime.now())),
        ],
      ),
    );
  }
  
  /// Summary Row Helper
  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textLight,
            fontSize: 14,
          ),
        ),
        Flexible( // Prevent overflow for long text like Transaction ID
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
              fontSize: 14,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}