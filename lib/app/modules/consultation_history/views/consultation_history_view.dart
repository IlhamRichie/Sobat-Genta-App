// lib/app/modules/consultation_history/views/consultation_history_view.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../data/models/consultation_model.dart';
import '../../../theme/app_colors.dart';
import '../controllers/consultation_history_controller.dart';

class ConsultationHistoryView extends GetView<ConsultationHistoryController> {
  const ConsultationHistoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.consultationList.isEmpty) {
          return _buildEmptyState();
        }
        
        // Tampilkan List
        return RefreshIndicator(
          onRefresh: controller.fetchHistory,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            itemCount: controller.consultationList.length,
            itemBuilder: (context, index) {
              final consultation = controller.consultationList[index];
              return _buildConsultationCard(consultation);
            },
          ),
        );
      }),
    );
  }

  /// AppBar Kustom
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      title: Text(
        "Riwayat Konsultasi",
        style: Get.textTheme.headlineSmall?.copyWith(
          color: AppColors.textDark,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: false,
      automaticallyImplyLeading: false, // Pertahankan sebagai root tab
    );
  }

  /// Empty State yang Didesain Ulang
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FaIcon(FontAwesomeIcons.solidCommentDots, size: 96, color: AppColors.greyLight),
            const SizedBox(height: 32),
            Text(
              "Belum Ada Riwayat Konsultasi",
              style: Get.textTheme.titleLarge?.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              "Sesi konsultasi Anda yang sudah selesai akan muncul di sini.",
              style: Get.textTheme.bodyMedium?.copyWith(
                fontSize: 16,
                color: AppColors.textLight,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Kartu untuk satu sesi konsultasi (Didesain Ulang)
  Widget _buildConsultationCard(ConsultationModel consultation) {
    final status = consultation.status;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: InkWell(
        onTap: () => controller.goToChatRoom(consultation),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const CircleAvatar(
                backgroundColor: AppColors.greyLight,
                child: FaIcon(FontAwesomeIcons.user, color: Colors.grey),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      consultation.user.fullName, // Nama Petani
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Konsultasi Selesai", // Placeholder, seharusnya last_message
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Get.textTheme.bodyMedium?.copyWith(color: AppColors.textLight),
                    ),
                  ],
                ),
              ),
              _buildStatusChip(status),
            ],
          ),
        ),
      ),
    );
  }
  
  /// Chip Status (Didesain Ulang)
  Widget _buildStatusChip(ConsultationStatus status) {
    Color color;
    String text;
    
    if (status == ConsultationStatus.ACTIVE) {
      color = Colors.green;
      text = "Aktif";
    } else {
      color = AppColors.textLight;
      text = "Selesai";
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}