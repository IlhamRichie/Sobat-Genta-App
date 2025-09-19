// lib/app/modules/wallet_top_up/views/wallet_top_up_view.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../theme/app_colors.dart';
import '../controllers/wallet_top_up_controller.dart';

class WalletTopUpView extends GetView<WalletTopUpController> {
  const WalletTopUpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Top Up Genta Wallet"),
      ),
      bottomNavigationBar: _buildBottomButton(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Masukkan Nominal Top Up",
                style: Get.textTheme.titleLarge?.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 16),
              _buildAmountForm(),
              const SizedBox(height: 8),
              Text(
                "Minimum Top Up: Rp 10.000",
                style: Get.textTheme.bodySmall?.copyWith(color: AppColors.textLight),
              ),
              const SizedBox(height: 24),
              Text(
                "Pilih Cepat",
                style: Get.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildQuickChips(),
            ],
          ),
        ),
      ),
    );
  }

  /// Form Input Jumlah
  Widget _buildAmountForm() {
    return TextFormField(
      controller: controller.amountC,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      style: Get.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        prefixText: "Rp ",
        prefixStyle: Get.textTheme.headlineMedium?.copyWith(color: AppColors.textLight),
        labelText: "Jumlah Top Up",
        labelStyle: Get.textTheme.bodyLarge,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (v) => (v == null || v.isEmpty) ? "Wajib diisi" : null,
    );
  }

  /// Chip Pilihan Cepat (sama seperti Invest Form)
  Widget _buildQuickChips() {
    return Wrap(
      spacing: 12.0,
      runSpacing: 8.0,
      children: [
        InputChip(label: const Text("Rp 50.000"), onPressed: () => controller.setAmountFromChip(50000)),
        InputChip(label: const Text("Rp 100.000"), onPressed: () => controller.setAmountFromChip(100000)),
        InputChip(label: const Text("Rp 250.000"), onPressed: () => controller.setAmountFromChip(250000)),
        InputChip(label: const Text("Rp 500.000"), onPressed: () => controller.setAmountFromChip(500000)),
        InputChip(label: const Text("Rp 1.000.000"), onPressed: () => controller.setAmountFromChip(1000000)),
      ],
    );
  }

  /// Tombol CTA Bawah
  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Obx(() => FilledButton(
            onPressed: controller.isLoading.value ? null : controller.submitTopUpRequest,
            child: controller.isLoading.value
                ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white))
                : const Text("Lanjut ke Pembayaran"),
          )),
    );
  }
}