// lib/app/modules/06_profile_wallet/profile_main/views/profile_main_view.dart

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
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // 1. BACKGROUND DECORATION
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // 2. MAIN CONTENT
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: [
                  _buildAppBar(),
                  const SizedBox(height: 24),
                  
                  _buildProfileHeader(),
                  const SizedBox(height: 24),
                  
                  // Menu Khusus Role (Petani/Investor/Pakar)
                  ..._buildRoleSpecificMenu(),
                  
                  // Menu Umum
                  const SizedBox(height: 24),
                  _buildSectionTitle("Akun & Keamanan"),
                  _buildMenuContainer([
                    _ProfileMenuItem(
                      title: "Ubah Password",
                      icon: FontAwesomeIcons.lock,
                      onTap: controller.goToChangePassword,
                    ),
                    _ProfileMenuItem(
                      title: "Pengaturan Notifikasi",
                      icon: FontAwesomeIcons.solidBell,
                      onTap: () {}, // TODO: Implement Notification Settings
                    ),
                    _ProfileMenuItem(
                      title: "Pusat Bantuan",
                      icon: FontAwesomeIcons.circleQuestion,
                      onTap: () {}, // TODO: Implement Help Center
                    ),
                  ]),
                  
                  const SizedBox(height: 32),
                  _buildLogoutButton(),
                  const SizedBox(height: 40),
                  
                  // Version Info
                  const Text(
                    "Versi Aplikasi 1.0.0",
                    style: TextStyle(color: AppColors.textLight, fontSize: 12),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Custom AppBar
  Widget _buildAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Profil Saya",
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
          child: const FaIcon(FontAwesomeIcons.gear, size: 20, color: AppColors.textDark),
        ),
      ],
    );
  }

  /// 1. Profile Header Card
  Widget _buildProfileHeader() {
    // Ambil data user dari controller (pastikan tidak null)
    final user = controller.currentUser;
    if (user == null) {
        return const SizedBox(
            height: 100, 
            child: Center(child: Text("Silakan login kembali"))
        );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.greyLight, width: 2),
            ),
            child: CircleAvatar(
              radius: 35,
              backgroundColor: AppColors.greyLight,
              backgroundImage: (user.profilePictureUrl != null && user.profilePictureUrl!.isNotEmpty)
                  ? NetworkImage(user.profilePictureUrl!)
                  : null,
              child: (user.profilePictureUrl == null || user.profilePictureUrl!.isEmpty)
                  ? const FaIcon(FontAwesomeIcons.user, size: 30, color: Colors.grey)
                  : null,
            ),
          ),
          const SizedBox(width: 20),
          
          // Info Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.fullName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  user.email,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textLight,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                _buildKycBadge(user.kycStatus),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// KYC Status Badge
  Widget _buildKycBadge(KycStatus status) {
    bool isVerified = status == KycStatus.VERIFIED;
    Color color = isVerified ? Colors.green : Colors.orange;
    String text = isVerified ? "Terverifikasi" : "Belum Verifikasi";
    IconData icon = isVerified ? FontAwesomeIcons.check : FontAwesomeIcons.triangleExclamation;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(icon, size: 10, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  /// 2. Menu Builder Helper
  List<Widget> _buildRoleSpecificMenu() {
    final role = controller.userRole;
    List<Widget> menuItems = [];
    String title = "";

    switch (role) {
      case UserRole.FARMER:
        title = "Layanan Petani";
        menuItems = [
          _ProfileMenuItem(title: "Dompet & Saldo", icon: FontAwesomeIcons.wallet, onTap: controller.goToWallet),
          _ProfileMenuItem(title: "Kelola Aset (Lahan)", icon: FontAwesomeIcons.tractor, onTap: controller.goToManageAssets),
          _ProfileMenuItem(title: "Riwayat Transaksi", icon: FontAwesomeIcons.clockRotateLeft, onTap: controller.goToOrderHistory),
        ];
        break;
      case UserRole.INVESTOR:
        title = "Layanan Investor";
        menuItems = [
          _ProfileMenuItem(title: "Dompet Investasi", icon: FontAwesomeIcons.wallet, onTap: controller.goToWallet),
          _ProfileMenuItem(title: "Portofolio Saya", icon: FontAwesomeIcons.chartPie, onTap: controller.goToPortfolio),
          _ProfileMenuItem(title: "Rekening Pencairan", icon: FontAwesomeIcons.buildingColumns, onTap: controller.goToBankAccounts),
        ];
        break;
      case UserRole.EXPERT:
        title = "Layanan Pakar";
        menuItems = [
          _ProfileMenuItem(title: "Penghasilan", icon: FontAwesomeIcons.moneyBillTrendUp, onTap: controller.goToPayout),
          _ProfileMenuItem(title: "Jadwal & Tarif", icon: FontAwesomeIcons.calendarDay, onTap: controller.goToAvailability),
          _ProfileMenuItem(title: "Rekening Bank", icon: FontAwesomeIcons.buildingColumns, onTap: controller.goToBankAccounts),
        ];
        break;
      default:
        return [];
    }

    return [
      _buildSectionTitle(title),
      _buildMenuContainer(menuItems),
    ];
  }

  /// Wrapper untuk item menu (Card Style)
  Widget _buildMenuContainer(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: List.generate(children.length, (index) {
          return Column(
            children: [
              children[index],
              if (index != children.length - 1) // Divider kecuali item terakhir
                Padding(
                  padding: const EdgeInsets.only(left: 56, right: 20),
                  child: Divider(height: 1, color: AppColors.greyLight.withOpacity(0.5)),
                ),
            ],
          );
        }),
      ),
    );
  }

  /// Section Title
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Align(
        alignment: Alignment.centerLeft,
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

  /// Logout Button with Confirmation
  Widget _buildLogoutButton() {
    return TextButton(
      onPressed: _showLogoutDialog,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.red.withOpacity(0.05), // Merah sangat muda
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.logout_rounded, color: Colors.red),
          SizedBox(width: 8),
          Text(
            "Keluar Aplikasi",
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  /// Modern Dialog
  void _showLogoutDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const FaIcon(FontAwesomeIcons.rightFromBracket, color: Colors.red, size: 28),
              ),
              const SizedBox(height: 16),
              const Text(
                "Ingin Keluar?",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark),
              ),
              const SizedBox(height: 8),
              const Text(
                "Anda harus login kembali untuk mengakses akun Anda.",
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textLight),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Get.back(),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("Batal", style: TextStyle(color: AppColors.textLight, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        controller.logout();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: const Text("Keluar", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

/// Helper: Single Menu Item
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            FaIcon(icon, size: 20, color: AppColors.textLight), // Ikon abu-abu
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.greyLight),
          ],
        ),
      ),
    );
  }
}