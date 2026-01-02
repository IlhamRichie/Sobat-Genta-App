// lib/app/modules/consultation_history/views/consultation_history_view.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Untuk format tanggal
import '../../../data/models/consultation_model.dart';
import '../../../theme/app_colors.dart';
import '../controllers/consultation_history_controller.dart';

class ConsultationHistoryView extends GetView<ConsultationHistoryController> {
  const ConsultationHistoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // 1. BACKGROUND DECORATION
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.05), // Nuansa biru chat
                shape: BoxShape.circle,
              ),
            ),
          ),

          // 2. MAIN CONTENT
          SafeArea(
            child: Column(
              children: [
                _buildCustomAppBar(),
                
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (controller.consultationList.isEmpty) {
                      return _buildEmptyState();
                    }
                    
                    // Grouping atau Sorting bisa dilakukan di sini jika perlu
                    // Saat ini kita tampilkan list flat saja
                    return RefreshIndicator(
                      onRefresh: controller.fetchHistory,
                      color: AppColors.primary,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        physics: const BouncingScrollPhysics(),
                        itemCount: controller.consultationList.length,
                        separatorBuilder: (ctx, i) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final consultation = controller.consultationList[index];
                          return _buildConsultationCard(consultation);
                        },
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Custom AppBar
  Widget _buildCustomAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Riwayat Chat",
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
            child: const FaIcon(FontAwesomeIcons.solidCommentDots, size: 20, color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  /// Empty State Modern
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.greyLight.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: const FaIcon(FontAwesomeIcons.comments, size: 64, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          Text(
            "Belum Ada Percakapan",
            style: Get.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Mulai konsultasi untuk melihat riwayat di sini.",
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textLight),
          ),
        ],
      ),
    );
  }

  /// Modern Consultation Card
  Widget _buildConsultationCard(ConsultationModel consultation) {
    bool isActive = consultation.status == ConsultationStatus.ACTIVE;
    
    // Format Waktu (Dummy timestamp karena di model belum ada, gunakan now atau logic lain)
    String timeString = DateFormat('HH:mm').format(DateTime.now()); 

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () => controller.goToChatRoom(consultation),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Avatar dengan indikator status
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: _getAvatarColor(consultation.user.fullName),
                      child: Text(
                        _getInitials(consultation.user.fullName),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    if (isActive)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 16),
                
                // Info Chat
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              consultation.user.fullName,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDark),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            timeString,
                            style: TextStyle(
                              fontSize: 12,
                              color: isActive ? Colors.green : AppColors.textLight,
                              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          if (isActive) ...[
                            const FaIcon(FontAwesomeIcons.pen, size: 10, color: AppColors.primary),
                            const SizedBox(width: 4),
                            const Text("Sedang berlangsung...", style: TextStyle(color: AppColors.primary, fontSize: 13)),
                          ] else
                            const Expanded(
                              child: Text(
                                "Sesi telah berakhir • Ketuk untuk lihat riwayat",
                                style: TextStyle(color: AppColors.textLight, fontSize: 13),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper untuk warna avatar random yang konsisten berdasarkan nama
  Color _getAvatarColor(String name) {
    final colors = [
      Colors.blue, Colors.red, Colors.orange, Colors.purple, Colors.teal, 
      Colors.pink, Colors.indigo, Colors.brown
    ];
    return colors[name.hashCode % colors.length].shade400;
  }

  // Helper Initials
  String _getInitials(String name) {
    List<String> names = name.split(" ");
    String initials = "";
    if (names.isNotEmpty) {
      initials += names[0][0];
      if (names.length > 1) initials += names[1][0];
    }
    return initials.toUpperCase();
  }
}