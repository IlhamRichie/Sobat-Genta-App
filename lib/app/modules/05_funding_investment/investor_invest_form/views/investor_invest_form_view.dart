// lib/app/modules/investor_invest_form/views/investor_invest_form_view.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../theme/app_colors.dart';
import '../controllers/investor_invest_form_controller.dart';

class InvestorInvestFormView extends GetView<InvestorInvestFormController> {
  const InvestorInvestFormView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      bottomNavigationBar: _buildSubmitButtonSection(),
      body: Obx(() {
        if (controller.isLoadingPage.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("Ringkasan Proyek"),
              const SizedBox(height: 12),
              _buildProjectSummary(),
              const SizedBox(height: 24),
              _buildSectionTitle("Saldo Dompet"),
              const SizedBox(height: 12),
              _buildWalletSummary(),
              const SizedBox(height: 24),
              _buildSectionTitle("Jumlah Investasi"),
              const SizedBox(height: 12),
              _buildAmountForm(),
              const SizedBox(height: 16),
              _buildQuickChips(),
              const SizedBox(height: 24),
            ],
          ),
        );
      }),
    );
  }

  /// AppBar Kustom
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: BackButton(
        color: AppColors.textDark,
        onPressed: () => Get.back(),
      ),
      title: Text(
        "Investasi",
        style: Get.textTheme.headlineSmall?.copyWith(
          color: AppColors.textDark,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: false,
    );
  }
  
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Get.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: AppColors.textDark,
      ),
    );
  }

  /// 1. Ringkasan Proyek
  Widget _buildProjectSummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
          Text("Anda berinvestasi pada:", style: Get.textTheme.bodyMedium?.copyWith(color: AppColors.textLight)),
          const SizedBox(height: 4),
          Text(
            controller.project.title,
            style: Get.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const FaIcon(FontAwesomeIcons.bullseye, color: AppColors.primary, size: 20),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Sisa Kebutuhan Dana", style: Get.textTheme.bodySmall?.copyWith(color: AppColors.textLight)),
                  const SizedBox(height: 4),
                  Text(
                    controller.rupiahFormatter.format(controller.remainingNeeded),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDark),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 2. Ringkasan Dompet
  Widget _buildWalletSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.3))
      ),
      child: Row(
        children: [
          const FaIcon(FontAwesomeIcons.wallet, color: AppColors.primary, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Saldo Dompet Anda", style: Get.textTheme.bodyMedium?.copyWith(color: AppColors.textLight)),
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
        validator: (v) => (v == null || v.isEmpty) ? "Wajib diisi" : null,
      ),
    );
  }

  /// 4. Chip Pilihan Cepat (Diperbaiki)
  Widget _buildQuickChips() {
    final List<double> quickAmounts = [1000000, 5000000, 10000000];
    final rupiahFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Wrap(
      spacing: 12.0,
      runSpacing: 12.0,
      children: [
        ...quickAmounts.map((amount) => GestureDetector(
          onTap: () => controller.setAmountFromChip(amount),
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
        )).toList(),
        // Tombol maksimal
        GestureDetector(
          onTap: controller.setMaxAmount,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.2),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              "Maksimal",
              style: Get.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Tombol Submit di Bawah
  Widget _buildSubmitButtonSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Obx(() => FilledButton(
        onPressed: controller.isLoading.value ? null : controller.submitInvestment,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
        ),
        child: controller.isLoading.value
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
            : const Text(
                'Konfirmasi Investasi',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
      )),
    );
  }
}