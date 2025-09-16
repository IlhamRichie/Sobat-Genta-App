import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../00_core_auth/register_role_chooser/controllers/register_role_chooser_controller.dart';
import '../../main_navigation/controllers/main_navigation_controller.dart';
import '../controllers/home_dashboard_controller.dart';

// (Best Practice: Pindahkan ini ke lib/app/theme/app_colors.dart)
const kPrimaryDarkGreen = Color(0xFF3A8A40);
const kLightGreenBlob = Color(0xFFEAF4EB);
const kDarkTextColor = Color(0xFF1B2C1E);
const kBodyTextColor = Color(0xFF5A6A5C);

class HomeDashboardView extends GetView<HomeDashboardController> {
  const HomeDashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ambil status KYC dari controller induk
    // Obx akan 'mendengarkan' perubahan pada mainNavController.kycStatus
    return Obx(() {
      final kycStatus = controller.mainNavController.kycStatus.value;
      final bool isKycVerified = (kycStatus == UserKycStatus.verified);

      return Scaffold(
        backgroundColor: kLightGreenBlob, // Background dashboard
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, controller.userName.value, controller.userRoleName.value),
              _buildWalletSummaryCard(isKycVerified),
              _buildQuickActions(context, isKycVerified),
              _buildPopularProjects(),
            ],
          ),
        ),
      );
    });
  }

  // --- Helper Widgets (Best Practice) ---

  Widget _buildHeader(BuildContext context, String name, String role) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selamat Datang,',
            style: TextStyle(
              fontSize: 18,
              color: kBodyTextColor,
            ),
          ),
          Text(
            name, // Nama dari controller
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: kDarkTextColor,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: kPrimaryDarkGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              role, // Peran dari controller
              style: const TextStyle(
                color: kPrimaryDarkGreen,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ).animate().fadeIn(delay: 300.ms).slideY(begin: -0.1),
    );
  }

  Widget _buildWalletSummaryCard(bool isKycVerified) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      margin: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: kPrimaryDarkGreen,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: kPrimaryDarkGreen.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total Saldo',
            style: TextStyle(color: kLightGreenBlob, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            isKycVerified ? 'Rp 1.250.000' : 'Rp 0',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          if (!isKycVerified) // Tampilkan pesan jika KYC belum verified
            Row(
              children: [
                const Icon(Icons.lock_outline, color: Colors.white, size: 16),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Dompet Anda akan aktif setelah verifikasi KYC.',
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ),
              ],
            ),
          // (Tampilkan tombol TopUp/Tarik jika sudah verified)
        ],
      ),
    ).animate().fadeIn(delay: 500.ms).scale(begin: const Offset(0.9, 0.9));
  }
  
  Widget _buildQuickActions(BuildContext context, bool isKycVerified) {
    // (Simulasi UI berbeda berdasarkan Peran Pengguna)
    final bool isFarmer = controller.userRole.value == UserRole.farmer;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Aksi Cepat',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kDarkTextColor),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // --- [SR-KYC-02] Fitur Terkunci ---
              // Jika pengguna adalah Petani, tunjukkan "Ajukan Dana"
              // Jika Investor, tunjukkan "Investasi"
              if (isFarmer)
                _buildActionButton(
                  context,
                  icon: FontAwesomeIcons.handHoldingDollar,
                  label: 'Ajukan Dana',
                  isLocked: !isKycVerified, // Terkunci jika KYC belum
                  onTap: controller.goToFundingMarketplace,
                ),
              if (!isFarmer) // (Ini asumsi Investor/Pakar)
                 _buildActionButton(
                  context,
                  icon: FontAwesomeIcons.chartLine,
                  label: 'Investasi',
                  isLocked: !isKycVerified, // Terkunci jika KYC belum
                  onTap: controller.goToFundingMarketplace,
                ),
              
              // --- Fitur Terkunci (Klinik) ---
              _buildActionButton(
                context,
                icon: FontAwesomeIcons.stethoscope,
                label: 'Klinik',
                isLocked: !isKycVerified, // Terkunci jika KYC belum
                onTap: controller.goToClinic,
              ),

              // --- Fitur Tidak Terkunci (Toko - Sesuai SRS) ---
              _buildActionButton(
                context,
                icon: FontAwesomeIcons.store,
                label: 'Toko',
                isLocked: false, // Toko tidak terkunci
                onTap: controller.goToStore,
              ),

              _buildActionButton(
                context,
                icon: FontAwesomeIcons.bullhorn,
                label: 'Kebutuhan',
                isLocked: !isKycVerified, // Terkunci jika KYC belum
                onTap: () {},
              ),
            ],
          ).animate(delay: 700.ms).fadeIn().slideX(begin: -0.2),
        ],
      ),
    );
  }

  // Helper widget untuk tombol aksi cepat
  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool isLocked,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: isLocked ? () => controller.showKycSnackbar(context) : onTap,
      child: Column(
        children: [
          Container(
            width: Get.width * 0.18, // Responsif
            height: Get.width * 0.18,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                )
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                FaIcon(
                  icon,
                  size: 28,
                  color: isLocked ? kBodyTextColor.withOpacity(0.5) : kPrimaryDarkGreen,
                ),
                if (isLocked)
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                if (isLocked)
                  const Icon(Icons.lock, color: kDarkTextColor, size: 24),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isLocked ? kBodyTextColor.withOpacity(0.5) : kDarkTextColor,
            ),
          )
        ],
      ),
    );
  }

  // (Placeholder untuk sisa dashboard)
  Widget _buildPopularProjects() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Proyek Populer',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kDarkTextColor),
          ),
          const SizedBox(height: 16),
          // (List horizontal proyek/berita nanti di sini)
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16)
            ),
            child: const Center(child: Text('Placeholder Proyek Populer')),
          ).animate().fadeIn(delay: 900.ms),
        ],
      ),
    );
  }
}