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
    // Menggunakan WillPopScope untuk handle tombol back Android
    return WillPopScope(
      onWillPop: () async {
        controller.cancelAndGoHome();
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          children: [
            // 1. BACKGROUND DECORATION
            Positioned(
              top: -80,
              right: -60,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              top: 100,
              left: -80,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // 2. MAIN CONTENT
            SafeArea(
              child: Column(
                children: [
                  _buildCustomAppBar(),
                  
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildExpiryTimerCard(),
                          const SizedBox(height: 24),
                          
                          _buildPaymentDetailsCard(),
                          const SizedBox(height: 24),
                          
                          _buildPaymentMethodsSection(),
                          const SizedBox(height: 100), // Bottom padding
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 3. BOTTOM BUTTONS (Floating)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildBottomActions(),
            ),
          ],
        ),
      ),
    );
  }

  /// Custom AppBar
  Widget _buildCustomAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          IconButton(
            onPressed: controller.cancelAndGoHome,
            icon: const FaIcon(FontAwesomeIcons.xmark, color: AppColors.textDark),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              elevation: 0,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              "Selesaikan Pembayaran",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 1. Timer Hero Section
  Widget _buildExpiryTimerCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0), // Soft Orange background
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          const Text(
            "Selesaikan pembayaran dalam",
            style: TextStyle(color: Color(0xFFE65100), fontSize: 13),
          ),
          const SizedBox(height: 8),
          Obx(() => Text(
            controller.countdownText.value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Color(0xFFE65100),
              fontFamily: 'monospace', // Monospace agar angka tidak goyang
              letterSpacing: 2,
            ),
          )),
          const SizedBox(height: 8),
          Text(
            "Batas Akhir: ${DateFormat('dd MMM yyyy, HH:mm').format(controller.transaction.expiryTime)}",
            style: TextStyle(color: const Color(0xFFE65100).withOpacity(0.7), fontSize: 12),
          ),
        ],
      ),
    );
  }

  /// 2. Payment Details (VA, Total, dll)
  Widget _buildPaymentDetailsCard() {
    final trx = controller.transaction;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Bank
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.greyLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const FaIcon(FontAwesomeIcons.buildingColumns, size: 20, color: AppColors.textDark),
                // Bisa diganti logo bank jika ada asset-nya:
                // child: Image.asset('assets/logos/${trx.paymentProvider.toLowerCase()}.png', width: 24),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Metode Pembayaran", style: TextStyle(fontSize: 12, color: AppColors.textLight)),
                  Text(
                    trx.paymentProvider.toUpperCase(), // e.g., "BCA VIRTUAL ACCOUNT"
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDark),
                  ),
                ],
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Divider(height: 1, color: AppColors.greyLight),
          ),
          
          // Nomor VA (Highlight)
          const Text("Nomor Virtual Account", style: TextStyle(fontSize: 13, color: AppColors.textLight)),
          const SizedBox(height: 8),
          _buildCopyableField(trx.paymentCode, isHighlighted: true),
          
          const SizedBox(height: 20),
          
          // Total Bayar (Highlight)
          const Text("Total Pembayaran", style: TextStyle(fontSize: 13, color: AppColors.textLight)),
          const SizedBox(height: 8),
          _buildCopyableField(rupiahFormatter.format(trx.amount), rawValue: trx.amount.toString().replaceAll('.', ''), isHighlighted: true),
          
          const SizedBox(height: 20),
          
          // ID Transaksi
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("ID Transaksi", style: TextStyle(fontSize: 13, color: AppColors.textLight)),
              Text(trx.transactionId, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark)),
            ],
          ),
        ],
      ),
    );
  }

  /// Helper untuk field yang bisa dicopy
  Widget _buildCopyableField(String displayValue, {String? rawValue, bool isHighlighted = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.greyLight.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: isHighlighted ? Border.all(color: AppColors.primary.withOpacity(0.3)) : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            displayValue,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isHighlighted ? AppColors.primary : AppColors.textDark,
            ),
          ),
          InkWell(
            onTap: () {
              Clipboard.setData(ClipboardData(text: rawValue ?? displayValue)).then((_) {
                showTopSnackBar(
                  Overlay.of(Get.context!),
                  const CustomSnackBar.success(message: "Berhasil disalin ke clipboard!"),
                );
              });
            },
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text("Salin", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textLight)),
                  const SizedBox(width: 4),
                  Icon(Icons.copy_rounded, size: 16, color: AppColors.textLight),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 3. Instructions List
  Widget _buildPaymentMethodsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Cara Pembayaran",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildStepItem(1, "Buka aplikasi M-Banking atau ATM Anda."),
              _buildStepItem(2, "Pilih menu 'Transfer' atau 'Pembayaran'."),
              _buildStepItem(3, "Masukkan Nomor Virtual Account yang tertera di atas."),
              _buildStepItem(4, "Pastikan nominal tagihan sesuai dengan Total Pembayaran."),
              _buildStepItem(5, "Konfirmasi dan selesaikan pembayaran."),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStepItem(int number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number.toString(),
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, color: AppColors.textDark, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  /// 4. Fixed Bottom Action Buttons
  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 50,
            child: Obx(() => ElevatedButton(
              onPressed: controller.isCheckingStatus.value ? null : controller.checkPaymentStatus,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: controller.isCheckingStatus.value
                  ? const SizedBox(
                      width: 24, height: 24,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Text(
                      "Saya Sudah Membayar",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                    ),
            )),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton(
              onPressed: controller.cancelAndGoHome,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textLight,
                side: const BorderSide(color: AppColors.greyLight),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text("Cek Nanti / Kembali ke Beranda"),
            ),
          ),
        ],
      ),
    );
  }
}