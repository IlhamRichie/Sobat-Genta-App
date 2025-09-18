// lib/app/modules/clinic_expert_profile/views/clinic_expert_profile_view.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../theme/app_colors.dart';
import '../controllers/clinic_expert_profile_controller.dart';

class ClinicExpertProfileView extends GetView<ClinicExpertProfileController> {
  ClinicExpertProfileView({Key? key}) : super(key: key);
  
  final rupiahFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    final pakar = controller.pakar;
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Profil Pakar"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      bottomNavigationBar: _buildBottomCtaBar(), // Tombol Aksi
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(pakar),
            const SizedBox(height: 16),
            _buildStatsRow(pakar),
            const Divider(height: 32),
            _buildInfoSection(pakar),
            _buildScheduleSection(pakar), // Tampilkan jadwal
          ],
        ),
      ),
    );
  }

  /// Bagian Header (Foto, Nama, Spesialisasi)
  Widget _buildProfileHeader(pakar) {
    bool isOnline = pakar.isAvailable;
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: AppColors.greyLight,
          child: const FaIcon(FontAwesomeIcons.userDoctor, size: 50, color: Colors.grey),
          // TODO: Ganti dengan Foto Pakar
        ),
        const SizedBox(height: 16),
        Text(pakar.user.fullName, style: Get.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
        Text(pakar.specialization, style: Get.textTheme.titleMedium?.copyWith(color: AppColors.primary)),
        const SizedBox(height: 12),
        // Status Online/Offline
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: (isOnline ? Colors.green.shade700 : Colors.grey.shade600).withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            FaIcon(isOnline ? FontAwesomeIcons.solidCircleCheck : FontAwesomeIcons.solidCircleXmark, 
                   size: 14, color: isOnline ? Colors.green.shade700 : Colors.grey.shade600),
            const SizedBox(width: 8),
            Text(isOnline ? "Online" : "Offline - Saat ini tidak tersedia", 
                 style: TextStyle(fontWeight: FontWeight.bold, color: isOnline ? Colors.green.shade700 : Colors.grey.shade600)),
          ]),
        ),
      ],
    );
  }

  /// Baris Statistik (Rating, Pasien, Pengalaman) - (Placeholder)
  Widget _buildStatsRow(pakar) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(children: [ FaIcon(FontAwesomeIcons.solidStar, color: Colors.amber), SizedBox(height: 4), Text("4.9", style: TextStyle(fontWeight: FontWeight.bold)), Text("Rating")]),
        Column(children: [ FaIcon(FontAwesomeIcons.users, color: AppColors.textLight), SizedBox(height: 4), Text("100+", style: TextStyle(fontWeight: FontWeight.bold)), Text("Pasien")]),
        Column(children: [ FaIcon(FontAwesomeIcons.briefcase, color: AppColors.textLight), SizedBox(height: 4), Text("7 Thn", style: TextStyle(fontWeight: FontWeight.bold)), Text("Pengalaman")]),
      ],
    );
  }

  /// Bagian Info Detail (SIP & Bio)
  Widget _buildInfoSection(pakar) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Nomor Izin Praktik (SIP)", style: Get.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          Text(pakar.sipNumber, style: Get.textTheme.bodyLarge),
          const SizedBox(height: 20),
          Text("Tentang Pakar", style: Get.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          Text(
            "Alumnus UGM, 7 tahun pengalaman menangani kesehatan sapi perah dan hewan ternak besar. Spesialis penyakit menular ternak.", // Placeholder Bio
            style: Get.textTheme.bodyLarge?.copyWith(height: 1.5, color: AppColors.textLight),
          ),
        ],
      ),
    );
  }
  
  /// Menampilkan Jadwal Ketersediaan Pakar
  Widget _buildScheduleSection(pakar) {
     return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Jadwal Ketersediaan", style: Get.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          // Render jadwal dari model pakar
          ...pakar.schedule.map((slot) {
            bool isActive = slot.isActive.value;
            return ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: FaIcon(FontAwesomeIcons.calendarDay, color: isActive ? AppColors.primary : Colors.grey),
              title: Text(slot.dayName, style: TextStyle(fontWeight: FontWeight.bold, color: isActive ? AppColors.textDark : Colors.grey)),
              trailing: Text(
                isActive ? "${slot.startTime.value} - ${slot.endTime.value}" : "Tutup",
                style: TextStyle(color: isActive ? Colors.green.shade700 : Colors.red.shade700, fontWeight: FontWeight.bold),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  /// Tombol CTA Bawah (Dinamis)
  Widget _buildBottomCtaBar() {
    final pakar = controller.pakar;
    bool isAvailable = pakar.isAvailable;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Tarif Konsultasi", style: TextStyle(color: AppColors.textLight)),
              Text(
                "${rupiahFormatter.format(pakar.consultationFee)} /sesi",
                style: Get.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Obx(() => FilledButton(
              onPressed: isAvailable 
                  ? (controller.isProcessingPayment.value ? null : controller.startConsultation)
                  : controller.showNotAvailableDialog,
              style: FilledButton.styleFrom(
                backgroundColor: isAvailable ? AppColors.primary : Colors.grey.shade600,
              ),
              child: controller.isProcessingPayment.value
                  ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                  : Text(isAvailable ? "Konsultasi Sekarang" : "Pakar Offline"),
            )),
          ),
        ],
      ),
    );
  }
}