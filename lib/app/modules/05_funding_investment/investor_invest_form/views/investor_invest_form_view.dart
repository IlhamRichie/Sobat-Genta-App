// lib/app/modules/investor_invest_form/views/investor_invest_form_view.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../theme/app_colors.dart';
import '../controllers/investor_invest_form_controller.dart';

class InvestorInvestFormView extends GetView<InvestorInvestFormController> {
  const InvestorInvestFormView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Formulir Investasi"),
      ),
      bottomNavigationBar: _buildSubmitButtonSection(),
      body: Obx(() {
        if (controller.isLoadingPage.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProjectSummary(),
              const Divider(height: 32),
              _buildWalletSummary(),
              const SizedBox(height: 24),
              _buildAmountForm(),
              const SizedBox(height: 16),
              _buildQuickChips(),
            ],
          ),
        );
      }),
    );
  }

  /// 1. Ringkasan Proyek
  Widget _buildProjectSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Anda berinvestasi pada:", style: Get.textTheme.bodyMedium),
        Text(
          controller.project.title,
          style: Get.textTheme.titleLarge?.copyWith(fontSize: 20),
        ),
        const SizedBox(height: 12),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const FaIcon(FontAwesomeIcons.bullseye, color: AppColors.textLight),
          title: Text("Sisa Kebutuhan Dana"),
          subtitle: Text(
            controller.rupiahFormatter.format(controller.remainingNeeded),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDark),
          ),
        ),
      ],
    );
  }

  /// 2. Ringkasan Dompet
  Widget _buildWalletSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.2))
      ),
      child: Row(
        children: [
          const FaIcon(FontAwesomeIcons.wallet, color: AppColors.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Saldo Dompet Anda", style: Get.textTheme.bodyMedium),
                Text(
                  controller.rupiahFormatter.format(controller.availableBalance),
                  style: Get.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  /// 3. Form Input Jumlah
  Widget _buildAmountForm() {
    return Form(
      key: controller.formKey,
      child: TextFormField(
        controller: controller.amountC,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: Get.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          prefixText: "Rp ",
          prefixStyle: Get.textTheme.headlineMedium?.copyWith(color: AppColors.textLight),
          labelText: "Masukkan Jumlah Investasi",
          labelStyle: Get.textTheme.bodyLarge,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (v) => (v == null || v.isEmpty) ? "Wajib diisi" : null,
      ),
    );
  }

  /// 4. Chip Pilihan Cepat
  Widget _buildQuickChips() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: [
        InputChip(label: const Text("Rp 1 Juta"), onPressed: () => controller.setAmountFromChip(1000000)),
        InputChip(label: const Text("Rp 5 Juta"), onPressed: () => controller.setAmountFromChip(5000000)),
        InputChip(label: const Text("Rp 10 Juta"), onPressed: () => controller.setAmountFromChip(10000000)),
        InputChip(
          label: const Text("Maksimal"),
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
          onPressed: controller.setMaxAmount,
        ),
      ],
    );
  }

  /// Tombol Submit di Bawah
  Widget _buildSubmitButtonSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Obx(() => FilledButton(
            onPressed: controller.isLoading.value ? null : controller.submitInvestment,
            child: controller.isLoading.value
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                  )
                : const Text('Konfirmasi Investasi'),
          )),
    );
  }
}