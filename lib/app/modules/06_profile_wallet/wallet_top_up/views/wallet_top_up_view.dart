// lib/app/modules/wallet_top_up/views/wallet_top_up_view.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Tambahkan ini
import '../../../../theme/app_colors.dart';
import '../controllers/wallet_top_up_controller.dart';

class WalletTopUpView extends GetView<WalletTopUpController> {
  WalletTopUpView({Key? key}) : super(key: key);

  // Deklarasi formatter di sini karena tidak ada di controller
  final rupiahFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      bottomNavigationBar: _buildBottomButton(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(
                "Masukkan Nominal Top Up",
                style: Get.textTheme.titleLarge?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 24),
              _buildAmountForm(),
              const SizedBox(height: 16),
              Text(
                "Minimum Top Up: ${rupiahFormatter.format(controller.minTopUp)}",
                style: Get.textTheme.bodySmall?.copyWith(color: AppColors.textLight),
              ),
              const SizedBox(height: 32),
              Text(
                "Pilih Cepat",
                style: Get.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 16),
              _buildQuickChips(),
            ],
          ),
        ),
      ),
    );
  }

  /// AppBar Kustom (Konsisten dengan halaman lain)
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      title: Text(
        "Top Up",
        style: Get.textTheme.headlineSmall?.copyWith(
          color: AppColors.textDark,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: false,
    );
  }

  /// Form Input Jumlah (Didesain Ulang)
  Widget _buildAmountForm() {
    return TextFormField(
      controller: controller.amountC,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      textAlign: TextAlign.center,
      style: Get.textTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 36,
        color: AppColors.primary,
      ),
      decoration: InputDecoration(
        prefixText: "Rp ",
        prefixStyle: Get.textTheme.headlineMedium?.copyWith(
          color: AppColors.primary,
          fontSize: 36,
        ),
        hintText: "0",
        hintStyle: Get.textTheme.headlineMedium?.copyWith(
          color: AppColors.textLight.withOpacity(0.5),
          fontSize: 36,
        ),
        border: InputBorder.none,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary, width: 2.0),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.greyLight),
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2.0),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 8),
      ),
      // Validasi sekarang sudah ada di controller, jadi cukup dipanggil
      validator: (v) {
        if (v == null || v.isEmpty) return "Wajib diisi";
        if (double.tryParse(v)! < controller.minTopUp) return "Minimum top up Rp 10.000";
        return null;
      },
      // Hapus onChanged karena tidak ada metode updateAmountText di controller
    );
  }

  /// Chip Pilihan Cepat (Disesuaikan agar tidak reaktif)
  Widget _buildQuickChips() {
    final List<double> quickAmounts = [50000, 100000, 250000, 500000, 1000000];
    
    return Wrap(
      spacing: 12.0,
      runSpacing: 12.0,
      children: [
        for (var amount in quickAmounts)
          GestureDetector(
            onTap: () {
              // Panggil metode yang sudah ada di controller
              controller.setAmountFromChip(amount);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.greyLight,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.greyLight.withOpacity(0.2),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                rupiahFormatter.format(amount),
                style: Get.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
            ),
          ),
      ],
    );
  }

  /// Tombol CTA Bawah (Disesuaikan dengan controller orisinal)
  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.greyLight)),
      ),
      child: Obx(() => FilledButton(
        onPressed: controller.isLoading.value ? null : () => controller.submitTopUpRequest(),
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: controller.isLoading.value
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
            : Text(
                "Lanjut ke Pembayaran",
                style: Get.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
      )),
    );
  }
}