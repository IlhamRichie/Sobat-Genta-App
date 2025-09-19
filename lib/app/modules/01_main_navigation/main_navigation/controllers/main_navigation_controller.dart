// lib/app/modules/main_navigation/controllers/main_navigation_controller.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

// 1. IMPORT SEMUA HALAMAN 'ROOT' UNTUK SETIAP TAB
// (Kita akan buat file view-nya setelah ini, untuk sekarang import saja)
import '../../../../data/models/user_model.dart';
import '../../../../services/session_service.dart';
import '../../../../theme/app_colors.dart';
import '../../../02_clinic_support/clinic_home/views/clinic_home_view.dart';
import '../../../02_clinic_support/expert_dashboard/views/expert_dashboard_view.dart';
import '../../../03_store_ecommerce/store_home/views/store_home_view.dart';
import '../../../04_tender_needs/tender_marketplace/views/tender_marketplace_view.dart';
import '../../../05_funding_investment/investor_funding_marketplace/views/investor_funding_marketplace_view.dart';
import '../../../05_funding_investment/investor_portfolio/views/investor_portfolio_view.dart';
import '../../../06_profile_wallet/profile_main/views/profile_main_view.dart';
import '../../home_dashboard/views/home_dashboard_view.dart';

class MainNavigationController extends GetxController {
  
  final SessionService _sessionService = Get.find<SessionService>();

  // --- STATE ---
  final RxInt selectedIndex = 0.obs;

  // --- NAVIGATION LISTS ---
  // List ini akan diisi secara dinamis berdasarkan peran
  final List<Widget> pages = [];
  final List<BottomNavigationBarItem> navItems = [];

  @override
  void onInit() {
    super.onInit();
    // Ambil role dari SessionService dan bangun UI yang sesuai
    _buildNavigationForRole(_sessionService.userRole);
  }

  /// Mengganti halaman aktif
  void onTabTapped(int index) {
    selectedIndex.value = index;
  }

  /// --- LOGIKA UTAMA: DYNAMIC NAVIGATION BUILDER ---
  void _buildNavigationForRole(UserRole role) {
    // Bersihkan list sebelum membangun
    pages.clear();
    navItems.clear();

    switch (role) {
      case UserRole.FARMER:
        _buildFarmerNav();
        break;
      case UserRole.INVESTOR:
        _buildInvestorNav();
        break;
      case UserRole.EXPERT:
        _buildExpertNav();
        break;
      case UserRole.UNKNOWN:
        // Idealnya ini tidak terjadi, user harusnya di-redirect ke login
        // oleh SplashController.
        break;
    }
    // Refresh UI jika diperlukan (meskipun onInit sudah cukup)
    update();
  }

  // --- Role-Specific Builders ---

  void _buildFarmerNav() {
    // Sesuai Skenario 1 (Budi) & SRS
    pages.addAll([
      HomeDashboardView(),    // Tab 1: Home Petani
      ClinicHomeView(),       // Tab 2: Klinik
      StoreHomeView(),        // Tab 3: Toko
      TenderMarketplaceView(),// Tab 4: Tender (Kebutuhan)
      ProfileMainView(),      // Tab 5: Profil
    ]);
    navItems.addAll([
      _buildNavItem(FontAwesomeIcons.house, "Home"),
      _buildNavItem(FontAwesomeIcons.stethoscope, "Klinik"),
      _buildNavItem(FontAwesomeIcons.store, "Toko"),
      _buildNavItem(FontAwesomeIcons.bullhorn, "Tender"),
      _buildNavItem(FontAwesomeIcons.solidUser, "Profil"),
    ]);
  }

  void _buildInvestorNav() {
    // Sesuai Skenario 2 (Citra) & SRS
    pages.addAll([
      InvestorFundingMarketplaceView(), // Tab 1: Marketplace Proyek
      StoreHomeView(),                  // Tab 2: Toko (Asumsi bisa belanja juga)
      InvestorPortfolioView(),          // Tab 3: Portofolio Investasi
      ProfileMainView(),                // Tab 4: Profil
    ]);
    navItems.addAll([
      _buildNavItem(FontAwesomeIcons.chartLine, "Proyek"),
      _buildNavItem(FontAwesomeIcons.store, "Toko"),
      _buildNavItem(FontAwesomeIcons.briefcase, "Portofolio"),
      _buildNavItem(FontAwesomeIcons.solidUser, "Profil"),
    ]);
  }

  void _buildExpertNav() {
    // Sesuai Skenario 3 (Drh. Santoso) & SRS
    pages.addAll([
      ExpertDashboardView(), // Tab 1: Dashboard Pakar
      Center(child: Text("Daftar Konsultasi")), // Tab 2: Riwayat/Daftar Chat
      ProfileMainView(),     // Tab 3: Profil
    ]);
    navItems.addAll([
      _buildNavItem(FontAwesomeIcons.chartPie, "Dashboard"),
      _buildNavItem(FontAwesomeIcons.solidComments, "Konsultasi"),
      _buildNavItem(FontAwesomeIcons.solidUser, "Profil"),
    ]);
  }

  // Helper untuk membuat BottomNavigationBarItem
  BottomNavigationBarItem _buildNavItem(IconData icon, String label) {
    return BottomNavigationBarItem(
      icon: FaIcon(icon, size: 20),
      // Kita bisa gunakan icon solid saat aktif
      activeIcon: FaIcon(icon, size: 20, color: AppColors.primary),
      label: label,
    );
  }
}