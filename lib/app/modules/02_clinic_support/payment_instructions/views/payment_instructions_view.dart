// lib/app/modules/payment_instructions/views/payment_instructions_view.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../theme/app_colors.dart';
import '../controllers/payment_instructions_controller.dart';

class PaymentInstructionsView extends GetView<PaymentInstructionsController> {
  PaymentInstructionsView({Key? key}) : super(key: key);

  final rupiahFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    final trx = controller.transaction;

    return WillPopScope(
      onWillPop: () async {
        controller.cancelAndGoHome();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Instruksi Pembayaran"),
          leading: IconButton(
            icon: const Icon(FontAwesomeIcons.xmark),
            onPressed: controller.cancelAndGoHome,
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildExpiryHeader(),
              const SizedBox(height: 24),
              Text(
                "Segera selesaikan pembayaran untuk:",
                style: Get.textTheme.bodyMedium,
              ),
              Text(
                trx.paymentProvider, // Cth: "BCA Virtual Account"
                style: Get.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Divider(height: 32),
              
              // Detail Instruksi
              _buildInstructionRow("Nomor Virtual Account", trx.paymentCode, true),
              _buildInstructionRow("Total Pembayaran", rupiahFormatter.format(trx.amount), true),
              _buildInstructionRow("ID Transaksi", trx.transactionId, false),
              
              const SizedBox(height: 32),
              // Tombol Aksi
              FilledButton(
                onPressed: controller.checkPaymentStatus,
                child: Obx(() => controller.isCheckingStatus.value
                  ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white))
                  : const Text("Saya Sudah Bayar, Cek Status")),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Header Countdown Waktu
  Widget _buildExpiryHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade300)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Batas Akhir Pembayaran", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("Selesaikan sebelum kedaluwarsa"),
            ],
          ),
          Obx(() => Text(
            controller.countdownText.value,
            style: Get.textTheme.titleLarge?.copyWith(
              color: Colors.orange.shade800,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace'
            ),
          )),
        ],
      ),
    );
  }

  /// Baris untuk instruksi (Nomor VA, Total, dll)
  Widget _buildInstructionRow(String label, String value, bool isImportant) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Get.textTheme.bodySmall?.copyWith(color: AppColors.textLight)),
          Text(
            value,
            style: Get.textTheme.titleLarge?.copyWith(
              fontSize: isImportant ? 20 : 16,
              fontWeight: isImportant ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          if (isImportant)
            OutlinedButton.icon(
              onPressed: () { /* TODO: Copy to Clipboard */ },
              icon: const FaIcon(FontAwesomeIcons.copy, size: 14),
              label: Text("Salin Kode"),
            )
        ],
      ),
    );
  }
}