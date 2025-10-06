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
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: controller.fetchWalletData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBalanceCard(),
                const SizedBox(height: 24),
                
                _buildSectionTitle("Aksi Cepat"),
                _buildMenuItems([
                  _WalletMenuItem(
                    title: "Top Up Saldo",
                    subtitle: "Isi saldo via VA, QRIS, atau metode lain.",
                    icon: FontAwesomeIcons.circleUp,
                    color: Colors.green,
                    onTap: controller.goToTopUp,
                  ),
                ]),
                
                if (controller.shouldShowWithdrawFeatures) ...[
                  const SizedBox(height: 24),
                  _buildSectionTitle("Penarikan (Investor)"),
                  _buildMenuItems([
                    _WalletMenuItem(
                      title: "Tarik Dana",
                      subtitle: "Tarik profit investasi Anda ke rekening bank.",
                      icon: FontAwesomeIcons.moneyBillTransfer,
                      color: Colors.blue,
                      onTap: controller.goToWithdraw,
                    ),
                    _WalletMenuItem(
                      title: "Kelola Rekening Bank",
                      subtitle: "Atur rekening tujuan penarikan dana Anda.",
                      icon: FontAwesomeIcons.buildingColumns,
                      color: Colors.blueGrey,
                      onTap: controller.goToBankAccounts,
                    ),
                  ]),
                ],
                
                const SizedBox(height: 24),
                _buildSectionTitle("Aktivitas"),
                _buildMenuItems([
                  _WalletMenuItem(
                    title: "Riwayat Transaksi",
                    subtitle: "Lihat semua riwayat Top Up, Pembayaran, dan Investasi.",
                    icon: FontAwesomeIcons.receipt,
                    color: AppColors.primary,
                    onTap: controller.goToWalletHistory,
                  ),
                ]),
                const SizedBox(height: 24),
              ],
            ),
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
      title: Text(
        "Dompet Saya",
        style: Get.textTheme.headlineSmall?.copyWith(
          color: AppColors.textDark,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: false,
    );
  }

  /// 1. Kartu Saldo (Didesain Ulang)
  Widget _buildBalanceCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 16),
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
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Colors.white));
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Saldo Aktif Anda",
              style: Get.textTheme.titleMedium?.copyWith(
                color: Colors.white.withOpacity(0.8),
                fontSize: 16,
              ),
            ),
            Text(
              controller.rupiahFormatter.format(controller.wallet.value?.balance ?? 0),
              style: Get.textTheme.headlineLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 32,
              ),
            ),
          ],
        );
      }),
    );
  }

  /// Helper untuk membuat blok menu (baru)
  Widget _buildMenuItems(List<Widget> items) {
    return Container(
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
        children: List.generate(
          items.length,
          (index) {
            final item = items[index];
            return Column(
              children: [
                item,
                if (index < items.length - 1)
                  const Divider(
                    height: 1,
                    indent: 72,
                    endIndent: 16,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Helper untuk judul section (Didesain Ulang)
  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
        child: Text(
          title,
          style: Get.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textLight.withOpacity(0.8),
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}

/// WIDGET REUSABLE: Satu baris menu (Didesain Ulang)
class _WalletMenuItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _WalletMenuItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: FaIcon(icon, size: 24, color: color),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Get.textTheme.bodySmall?.copyWith(color: AppColors.textLight),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const FaIcon(
              FontAwesomeIcons.chevronRight,
              size: 14,
              color: AppColors.textLight,
            ),
          ],
        ),
      ),
    );
  }
}