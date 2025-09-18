// lib/app/modules/main_navigation/views/main_navigation_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../theme/app_colors.dart';
import '../controllers/main_navigation_controller.dart';

class MainNavigationView extends GetView<MainNavigationController> {
  const MainNavigationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Kita bungkus Scaffold dengan Obx agar bisa me-render ulang
    // saat controller.selectedIndex berubah.
    return Obx(() => Scaffold(
          
          // --- BODY ---
          // BEST PRACTICE: Gunakan IndexedStack, BUKAN PageView.
          // IndexedStack menjaga state (posisi scroll, data) dari semua
          // halaman di bottom nav tetap hidup.
          body: IndexedStack(
            index: controller.selectedIndex.value,
            children: controller.pages,
          ),

          // --- BOTTOM NAVIGATION BAR ---
          bottomNavigationBar: BottomNavigationBar(
            // Ambil daftar item dari controller
            items: controller.navItems,
            
            // State index saat ini
            currentIndex: controller.selectedIndex.value,
            
            // Aksi saat item di-tap
            onTap: controller.onTabTapped,

            // --- Styling (Penting untuk UX) ---
            type: BottomNavigationBarType.fixed, // Wajib agar >3 item tampil
            backgroundColor: AppColors.background,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.textLight.withOpacity(0.6),
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
            elevation: 8.0,
          ),
        ));
  }
}