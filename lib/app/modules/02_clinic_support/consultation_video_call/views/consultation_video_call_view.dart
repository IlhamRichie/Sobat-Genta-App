// lib/app/modules/02_clinic_support/consultation_video_call/views/consultation_video_call_view.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../controllers/consultation_video_call_controller.dart';

class ConsultationVideoCallView extends GetView<ConsultationVideoCallController> {
  const ConsultationVideoCallView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // ---------------------------------------------
          // LAYER 1: VIDEO LAWAN BICARA (FULL SCREEN)
          // ---------------------------------------------
          Positioned.fill(
            child: Image.network(
              // GANTI URL INI DENGAN FOTO PAKAR/DOKTER YANG GANTENG/CANTIK
              // Atau pakai Image.asset("assets/images/dokter_dummy.jpg")
              "https://img.freepik.com/free-photo/portrait-smiling-male-doctor_171337-1532.jpg",
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey.shade900,
                child: const Center(child: Icon(Icons.person, size: 100, color: Colors.grey)),
              ),
            ),
          ),

          // Gradient overlay biar tulisan di atas & tombol di bawah kebaca
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
            ),
          ),

          // ---------------------------------------------
          // LAYER 2: HEADER INFO (NAMA & DURASI)
          // ---------------------------------------------
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Nama Pakar (Kalau argumen null, pake placeholder)
                    Text(
                      Get.arguments != null 
                        ? (controller.consultation.pakar.user.fullName) 
                        : "Dr. Budi Santoso, Sp.T", 
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(blurRadius: 5, color: Colors.black)],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Durasi Call
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Obx(() => Text(
                        controller.durationString.value,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ---------------------------------------------
          // LAYER 3: LOCAL VIDEO (PIP - Picture in Picture)
          // ---------------------------------------------
          Positioned(
            right: 20,
            top: 100, // Di bawah header
            child: Container(
              width: 100,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 10)],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                // Ganti ini dengan Image.asset foto profil user/lu sendiri
                child: Image.network(
                  "https://i.pravatar.cc/300", 
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // ---------------------------------------------
          // LAYER 4: TOMBOL KONTROL (BAWAH)
          // ---------------------------------------------
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Tombol Switch Camera
                    _buildCircleButton(
                      icon: FontAwesomeIcons.cameraRotate,
                      onTap: controller.switchCamera,
                      color: Colors.white.withOpacity(0.2),
                    ),
                    
                    // Tombol Mute
                    Obx(() => _buildCircleButton(
                      icon: controller.isMicMuted.value ? FontAwesomeIcons.microphoneSlash : FontAwesomeIcons.microphone,
                      onTap: controller.toggleMic,
                      color: controller.isMicMuted.value ? Colors.white : Colors.white.withOpacity(0.2),
                      iconColor: controller.isMicMuted.value ? Colors.black : Colors.white,
                    )),

                    // Tombol End Call (Merah Besar)
                    GestureDetector(
                      onTap: controller.endCall,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                          boxShadow: [BoxShadow(color: Colors.redAccent, blurRadius: 15, spreadRadius: 2)],
                        ),
                        child: const FaIcon(FontAwesomeIcons.phoneSlash, color: Colors.white, size: 32),
                      ),
                    ),

                    // Tombol Video Off
                     Obx(() => _buildCircleButton(
                      icon: controller.isCamOff.value ? FontAwesomeIcons.videoSlash : FontAwesomeIcons.video,
                      onTap: controller.toggleCam,
                      color: controller.isCamOff.value ? Colors.white : Colors.white.withOpacity(0.2),
                      iconColor: controller.isCamOff.value ? Colors.black : Colors.white,
                    )),

                    // Tombol Chat (Optional)
                    _buildCircleButton(
                      icon: FontAwesomeIcons.message,
                      onTap: () => Get.back(), // Balik ke chat
                      color: Colors.white.withOpacity(0.2),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleButton({
    required IconData icon, 
    required VoidCallback onTap, 
    required Color color,
    Color iconColor = Colors.white,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
        child: FaIcon(icon, color: iconColor, size: 24),
      ),
    );
  }
}