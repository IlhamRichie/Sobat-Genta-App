// lib/app/modules/expert_payout/views/expert_payout_view.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../data/models/bank_account_model.dart';
import '../../../../theme/app_colors.dart';
import '../controllers/expert_payout_controller.dart';

class ExpertPayoutView extends GetView<ExpertPayoutController> {
  ExpertPayoutView({Key? key}) : super(key: key);

  final rupiahFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Penghasilan & Payout"),
      ),
      body: RefreshIndicator(
        onRefresh: controller.fetchPayoutData,
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildEarningsCard(),
                const SizedBox(height: 24),
                _buildBankAccountsSection(),
                const SizedBox(height: 24),
                _buildHistoryPlaceholder(),
              ],
            ),
          );
        }),
      ),
    );
  }

  /// Kartu #1: Saldo Penghasilan
  Widget _buildEarningsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: AppColors.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Total Penghasilan (Dapat Ditarik)",
              style: Get.textTheme.titleMedium?.copyWith(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            Text(
              rupiahFormatter.format(controller.wallet.value?.balance ?? 0),
              style: Get.textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            // Tombol Tarik Dana (Dinamis)
            Obx(() => FilledButton.icon(
                  onPressed: controller.canWithdraw ? controller.goToWithdrawForm : null,
                  icon: const FaIcon(FontAwesomeIcons.moneyBillTransfer, size: 16),
                  label: const Text("Tarik Dana (Withdraw)"),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    disabledBackgroundColor: Colors.white.withOpacity(0.5),
                  ),
                )),
            // Info jika tombol non-aktif
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
        ),
      ),
    );
  }

  /// Bagian #2: Rekening Bank Terdaftar
  Widget _buildBankAccountsSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Rekening Bank Terdaftar",
              style: Get.textTheme.titleLarge?.copyWith(fontSize: 18),
            ),
            TextButton(
              onPressed: controller.goToManageAccounts,
              child: const Text("Kelola"),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Obx(() {
          if (controller.accountList.isEmpty) {
            return _buildEmptyBankAccount();
          }
          // Tampilkan list rekening (kita hanya tampilkan yang utama di sini)
          final primaryAccount = controller.accountList.firstWhere(
            (acc) => acc.isPrimary,
            orElse: () => controller.accountList.first,
          );
          return _buildBankAccountCard(primaryAccount, true);
        }),
      ],
    );
  }
  
  /// Kartu untuk satu rekening bank
  Widget _buildBankAccountCard(BankAccountModel account, bool isPrimary) {
     return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isPrimary ? AppColors.primary : Colors.grey.shade300, width: 1.5)
      ),
      child: ListTile(
        leading: const CircleAvatar(child: FaIcon(FontAwesomeIcons.buildingColumns)), // TODO: Logo Bank
        title: Text(account.bankName.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("${account.accountNumber} \na.n ${account.accountHolderName}"),
        isThreeLine: true,
        trailing: isPrimary 
          ? const Chip(label: Text("Utama"), backgroundColor: AppColors.primary, labelStyle: TextStyle(color: Colors.white)) 
          : null,
      ),
    );
  }

  /// Tampilan jika belum ada rekening bank
  Widget _buildEmptyBankAccount() {
    return InkWell(
      onTap: controller.goToManageAccounts,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid, width: 2),
        ),
        child: Column(
          children: [
            const FaIcon(FontAwesomeIcons.buildingColumns, color: AppColors.textLight),
            const SizedBox(height: 12),
            const Text(
              "Belum ada rekening bank",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              "Klik untuk menambah rekening tujuan penarikan dana.",
              style: Get.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Placeholder Riwayat Transaksi
  Widget _buildHistoryPlaceholder() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Text(
          "Riwayat Payout",
          style: Get.textTheme.titleLarge?.copyWith(fontSize: 18),
        ),
         const SizedBox(height: 16),
         ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade300)
            ),
           leading: const CircleAvatar(backgroundColor: Colors.green, child: FaIcon(FontAwesomeIcons.arrowDown, size: 16, color: Colors.white)),
           title: const Text("Penarikan Dana (Selesai)", style: TextStyle(fontWeight: FontWeight.bold)),
           subtitle: const Text("15 September 2025"),
           trailing: Text(rupiahFormatter.format(1200000), style: const TextStyle(fontWeight: FontWeight.bold)),
         ),
         // (Placeholder riwayat lainnya)
      ],
    );
  }
}