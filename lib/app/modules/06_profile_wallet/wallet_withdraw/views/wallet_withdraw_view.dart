// lib/app/modules/wallet_withdraw/views/wallet_withdraw_view.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../theme/app_colors.dart';
import '../controllers/wallet_withdraw_controller.dart';

class WalletWithdrawView extends GetView<WalletWithdrawController> {
  const WalletWithdrawView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      bottomNavigationBar: _buildBottomButton(),
      body: Obx(() {
        if (controller.isLoadingData.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBalanceCard(),
              const SizedBox(height: 24),
              _buildDestinationCard(),
              const SizedBox(height: 24),
              if (controller.primaryAccount.value != null)
                _buildAmountForm(),
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
        "Tarik Dana",
        style: Get.textTheme.headlineSmall?.copyWith(
          color: AppColors.textDark,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: false,
    );
  }

  /// Kartu 1: Saldo Saat Ini (Didesain Ulang)
  Widget _buildBalanceCard() {
    return Container(
      width: double.infinity,
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
            "Saldo Tersedia",
            style: Get.textTheme.titleMedium?.copyWith(color: AppColors.textLight),
          ),
          const SizedBox(height: 8),
          Text(
            controller.rupiahFormatter.format(controller.availableBalance),
            style: Get.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  /// Kartu 2: Rekening Tujuan (Didesain Ulang)
  Widget _buildDestinationCard() {
    if (controller.primaryAccount.value == null) {
      return _buildNoAccountWarning();
    }
    
    final account = controller.primaryAccount.value!;
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Tujuan Penarikan (Utama)", style: Get.textTheme.bodyMedium?.copyWith(color: AppColors.textLight)),
              TextButton(
                onPressed: controller.goToManageAccounts,
                child: const Text("Ganti"),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const FaIcon(FontAwesomeIcons.buildingColumns, size: 24, color: AppColors.primary),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(account.bankName.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(account.accountNumber, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Peringatan jika belum ada rekening bank terdaftar (Didesain Ulang)
  Widget _buildNoAccountWarning() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.red.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FaIcon(FontAwesomeIcons.circleExclamation, size: 24, color: Colors.red.shade700),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Rekening Bank Belum Ada",
                  style: Get.textTheme.titleMedium?.copyWith(color: Colors.red.shade900, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "Anda harus mendaftarkan minimal 1 rekening bank dan mengaturnya sebagai 'Utama' sebelum dapat melakukan penarikan.",
            style: Get.textTheme.bodyMedium?.copyWith(color: AppColors.textDark),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: controller.goToManageAccounts,
            icon: const FaIcon(FontAwesomeIcons.plus, size: 16),
            label: const Text("Daftarkan Rekening Sekarang"),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ],
      ),
    );
  }

  /// Form 3: Jumlah Penarikan (Didesain Ulang)
  Widget _buildAmountForm() {
    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Jumlah Penarikan", style: Get.textTheme.titleMedium?.copyWith(color: AppColors.textDark, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildTextFormField(),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: controller.setMaxAmount,
              child: const Text(
                "Gunakan Semua Saldo",
                style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }

  /// Helper untuk TextFormField (Baru)
  Widget _buildTextFormField() {
    return TextFormField(
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
    );
  }

  /// Tombol CTA Bawah (Didesain Ulang)
  Widget _buildBottomButton() {
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
        onPressed: (controller.isSubmitting.value || !controller.canSubmitRequest)
            ? null 
            : controller.submitWithdrawalRequest,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
        ),
        child: controller.isSubmitting.value
            ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : const Text('Kirim Permintaan Penarikan', style: TextStyle(fontWeight: FontWeight.bold)),
      )),
    );
  }
}