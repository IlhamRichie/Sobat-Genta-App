// lib/app/modules/expert_payout/views/expert_payout_view.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../data/models/bank_account_model.dart';
import '../../../../theme/app_colors.dart';
import '../controllers/expert_payout_controller.dart';
import '../../../../routes/app_pages.dart';

class ExpertPayoutView extends GetView<ExpertPayoutController> {
  ExpertPayoutView({Key? key}) : super(key: key);

  final rupiahFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: controller.fetchPayoutData,
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildEarningsCard(),
                const SizedBox(height: 24),
                _buildBankAccountsSection(),
                const SizedBox(height: 24),
                _buildHistorySection(),
                const SizedBox(height: 24),
              ],
            ),
          );
        }),
      ),
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
        "Penghasilan & Payout",
        style: Get.textTheme.headlineSmall?.copyWith(
          color: AppColors.textDark,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: false,
    );
  }

  /// Kartu #1: Saldo Penghasilan (Didesain Ulang)
  Widget _buildEarningsCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Obx(() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Total Penghasilan (Dapat Ditarik)",
            style: Get.textTheme.titleMedium?.copyWith(
              color: Colors.white.withOpacity(0.8),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            rupiahFormatter.format(controller.wallet.value?.balance ?? 0),
            style: Get.textTheme.headlineLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: controller.canWithdraw ? controller.goToWithdrawForm : null,
            icon: const FaIcon(FontAwesomeIcons.moneyBillTransfer, size: 16),
            label: const Text("Tarik Dana (Withdraw)"),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
              disabledBackgroundColor: Colors.white.withOpacity(0.5),
              disabledForegroundColor: AppColors.textLight.withOpacity(0.5),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
            ),
          ),
          Obx(() => controller.accountList.isEmpty && !controller.isLoading.value
              ? Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Text(
                    "* Anda harus menambah rekening bank terlebih dahulu.",
                    style: Get.textTheme.bodySmall?.copyWith(color: Colors.white.withOpacity(0.8)),
                  ),
                )
              : const SizedBox.shrink()),
        ],
      )),
    );
  }

  /// Bagian #2: Rekening Bank Terdaftar (Didesain Ulang)
  Widget _buildBankAccountsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Rekening Bank Terdaftar"),
        const SizedBox(height: 12),
        Container(
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
          child: Obx(() {
            if (controller.accountList.isEmpty) {
              return _buildEmptyBankAccount();
            }
            final primaryAccount = controller.accountList.firstWhere(
              (acc) => acc.isPrimary,
              orElse: () => controller.accountList.first,
            );
            return _buildBankAccountCard(primaryAccount, true);
          }),
        ),
      ],
    );
  }
  
  /// Kartu untuk satu rekening bank (Didesain Ulang)
  Widget _buildBankAccountCard(BankAccountModel account, bool isPrimary) {
    return Column(
      children: [
        Row(
          children: [
            const CircleAvatar(
              backgroundColor: AppColors.greyLight,
              child: FaIcon(FontAwesomeIcons.buildingColumns, color: AppColors.textLight),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(account.bankName.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(account.accountHolderName, style: Get.textTheme.bodyMedium?.copyWith(color: AppColors.textLight)),
                  Text(account.accountNumber, style: Get.textTheme.bodyMedium?.copyWith(color: AppColors.textLight)),
                ],
              ),
            ),
            if (isPrimary)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "Utama",
                  style: Get.textTheme.bodySmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: controller.goToManageAccounts,
              child: const Text("Kelola Rekening", style: TextStyle(color: AppColors.primary)),
            ),
          ],
        ),
      ],
    );
  }

  /// Tampilan jika belum ada rekening bank (Didesain Ulang)
  Widget _buildEmptyBankAccount() {
    return Column(
      children: [
        const FaIcon(FontAwesomeIcons.buildingColumns, color: AppColors.greyLight, size: 48),
        const SizedBox(height: 16),
        const Text("Belum ada rekening bank terdaftar.", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(
          "Daftarkan rekening Anda untuk proses penarikan dana.",
          style: Get.textTheme.bodyMedium?.copyWith(color: AppColors.textLight),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        TextButton.icon(
          onPressed: controller.goToManageAccounts,
          icon: const FaIcon(FontAwesomeIcons.plus, size: 16),
          label: const Text("Tambah Rekening", style: TextStyle(fontWeight: FontWeight.bold)),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
      ],
    );
  }

  /// Placeholder Riwayat Transaksi (Didesain Ulang)
  Widget _buildHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Riwayat Payout"),
        const SizedBox(height: 12),
        Container(
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
            children: [
              _buildHistoryItem(
                title: "Penarikan Dana (Selesai)",
                subtitle: "15 September 2025",
                amount: 1200000,
                isCredit: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Helper untuk satu item riwayat
  Widget _buildHistoryItem({
    required String title,
    required String subtitle,
    required double amount,
    required bool isCredit,
  }) {
    Color color = isCredit ? Colors.green.shade700 : Colors.red.shade700;
    IconData icon = isCredit ? FontAwesomeIcons.arrowUp : FontAwesomeIcons.arrowDown;
    String sign = isCredit ? "+" : "-";

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.1),
            child: FaIcon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(subtitle, style: Get.textTheme.bodySmall?.copyWith(color: AppColors.textLight)),
              ],
            ),
          ),
          Text(
            "$sign ${rupiahFormatter.format(amount)}",
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
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
}