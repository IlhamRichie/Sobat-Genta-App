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
      appBar: AppBar(
        title: const Text("Profil Saya"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Header Profil (Data dari SessionService)
            _buildProfileHeader(),
            const SizedBox(height: 16),
            
            // 2. Menu Dinamis Berdasarkan Peran
            // Controller (via model) menentukan menu apa yang tampil
            ..._buildRoleSpecificMenu(),
            
            // 3. Menu Umum (Selalu Ada)
            _buildSectionTitle("Akun & Keamanan"),
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
            
            // 4. Tombol Logout
            const Divider(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: OutlinedButton.icon(
                onPressed: controller.logout, // Panggil fungsi logout
                icon: const FaIcon(FontAwesomeIcons.rightFromBracket),
                label: const Text("Logout (Keluar)"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red.shade700,
                  side: BorderSide(color: Colors.red.shade700),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  /// 1. Widget Header Profil
  Widget _buildProfileHeader() {
    final user = controller.currentUser;
    if (user == null) return const Center(child: Text("Gagal memuat data user."));

    return Center(
      child: Column(
        children: [
          const SizedBox(height: 20),
          const CircleAvatar(
            radius: 45,
            backgroundColor: AppColors.greyLight,
            child: FaIcon(FontAwesomeIcons.solidUser, size: 40, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          Text(user.fullName, style: Get.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          Text(user.email, style: Get.textTheme.bodyLarge?.copyWith(color: AppColors.textLight)),
          const SizedBox(height: 8),
          Chip(
            label: Text(user.kycStatus == KycStatus.VERIFIED ? "Akun Terverifikasi" : "Belum Verifikasi (KYC)"),
            backgroundColor: user.kycStatus == KycStatus.VERIFIED 
                ? Colors.green.shade100 
                : Colors.orange.shade100,
            labelStyle: TextStyle(
              color: user.kycStatus == KycStatus.VERIFIED 
                  ? Colors.green.shade900 
                  : Colors.orange.shade900,
              fontWeight: FontWeight.bold
            ),
          ),
        ],
      ),
    );
  }

  /// 2. Widget Builder Menu Dinamis (LOGIKA KUNCI)
  List<Widget> _buildRoleSpecificMenu() {
    final role = controller.userRole;

    if (role == UserRole.FARMER) { // Menu Petani (Budi)
      return [
        _buildSectionTitle("Menu Petani"),
        _ProfileMenuItem(
          title: "Dompet Saya",
          icon: FontAwesomeIcons.wallet,
          onTap: controller.goToWallet, // Arahkan ke Dompet (Top Up)
        ),
        _ProfileMenuItem(
          title: "Aset Saya (Lahan/Ternak)",
          icon: FontAwesomeIcons.mapLocationDot,
          onTap: controller.goToManageAssets,
        ),
        _ProfileMenuItem(
          title: "Riwayat Pesanan Toko",
          icon: FontAwesomeIcons.receipt,
          onTap: controller.goToOrderHistory,
        ),
      ];
    }
    
    if (role == UserRole.INVESTOR) { // Menu Investor (Citra)
      return [
         _buildSectionTitle("Menu Investor"),
         _ProfileMenuItem(
          title: "Dompet Saya (Saldo & Top Up)",
          icon: FontAwesomeIcons.wallet,
          onTap: controller.goToWallet,
        ),
         _ProfileMenuItem(
          title: "Portofolio Investasi Saya",
          icon: FontAwesomeIcons.chartLine,
          onTap: controller.goToPortfolio,
        ),
         _ProfileMenuItem(
          title: "Rekening Bank (Payout)",
          icon: FontAwesomeIcons.buildingColumns,
          onTap: controller.goToBankAccounts,
        ),
        _ProfileMenuItem(
          title: "Riwayat Pesanan Toko",
          icon: FontAwesomeIcons.receipt,
          onTap: controller.goToOrderHistory,
        ),
      ];
    }
    
    if (role == UserRole.EXPERT) { // Menu Pakar (Drh. Santoso)
       return [
         _buildSectionTitle("Menu Pakar"),
         _ProfileMenuItem(
          title: "Penghasilan & Payout", // Link ke Hub Payout
          icon: FontAwesomeIcons.sackDollar,
          onTap: controller.goToPayout,
        ),
         _ProfileMenuItem(
          title: "Atur Jadwal & Tarif",
          icon: FontAwesomeIcons.calendarCheck,
          onTap: controller.goToAvailability,
        ),
        _ProfileMenuItem(
          title: "Rekening Bank (Payout)",
          icon: FontAwesomeIcons.buildingColumns,
          onTap: controller.goToBankAccounts,
        ),
      ];
    }
    
    return []; // Role tidak diketahui (seharusnya tidak terjadi)
  }
  
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Text(title, style: Get.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, color: AppColors.textLight)),
    );
  }
}


/// WIDGET REUSABLE (Internal untuk halaman ini): Satu baris menu
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
    return ListTile(
      onTap: onTap,
      leading: FaIcon(icon, size: 20, color: AppColors.textLight),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: const FaIcon(FontAwesomeIcons.chevronRight, size: 14, color: Colors.grey),
    );
  }
}