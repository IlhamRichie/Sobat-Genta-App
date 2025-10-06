// lib/app/modules/payment_instructions/views/payment_instructions_view.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../theme/app_colors.dart';
import '../controllers/payment_instructions_controller.dart';

class PaymentInstructionsView extends GetView<PaymentInstructionsController> {
  PaymentInstructionsView({Key? key}) : super(key: key);

  final rupiahFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.cancelAndGoHome();
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: _buildAppBar(),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildExpiryHeader(),
              const SizedBox(height: 24),
              Text(
                "Selesaikan pembayaran dalam waktu yang ditentukan untuk menjaga pesanan Anda. Salin detail di bawah dan lakukan pembayaran.",
                style: Get.textTheme.bodyMedium?.copyWith(color: AppColors.textLight),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              
              _buildDetailSection(),
              
              const SizedBox(height: 32),
              _buildPaymentInstructions(),
              
              const SizedBox(height: 40),
              // Tombol Aksi
              FilledButton(
                onPressed: controller.checkPaymentStatus,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Obx(() => controller.isCheckingStatus.value
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                    )
                  : const Text("Saya Sudah Bayar, Cek Status")),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: controller.cancelAndGoHome,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textLight,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: AppColors.greyLight),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text("Batalkan"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// AppBar Kustom
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: IconButton(
        icon: const FaIcon(FontAwesomeIcons.chevronLeft),
        onPressed: controller.cancelAndGoHome,
      ),
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

  /// Header Countdown Waktu (Didesain Ulang)
  Widget _buildExpiryHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "Batas Akhir Pembayaran",
            style: Get.textTheme.bodyMedium?.copyWith(color: AppColors.textLight, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Obx(() => Text(
            controller.countdownText.value,
            style: Get.textTheme.headlineMedium?.copyWith(
              color: AppColors.textDark,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
          )),
        ],
      ),
    );
  }

  /// Bagian Detail Pembayaran (Baru)
  Widget _buildDetailSection() {
    final trx = controller.transaction;
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            trx.paymentProvider,
            style: Get.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 12),
          _buildInstructionRow("Nomor Virtual Account", trx.paymentCode),
          _buildInstructionRow("Total Pembayaran", rupiahFormatter.format(trx.amount)),
          _buildInstructionRow("ID Transaksi", trx.transactionId),
        ],
      ),
    );
  }

  /// Widget baris instruksi yang disederhanakan
  Widget _buildInstructionRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Get.textTheme.bodySmall?.copyWith(color: AppColors.textLight)),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: Get.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              if (label != "ID Transaksi") // Tombol Salin hanya untuk VA dan Total
                TextButton.icon(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: value)).then((_) {
                      showTopSnackBar(
                        Overlay.of(Get.context!),
                        CustomSnackBar.success(message: "$label berhasil disalin!"),
                      );
                    });
                  },
                  icon: const FaIcon(FontAwesomeIcons.copy, size: 14),
                  label: const Text("Salin"),
                ),
            ],
          ),
        ],
      ),
    );
  }

  /// Bagian Metode Pembayaran (Baru)
  Widget _buildPaymentInstructions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Cara Pembayaran",
          style: Get.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 16),
        // Daftar langkah-langkah, bisa dari API atau hardcoded
        _buildInstructionStep("1. Buka aplikasi M-Banking atau E-Wallet Anda."),
        _buildInstructionStep("2. Pilih menu transfer atau pembayaran."),
        _buildInstructionStep("3. Masukkan Nomor Virtual Account di atas."),
        _buildInstructionStep("4. Pastikan nominal pembayaran sudah sesuai."),
        _buildInstructionStep("5. Selesaikan transaksi."),
      ],
    );
  }

  /// Widget untuk satu langkah instruksi
  Widget _buildInstructionStep(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text.split(".")[0] + ".",
            style: Get.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text.substring(text.indexOf(".") + 2),
              style: Get.textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}