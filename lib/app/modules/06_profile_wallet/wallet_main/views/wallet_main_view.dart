// lib/app/modules/wallet_main/views/wallet_main_view.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../theme/app_colors.dart';
import '../controllers/wallet_main_controller.dart';

class WalletMainView extends GetView<WalletMainController> {
  const WalletMainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dompet Saya"),
      ),
      body: RefreshIndicator(
        onRefresh: controller.fetchWalletData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // 1. Kartu Saldo Utama
              _buildBalanceCard(),
              
              // 2. Menu Aksi Utama
              _buildActionMenu(),
              
              // 3. Menu Dinamis (Withdraw, hanya untuk Investor)
              if (controller.shouldShowWithdrawFeatures) // <-- Logika Dinamis
                _buildWithdrawMenu(),
                
              // 4. Menu Lainnya (History, dll)
              _buildOtherMenu(),
            ],
          ),
        ),
      ),
    );
  }

  /// 1. Kartu Saldo
  Widget _buildBalanceCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Colors.white));
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Saldo Aktif Anda",
              style: Get.textTheme.titleMedium?.copyWith(color: Colors.white70),
            ),
            Text(
              controller.rupiahFormatter.format(controller.wallet.value?.balance ?? 0),
              style: Get.textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        );
      }),
    );
  }

  /// 2. Menu Aksi Utama (Top Up)
  Widget _buildActionMenu() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade300)
        ),
        child: ListTile(
          onTap: controller.goToTopUp,
          leading: const FaIcon(FontAwesomeIcons.circleUp, color: Colors.green),
          title: const Text("Top Up Saldo", style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: const Text("Isi saldo via VA, QRIS, atau metode lain."),
          trailing: const FaIcon(FontAwesomeIcons.chevronRight, size: 16),
        ),
      ),
    );
  }

  /// 3. Menu Khusus Investor (Tarik Dana & Bank)
  Widget _buildWithdrawMenu() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("Penarikan (Investor)"),
          _buildMenuItem(
            "Tarik Dana (Withdraw)",
            "Tarik profit investasi Anda ke rekening bank.",
            FontAwesomeIcons.moneyBillTransfer,
            controller.goToWithdraw,
          ),
          _buildMenuItem(
            "Kelola Rekening Bank",
            "Atur rekening tujuan penarikan dana Anda.",
            FontAwesomeIcons.buildingColumns,
            controller.goToBankAccounts,
          ),
        ],
      ),
    );
  }

  /// 4. Menu Lainnya (Riwayat)
  Widget _buildOtherMenu() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("Aktivitas"),
          _buildMenuItem(
            "Riwayat Transaksi",
            "Lihat semua riwayat Top Up, Pembayaran, dan Investasi.",
            FontAwesomeIcons.receipt,
            controller.goToWalletHistory,
          ),
        ],
      ),
    );
  }

  // --- WIDGET HELPER ---

  Widget _buildMenuItem(String title, String subtitle, IconData icon, VoidCallback onTap) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300)
      ),
      child: ListTile(
        onTap: onTap,
        leading: FaIcon(icon, color: AppColors.textLight, size: 20),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: const FaIcon(FontAwesomeIcons.chevronRight, size: 14, color: Colors.grey),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 0, 8),
      child: Text(title, style: Get.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, color: AppColors.textLight)),
    );
  }
}