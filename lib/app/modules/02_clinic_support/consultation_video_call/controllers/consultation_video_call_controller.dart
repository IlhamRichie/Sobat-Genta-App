import 'dart:async';
import 'package:get/get.dart';
import '../../../../data/models/expert_model.dart';

class ConsultationVideoCallController extends GetxController {

  late ExpertModel expertData;
  late Timer _timer;

  // --- State UI Panggilan ---
  final RxBool isMicMuted = false.obs;
  final RxBool isCameraOff = false.obs;
  final Rx<Duration> callDuration = Duration.zero.obs;

  // (Dummy data untuk 'self-view' Anda)
  final String localUserImage = 'https://picsum.photos/seed/user/200';

  @override
  void onInit() {
    super.onInit();
    // 1. Tangkap data Pakar
    expertData = Get.arguments as ExpertModel;
    // 2. Mulai timer durasi panggilan
    startCallTimer();
  }

  @override
  void onClose() {
    _timer.cancel(); // Matikan timer saat halaman ditutup
    super.onClose();
  }

  // --- Logic Aksi ---
  
  void startCallTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      callDuration.value += const Duration(seconds: 1);
    });
  }
  
  // Format durasi (00:00)
  String get formattedDuration {
    final minutes = callDuration.value.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = callDuration.value.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void toggleMic() {
    isMicMuted.value = !isMicMuted.value;
  }

  void toggleCamera() {
    isCameraOff.value = !isCameraOff.value;
  }

  void endCall() {
    _timer.cancel();
    Get.back(); // Kembali ke ruang chat
  }
}