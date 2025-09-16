import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../02_clinic_support/clinic_home/views/clinic_home_view.dart';
import '../../../03_store_ecommerce/store_home/views/store_home_view.dart';
import '../../../04_tender_needs/tender_marketplace/views/tender_marketplace_view.dart';
import '../../../06_profile_wallet/profile_main/views/profile_main_view.dart';
import '../../home_dashboard/views/home_dashboard_view.dart';
import '../controllers/main_navigation_controller.dart';

// (Best Practice: Pindahkan ini ke lib/app/theme/app_colors.dart)
const kPrimaryDarkGreen = Color(0xFF3A8A40);
const kDarkTextColor = Color(0xFF1B2C1E);
const kBodyTextColor = Color(0xFF5A6A5C);
const kWarningColor = Color(0xFFFFA000); // Kuning untuk banner
const kInfoColor = Color(0xFF2196F3); // Biru untuk 'inReview'

class MainNavigationView extends GetView<MainNavigationController> {
  const MainNavigationView({Key? key}) : super(key: key);

  // Best Practice: Definisikan daftar halaman di dalam View
  // Ini adalah 5 halaman yang sesuai dengan 5 tab di BNB
  final List<Widget> _pages = const [
    HomeDashboardView(),    // Tab 1: Home
    ClinicHomeView(),       // Tab 2: Klinik (Placeholder)
    StoreHomeView(),        // Tab 3: Toko (Placeholder)
    TenderMarketplaceView(),  // Tab 4: Kebutuhan (Placeholder)
    ProfileMainView(),      // Tab 5: Profil (Placeholder)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // --- [SR-KYC-03] Banner Peringatan KYC ---
            _buildKycBanner(),
            
            // --- Konten Halaman (Tab yang Aktif) ---
            Expanded(
              // Obx untuk mereaksi perubahan 'selectedIndex'
              child: Obx(() {
                // IndexedStack adalah best practice untuk BNB
                // karena dia 'menyimpan' state dari tab yang tidak aktif
                return IndexedStack(
                  index: controller.selectedIndex.value,
                  children: _pages,
                );
              }),
            ),
          ],
        ),
      ),
      // --- [UI] Bottom Navigation Bar ---
      bottomNavigationBar: Obx(() {
        // Obx diperlukan agar 'currentIndex' reaktif
        return BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          onTap: controller.onItemTapped,
          
          // --- Theme Konsisten ---
          type: BottomNavigationBarType.fixed, // Tampilkan semua label
          backgroundColor: Colors.white,
          selectedItemColor: kPrimaryDarkGreen,
          unselectedItemColor: kBodyTextColor,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          elevation: 8.0,

          items: const [
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.house),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.stethoscope),
              label: 'Klinik',
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.store),
              label: 'Toko',
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.bullhorn),
              label: 'Kebutuhan',
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.solidUser),
              label: 'Profil',
            ),
          ],
        );
      }),
    );
  }

  // --- Helper Widget untuk Banner KYC ---
  Widget _buildKycBanner() {
    return Obx(() {
      final status = controller.kycStatus.value;

      // 1. Jika sudah terverifikasi, jangan tampilkan apa-apa
      if (status == UserKycStatus.verified) {
        return const SizedBox.shrink();
      }

      // 2. Tentukan style berdasarkan status
      final String message;
      final Color bannerColor, iconColor, textColor;
      final bool showArrow;

      if (status == UserKycStatus.pending) {
        // [SR-KYC-03] Banner untuk "Pending" (Belum mengisi)
        message = 'Akun belum terverifikasi. Lengkapi data';
        bannerColor = kWarningColor.withOpacity(0.15);
        iconColor = kWarningColor;
        textColor = kPrimaryDarkGreen;
        showArrow = true;
      } else {
        // [SR-KYC-04] Banner untuk "In Review" (Menunggu Admin)
        message = 'Data KYC Anda sedang ditinjau oleh Admin.';
        bannerColor = kInfoColor.withOpacity(0.15);
        iconColor = kInfoColor;
        textColor = kBodyTextColor;
        showArrow = false;
      }

      // 3. Tampilkan banner
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        color: bannerColor,
        child: Row(
          children: [
            Icon(
              status == UserKycStatus.pending ? Icons.warning_amber_rounded : Icons.info_outline,
              color: iconColor,
              size: 28,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: RichText(
                text: TextSpan(
                  text: message,
                  style: TextStyle(
                      color: kDarkTextColor, fontSize: 14, fontFamily: 'Inter'),
                  children: [
                    if (status == UserKycStatus.pending)
                      TextSpan(
                        text: ' sekarang',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: textColor,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            if (showArrow)
              IconButton(
                onPressed: controller.goToKycForm,
                icon: const Icon(Icons.arrow_forward_ios_rounded, color: kPrimaryDarkGreen, size: 18),
              )
          ],
        ),
      ).animate().fadeIn(duration: 300.ms);
    });
  }
}