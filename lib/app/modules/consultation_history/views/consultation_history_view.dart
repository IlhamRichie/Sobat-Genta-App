// lib/app/modules/consultation_history/views/consultation_history_view.dart
// (Buat file baru)
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
      appBar: AppBar(
        title: const Text("Riwayat Konsultasi"),
        // Tidak ada back button karena ini root tab
        automaticallyImplyLeading: false, 
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.consultationList.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(FontAwesomeIcons.solidCommentDots, size: 80, color: AppColors.greyLight),
                SizedBox(height: 16),
                Text("Belum ada riwayat konsultasi."),
              ],
            ),
          );
        }
        
        // Tampilkan List
        return RefreshIndicator(
          onRefresh: controller.fetchHistory,
          child: ListView.builder(
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

  /// Kartu untuk satu sesi konsultasi
  Widget _buildConsultationCard(ConsultationModel consultation) {
    // (Di repo asli, kita juga akan mengambil 'last_message' & 'unread_count')
    
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: () => controller.goToChatRoom(consultation),
        leading: const CircleAvatar(
          child: FaIcon(FontAwesomeIcons.user),
        ),
        title: Text(
          consultation.user.fullName, // Tampilkan nama Petani
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: const Text(
          "Klik untuk melihat detail percakapan...", // Placeholder (seharusnya last_message)
          maxLines: 1,
        ),
        trailing: _buildStatusChip(consultation.status),
      ),
    );
  }
  
  Widget _buildStatusChip(ConsultationStatus status) {
     // (Implementasi UI untuk status, cth: ACTIVE, COMPLETED)
     if (status == ConsultationStatus.ACTIVE) {
       return const Chip(
         label: Text("Aktif"),
         backgroundColor: Colors.green,
         labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
       );
     }
     return const Chip(label: Text("Selesai"));
  }
}