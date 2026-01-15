import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    
    // Set status bar jadi transparan biar background color nyatu ke atas
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8), // Background abu muda
      // Extend body behind appbar biar header full screen
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back(),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomCtaBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            _buildHeaderStack(pakar),
            const SizedBox(height: 60), // Space buat avatar yang "numpuk"
            _buildMainInfo(pakar),
            const SizedBox(height: 20),
            _buildStatsContainer(pakar),
            const SizedBox(height: 20),
            _buildAboutSection(pakar),
            const SizedBox(height: 20),
            _buildScheduleSection(pakar),
            const SizedBox(height: 100), // Bottom padding
          ],
        ),
      ),
    );
  }

  /// 1. Header dengan Konsep Stack (Background + Avatar Numpuk)
  Widget _buildHeaderStack(pakar) {
    return Stack(
      clipBehavior: Clip.none, // Biarkan avatar keluar dari batas container
      alignment: Alignment.bottomCenter,
      children: [
        // A. Background Gradient
        Container(
          height: 220,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary,
                AppColors.primary.withOpacity(0.8),
              ],
            ),
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
          ),
        ),
        
        // B. Foto Profil (Posisi Floating)
        Positioned(
          bottom: -50, // Geser ke bawah biar separuh di luar
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 55,
              backgroundColor: AppColors.greyLight,
              // Ganti dengan Image.network jika ada URL foto asli
              child: const FaIcon(FontAwesomeIcons.userDoctor, size: 50, color: Colors.grey), 
            ),
          ),
        ),
      ],
    );
  }

  /// 2. Info Utama (Nama, Spesialisasi, Status)
  Widget _buildMainInfo(pakar) {
    return Column(
      children: [
        Text(
          pakar.user.fullName,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3436),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          pakar.specialization,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        // Status Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: pakar.isAvailable ? Colors.green.shade50 : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: pakar.isAvailable ? Colors.green.shade200 : Colors.grey.shade300,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.circle, 
                size: 10, 
                color: pakar.isAvailable ? Colors.green : Colors.grey
              ),
              const SizedBox(width: 8),
              Text(
                pakar.isAvailable ? "Tersedia Online" : "Sedang Offline",
                style: TextStyle(
                  color: pakar.isAvailable ? Colors.green.shade700 : Colors.grey.shade600,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 3. Statistik (Rating, Pasien, Pengalaman) - Style Card
  Widget _buildStatsContainer(pakar) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem(
            value: "4.9",
            label: "Rating",
            icon: FontAwesomeIcons.solidStar,
            iconColor: Colors.amber,
          ),
          _buildVerticalDivider(),
          _buildStatItem(
            value: "120+",
            label: "Pasien",
            icon: FontAwesomeIcons.userGroup,
            iconColor: AppColors.primary,
          ),
          _buildVerticalDivider(),
          _buildStatItem(
            value: "7 Thn",
            label: "Pengalaman",
            icon: FontAwesomeIcons.briefcaseMedical,
            iconColor: Colors.blueAccent,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({required String value, required String label, required IconData icon, required Color iconColor}) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: FaIcon(icon, size: 16, color: iconColor),
        ),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text(label, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 30,
      width: 1,
      color: Colors.grey.shade200,
    );
  }

  /// 4. Bagian Tentang (Bio)
  Widget _buildAboutSection(pakar) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Tentang Dokter", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 12),
          Text(
            "Dr. ${pakar.user.fullName} adalah alumnus UGM dengan pengalaman 7 tahun menangani kesehatan sapi perah dan hewan ternak besar. Beliau juga aktif dalam riset penyakit menular ternak.", 
            style: TextStyle(color: Colors.grey.shade600, height: 1.6),
          ),
          const SizedBox(height: 16),
          // Info SIP
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F6F8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const FaIcon(FontAwesomeIcons.idCard, color: Colors.grey, size: 16),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Nomor SIP", style: TextStyle(fontSize: 10, color: Colors.grey)),
                    Text(pakar.sipNumber, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  /// 5. Jadwal Praktik
  Widget _buildScheduleSection(pakar) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Jadwal Praktik", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 12),
          ...pakar.schedule.map((slot) {
            bool isActive = slot.isActive.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isActive ? Colors.transparent : Colors.transparent),
                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 5)],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isActive ? AppColors.primary.withOpacity(0.1) : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: FaIcon(
                          FontAwesomeIcons.calendarDay, 
                          size: 16, 
                          color: isActive ? AppColors.primary : Colors.grey
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        slot.dayName, 
                        style: TextStyle(
                          fontWeight: FontWeight.bold, 
                          color: isActive ? Colors.black87 : Colors.grey
                        )
                      ),
                    ],
                  ),
                  Text(
                    isActive ? "${slot.startTime.value} - ${slot.endTime.value}" : "Tutup",
                    style: TextStyle(
                      color: isActive ? AppColors.textDark : Colors.grey, 
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.normal
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  /// 6. Bottom Bar (Sticky)
  Widget _buildBottomCtaBar() {
    final pakar = controller.pakar;
    bool isAvailable = pakar.isAvailable;
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Biaya Sesi", style: TextStyle(color: Colors.grey, fontSize: 12)),
                Text(
                  rupiahFormatter.format(pakar.consultationFee),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 24),
            Expanded(
              child: SizedBox(
                height: 50,
                child: Obx(() => ElevatedButton(
                  onPressed: isAvailable 
                      ? (controller.isProcessingPayment.value ? null : controller.startConsultation)
                      : controller.showNotAvailableDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isAvailable ? AppColors.primary : Colors.grey.shade400,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: controller.isProcessingPayment.value
                      ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Text(
                          isAvailable ? "Chat Sekarang" : "Pakar Offline",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}