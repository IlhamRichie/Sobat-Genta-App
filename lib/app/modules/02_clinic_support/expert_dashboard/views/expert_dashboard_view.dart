// lib/app/modules/expert_dashboard/views/expert_dashboard_view.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../routes/app_pages.dart';
import '../../../../theme/app_colors.dart';
import '../controllers/expert_dashboard_controller.dart';

class ExpertDashboardView extends GetView<ExpertDashboardController> {
  ExpertDashboardView({Key? key}) : super(key: key);
  
  final rupiahFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

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
                color: Colors.blue.withOpacity(0.05), // Biru untuk nuansa Medis/Pro
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 100,
            left: -80,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // 2. MAIN CONTENT
          SafeArea(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              
              return RefreshIndicator(
                onRefresh: controller.fetchDashboardData,
                color: AppColors.primary,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    children: [
                      _buildCustomAppBar(),
                      const SizedBox(height: 24),
                      
                      _buildStatusToggleCard(), // Status Online/Offline Hero
                      const SizedBox(height: 24),
                      
                      _buildStatsOverview(), // Ringkasan Penghasilan & Antrian
                      const SizedBox(height: 32),
                      
                      _buildConsultationQueue(), // List Antrian
                      const SizedBox(height: 80), // Bottom padding
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  /// Custom AppBar dengan Profil Ringkas
  Widget _buildCustomAppBar() {
    final user = controller.profile.value?.user;
    return Row(
      children: [
        // Avatar
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.greyLight,
            backgroundImage: (user?.profilePictureUrl != null && user!.profilePictureUrl!.isNotEmpty)
                ? NetworkImage(user.profilePictureUrl!)
                : null,
            child: (user?.profilePictureUrl == null || user!.profilePictureUrl!.isEmpty)
                ? const FaIcon(FontAwesomeIcons.userDoctor, size: 20, color: Colors.grey)
                : null,
          ),
        ),
        const SizedBox(width: 16),
        
        // Greeting
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Halo, Dokter 👋",
                style: Get.textTheme.bodyMedium?.copyWith(color: AppColors.textLight),
              ),
              Text(
                user?.fullName ?? "Pakar Genta",
                style: Get.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColors.textDark,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        
        // Notification Icon
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: const Offset(0, 2))],
          ),
          child: IconButton(
            onPressed: () { /* TODO: Notifications */ },
            icon: const FaIcon(FontAwesomeIcons.solidBell, size: 18, color: AppColors.textDark),
          ),
        ),
      ],
    );
  }

  /// Card Toggle Status (Hero Section)
  Widget _buildStatusToggleCard() {
    bool isOnline = controller.isAvailable.value;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isOnline ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE), // Background hijau/merah muda
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isOnline ? Colors.green.withOpacity(0.3) : Colors.red.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isOnline ? Colors.green : Colors.red,
                  shape: BoxShape.circle,
                ),
                child: FaIcon(
                  isOnline ? FontAwesomeIcons.solidLightbulb : FontAwesomeIcons.powerOff,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Status Konsultasi",
                    style: Get.textTheme.bodySmall?.copyWith(color: AppColors.textLight),
                  ),
                  Text(
                    isOnline ? "Sedang Online" : "Sedang Offline",
                    style: Get.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isOnline ? Colors.green.shade800 : Colors.red.shade800,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          // Switch Custom
          Obx(() => controller.isToggleLoading.value
              ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
              : Switch(
                  value: isOnline,
                  onChanged: controller.toggleAvailability,
                  activeColor: Colors.green,
                  activeTrackColor: Colors.green.shade200,
                  inactiveThumbColor: Colors.red,
                  inactiveTrackColor: Colors.red.shade200,
                )
          ),
        ],
      ),
    );
  }

  /// Statistik (Penghasilan & Antrian)
  Widget _buildStatsOverview() {
    return Row(
      children: [
        // Card Penghasilan (Gradient)
        Expanded(
          flex: 3,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, Color(0xFF2E7D32)], // Hijau Genta
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const FaIcon(FontAwesomeIcons.wallet, color: Colors.white, size: 16),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Total Penghasilan",
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  rupiahFormatter.format(controller.currentEarnings.value),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () => Get.toNamed(Routes.EXPERT_PAYOUT),
                  child: Row(
                    children: const [
                      Text("Tarik Dana", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 14),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        
        // Card Antrian (White)
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.08),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const FaIcon(FontAwesomeIcons.userGroup, color: Colors.orange, size: 16),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Antrian",
                  style: TextStyle(color: AppColors.textLight, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  "${controller.pendingConsultations.value}",
                  style: const TextStyle(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                const Text(
                  "Pasien",
                  style: TextStyle(color: AppColors.textLight, fontSize: 12),
                ),
                const SizedBox(height: 12), // Spacer
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Daftar Antrian Konsultasi
  Widget _buildConsultationQueue() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Permintaan Masuk",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            TextButton(
              onPressed: () { /* TODO: View All History */ },
              child: const Text("Riwayat", style: TextStyle(color: AppColors.primary)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        // List Antrian (Mockup Data jika kosong, real jika ada)
        // Disini kita simulasikan 1 item jika controller kosong, 
        // atau gunakan ListView.builder jika sudah ada data real.
        if (controller.pendingConsultations.value == 0)
          _buildEmptyQueueState()
        else
          Column(
            children: [
              _buildQueueItem(
                name: "Budi Santoso",
                category: "Pertanian - Padi",
                time: "Baru saja",
                onTap: () { /* TODO: Accept/Go Chat */ },
              ),
              // Tambahkan item lain jika ada list
            ],
          ),
      ],
    );
  }

  Widget _buildEmptyQueueState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.greyLight.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          const FaIcon(FontAwesomeIcons.mugHot, size: 40, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            "Belum ada antrian saat ini.",
            style: TextStyle(color: AppColors.textLight, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          const Text(
            "Nikmati waktu istirahat Anda, Dok!",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildQueueItem({
    required String name,
    required String category,
    required String time,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: AppColors.greyLight,
          child: const FaIcon(FontAwesomeIcons.user, color: Colors.grey, size: 20),
        ),
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.label_outline, size: 14, color: AppColors.textLight),
                const SizedBox(width: 4),
                Text(category, style: const TextStyle(fontSize: 12, color: AppColors.textLight)),
              ],
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                const Icon(Icons.access_time, size: 14, color: AppColors.textLight),
                const SizedBox(width: 4),
                Text(time, style: const TextStyle(fontSize: 12, color: Colors.orange)),
              ],
            ),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            elevation: 0,
          ),
          child: const Text("Terima"),
        ),
      ),
    );
  }
}