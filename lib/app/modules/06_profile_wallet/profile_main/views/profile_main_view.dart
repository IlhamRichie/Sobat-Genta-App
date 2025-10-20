// lib/app/modules/profile_main/views/profile_main_view.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../data/models/user_model.dart';
import '../../../../theme/app_colors.dart';
import '../controllers/profile_main_controller.dart';

class ProfileMainView extends GetView<ProfileMainController> {
  const ProfileMainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // Latar belakang abu-abu muda
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20), // Padding konsisten
          child: Column(
            children: [
              _buildProfileHeader(),
              const SizedBox(height: 24),
              ..._buildRoleSpecificMenu(),
              const SizedBox(height: 24),
              
              _buildSectionTitle("Akun & Keamanan"),
              _buildMenuItems([
                _ProfileMenuItem(
                  title: "Ubah Password",
                  icon: FontAwesomeIcons.lock,
                  onTap: controller.goToChangePassword,
                ),
                _ProfileMenuItem(
                  title: "Pengaturan Notifikasi",
                  icon: FontAwesomeIcons.solidBell,
                  onTap: () {},
                ),
                _ProfileMenuItem(
                  title: "Pusat Bantuan",
                  icon: FontAwesomeIcons.solidCircleQuestion,
                  onTap: () {},
                ),
              ]),
              
              const SizedBox(height: 32),
              
              _buildLogoutButton(),
              
              const SizedBox(height: 32),
            ],
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
        "Profil Saya",
        style: Get.textTheme.headlineSmall?.copyWith(
          color: AppColors.textDark,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: false,
    );
  }

  /// 1. Widget Header Profil
  Widget _buildProfileHeader() {
    final user = controller.currentUser;
    if (user == null) return const Center(child: Text("Gagal memuat data user."));

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.only(top: 16), // Beri jarak dari AppBar
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
      child: Row(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: AppColors.greyLight,
            backgroundImage: user.profilePictureUrl != null && user.profilePictureUrl!.isNotEmpty
                ? NetworkImage(user.profilePictureUrl!)
                : null,
            child: user.profilePictureUrl == null || user.profilePictureUrl!.isEmpty
                ? const FaIcon(FontAwesomeIcons.solidUser, size: 40, color: Colors.grey)
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.fullName,
                  style: Get.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Text(
                  user.email,
                  style: Get.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textLight,
                  ),
                ),
                const SizedBox(height: 8),
                _buildKycChip(user.kycStatus),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKycChip(KycStatus status) {
    bool isVerified = status == KycStatus.VERIFIED;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isVerified ? Colors.green.shade100 : Colors.orange.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(
            isVerified ? FontAwesomeIcons.solidCircleCheck : FontAwesomeIcons.solidCircleXmark,
            size: 12,
            color: isVerified ? Colors.green.shade900 : Colors.orange.shade900,
          ),
          const SizedBox(width: 6),
          Text(
            isVerified ? "Akun Terverifikasi" : "Belum Verifikasi (KYC)",
            style: Get.textTheme.bodySmall?.copyWith(
              color: isVerified ? Colors.green.shade900 : Colors.orange.shade900,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// Helper untuk membuat blok menu yang modern
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
                    indent: 64, // Indentasi agar tidak memotong ikon
                    endIndent: 16,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// 2. Widget Builder Menu Dinamis
  List<Widget> _buildRoleSpecificMenu() {
    final role = controller.userRole;
    List<Widget> menuItems = [];
    String title = "";

    if (role == UserRole.FARMER) {
      title = "Menu Petani";
      menuItems = [
        _ProfileMenuItem(title: "Dompet Saya", icon: FontAwesomeIcons.wallet, onTap: controller.goToWallet),
        _ProfileMenuItem(title: "Aset Saya (Lahan/Ternak)", icon: FontAwesomeIcons.mapLocationDot, onTap: controller.goToManageAssets),
        _ProfileMenuItem(title: "Riwayat Pesanan Toko", icon: FontAwesomeIcons.receipt, onTap: controller.goToOrderHistory),
      ];
    } else if (role == UserRole.INVESTOR) {
      title = "Menu Investor";
      menuItems = [
        _ProfileMenuItem(title: "Dompet Saya", icon: FontAwesomeIcons.wallet, onTap: controller.goToWallet),
        _ProfileMenuItem(title: "Portofolio Investasi Saya", icon: FontAwesomeIcons.chartLine, onTap: controller.goToPortfolio),
        _ProfileMenuItem(title: "Rekening Bank (Payout)", icon: FontAwesomeIcons.buildingColumns, onTap: controller.goToBankAccounts),
        _ProfileMenuItem(title: "Riwayat Pesanan Toko", icon: FontAwesomeIcons.receipt, onTap: controller.goToOrderHistory),
      ];
    } else if (role == UserRole.EXPERT) {
      title = "Menu Pakar";
      menuItems = [
        _ProfileMenuItem(title: "Penghasilan & Payout", icon: FontAwesomeIcons.sackDollar, onTap: controller.goToPayout),
        _ProfileMenuItem(title: "Atur Jadwal & Tarif", icon: FontAwesomeIcons.calendarCheck, onTap: controller.goToAvailability),
        _ProfileMenuItem(title: "Rekening Bank (Payout)", icon: FontAwesomeIcons.buildingColumns, onTap: controller.goToBankAccounts),
      ];
    }

    if (menuItems.isEmpty) {
      return [];
    }
    
    return [
      _buildSectionTitle(title),
      _buildMenuItems(menuItems),
    ];
  }

  /// Helper Judul Section
  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
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

  /// Tombol Logout (Diperbarui untuk memanggil Dialog Kustom)
  Widget _buildLogoutButton() {
    return TextButton.icon(
      onPressed: _showLogoutConfirmationDialog, // Memanggil dialog kustom
      icon: const FaIcon(FontAwesomeIcons.rightFromBracket, size: 20, color: Colors.red),
      label: const Text(
        "Keluar",
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  /// Dialog Konfirmasi Logout (BARU & MODERN)
  void _showLogoutConfirmationDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Sudut yang lebih membulat
        ),
        titlePadding: EdgeInsets.zero,
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        
        title: Center(
          child: Column(
            children: [
              const SizedBox(height: 16),
              const FaIcon(FontAwesomeIcons.circleExclamation, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                "Konfirmasi Keluar",
                style: Get.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        
        content: Text(
          "Apakah Anda yakin ingin keluar dari akun Anda?",
          textAlign: TextAlign.center,
          style: Get.textTheme.bodyLarge?.copyWith(color: AppColors.textDark),
        ),
        
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Get.back(), // Batal
                  child: const Text("Batal", style: TextStyle(color: AppColors.textLight, fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.greyLight),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    Get.back(); // Tutup dialog
                    controller.logout(); // Lakukan aksi logout
                  },
                  child: const Text("Keluar", style: TextStyle(fontWeight: FontWeight.bold)),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.red.shade700,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
        actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      ),
    );
  }
}

/// WIDGET REUSABLE: Satu baris menu (Diperbarui)
class _ProfileMenuItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _ProfileMenuItem({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            FaIcon(icon, size: 20, color: AppColors.textLight),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ),
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