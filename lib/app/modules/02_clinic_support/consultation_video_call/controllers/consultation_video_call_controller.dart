// lib/app/modules/02_clinic_support/consultation_video_call/controllers/consultation_video_call_controller.dart

import 'dart:async';
import 'package:get/get.dart';
import '../../../../data/models/consultation_model.dart';

class ConsultationVideoCallController extends GetxController {

  // --- STATE ---
  // Kita pura-pura ambil data konsultasi biar bisa nampilin nama pakar di layar
  late final ConsultationModel consultation; 
  
  // Timer biar keliatan detiknya jalan (Realism ++)
  final RxString durationString = "00:00".obs;
  Timer? _timer;
  int _seconds = 0;

  // Status mic & camera (UI only)
  final RxBool isMicMuted = false.obs;
  final RxBool isCamOff = false.obs;

  @override
  void onInit() {
    super.onInit();
    
    // Cek kalau ada arguments (dari chat room), kalau ga ada kita dummy aja biar ga error pas testing langsung
    if (Get.arguments != null) {
      consultation = Get.arguments as ConsultationModel;
    }
    
    // Start Timer palsu
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _seconds++;
      // Format ke mm:ss
      int min = _seconds ~/ 60;
      int sec = _seconds % 60;
      durationString.value = "${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}";
    });
  }

  void toggleMic() => isMicMuted.toggle();
  void toggleCam() => isCamOff.toggle();
  void switchCamera() {
    // Gimmick aja, ga ngapa2in wkwk
    Get.snackbar("Info", "Kamera ditukar", snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 1));
  }

  void endCall() {
    _timer?.cancel();
    Get.back(); // Balik ke chat
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}