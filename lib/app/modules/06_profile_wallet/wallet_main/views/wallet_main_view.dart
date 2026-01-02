// lib/app/modules/06_profile_wallet/wallet_main/views/wallet_main_view.dart

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
      body: Stack(
        children: [
          // 1. BACKGROUND DECORATION
          Positioned(
            top: -100,
            right: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 150,
            left: -80,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // 2. MAIN CONTENT
          SafeArea(
            child: RefreshIndicator(
              onRefresh: controller.fetchWalletData,
              color: AppColors.primary,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    _buildCustomAppBar(),
                    const SizedBox(height: 24),
                    
                    _buildBalanceCard(),
                    const SizedBox(height: 32),
                    
                    // Aksi Cepat (Top Up)
                    _buildSectionTitle("Aksi Cepat"),
                    _buildMenuContainer([
                      _WalletMenuItem(
                        title: "Isi Saldo (Top Up)",
                        subtitle: "Transfer Bank, E-Wallet, atau QRIS",
                        icon: FontAwesomeIcons.circlePlus,
                        color: Colors.green,
                        onTap: controller.goToTopUp,
                      ),
                    ]),
                    
                    // Fitur Khusus (Withdraw)
                    if (controller.shouldShowWithdrawFeatures) ...[
                      const SizedBox(height: 24),
                      _buildSectionTitle("Penarikan Dana"),
                      _buildMenuContainer([
                        _WalletMenuItem(
                          title: "Tarik Saldo",
                          subtitle: "Cairkan profit ke rekening Anda",
                          icon: FontAwesomeIcons.moneyBillTransfer,
                          color: Colors.blue,
                          onTap: controller.goToWithdraw,
                        ),
                        _WalletMenuItem(
                          title: "Rekening Bank",
                          subtitle: "Kelola tujuan pencairan dana",
                          icon: FontAwesomeIcons.buildingColumns,
                          color: Colors.blueGrey,
                          onTap: controller.goToBankAccounts,
                        ),
                      ]),
                    ],
                    
                    // Aktivitas
                    const SizedBox(height: 24),
                    _buildSectionTitle("Riwayat"),
                    _buildMenuContainer([
                      _WalletMenuItem(
                        title: "Semua Transaksi",
                        subtitle: "Lihat detail pemasukan & pengeluaran",
                        icon: FontAwesomeIcons.clockRotateLeft, // Ikon history yang lebih umum
                        color: Colors.orange,
                        onTap: controller.goToWalletHistory,
                      ),
                    ]),
                    
                    const SizedBox(height: 100), // Bottom padding
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Custom AppBar
  Widget _buildCustomAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Dompet Digital",
          style: Get.textTheme.headlineSmall?.copyWith(
            color: AppColors.textDark,
            fontWeight: FontWeight.w800,
            fontSize: 24,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const FaIcon(FontAwesomeIcons.wallet, size: 20, color: AppColors.primary),
        ),
      ],
    );
  }

  /// 1. Balance Card (Modern Gradient)
  Widget _buildBalanceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Pattern
          Positioned(
            right: -20,
            top: -20,
            child: Icon(
              FontAwesomeIcons.coins,
              size: 100,
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "GentaPay",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                "Saldo Aktif",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Obx(() {
                if (controller.isLoading.value) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: SizedBox(
                      height: 24, 
                      width: 24, 
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                    ),
                  );
                }
                return Text(
                  controller.rupiahFormatter.format(controller.wallet.value?.balance ?? 0),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    letterSpacing: 0.5,
                  ),
                );
              }),
              const SizedBox(height: 24),
              const Text(
                "Gunakan untuk belanja atau investasi.",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 2. Helper Title
  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 12),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.textLight,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  /// 3. Helper Menu Container (White Card)
  Widget _buildMenuContainer(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: List.generate(children.length, (index) {
          return Column(
            children: [
              children[index],
              if (index != children.length - 1)
                Padding(
                  padding: const EdgeInsets.only(left: 72, right: 20),
                  child: Divider(height: 1, color: AppColors.greyLight.withOpacity(0.5)),
                ),
            ],
          );
        }),
      ),
    );
  }
}

/// Helper: Single Menu Item
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
      borderRadius: BorderRadius.circular(24), // Match container radius
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: FaIcon(icon, size: 20, color: color),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textLight,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.greyLight),
          ],
        ),
      ),
    );
  }
}