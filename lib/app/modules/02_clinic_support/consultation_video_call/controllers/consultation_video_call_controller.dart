// // lib/app/modules/consultation_video_call/controllers/consultation_video_call_controller.dart

// import 'package:agora_uikit/agora_uikit.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:top_snackbar_flutter/custom_snack_bar.dart';
// import 'package:top_snackbar_flutter/top_snack_bar.dart';

// import '../../../../data/models/consultation_model.dart';
// import '../../../../data/models/rtc_token_model.dart';
// import '../../../../data/repositories/abstract/consultation_repository.dart';

// class ConsultationVideoCallController extends GetxController {

//   // --- DEPENDENCIES ---
//   final IConsultationRepository _consultationRepo = Get.find<IConsultationRepository>();
  
//   // --- STATE ---
//   late final ConsultationModel consultation;
//   final RxBool isLoadingToken = true.obs; // State untuk loading token
//   final RxBool hasJoinedCall = false.obs; // State untuk join channel
  
//   // --- AGORA SDK CONTROLLER ---
//   AgoraClient? agoraClient; // Controller dari package agora_uikit

//   @override
//   void onInit() {
//     super.onInit();
//     consultation = Get.arguments as ConsultationModel;
//     _initializeAgora();
//   }

//   /// 1. Mengambil token dan menginisialisasi klien
//   Future<void> _initializeAgora() async {
//     isLoadingToken.value = true;
    
//     try {
//       // 1. Ambil kredensial dari repo
//       final RtcTokenModel rtcData = await _consultationRepo.getRtcToken(consultation.consultationId);

//       // 2. Buat Klien Agora
//       agoraClient = AgoraClient(
//         agoraConnectionData: AgoraConnectionData(
//           appId: rtcData.appId,
//           channelName: rtcData.channelName,
//           tempToken: rtcData.rtcToken,
//           // (Anda bisa set username di sini jika perlu)
//         ),
//         enabledPermission: [
//           Permission.camera,
//           Permission.microphone,
//         ],
//         agoraEventHandlers: AgoraEventHandlers(
//           onJoinChannelSuccess: (channel, uid, elapsed) {
//             print("Berhasil Join Channel: $channel");
//             hasJoinedCall.value = true;
//           },
//           onUserOffline: (connection, remoteUid, reason) {
//             // Pengguna lain (Pakar/Petani) meninggalkan call
//             print("User $remoteUid meninggalkan panggilan.");
//             _leaveCall(); // Otomatis tinggalkan panggilan
//           },
//           onLeaveChannel: (connection, stats) {
//             print("Meninggalkan channel");
//             hasJoinedCall.value = false;
//           },
//         ),
//       );
      
//       // 3. Inisialisasi & Join Channel
//       await agoraClient!.initialize();
      
//     } catch (e) {
//       showTopSnackBar(
//         Overlay.of(Get.context!),
//         CustomSnackBar.error(message: "Gagal memulai video call: ${e.toString().replaceAll("Exception: ", "")}"),
//       );
//       // Gagal, kembali ke chat room
//       await Future.delayed(const Duration(seconds: 1));
//       Get.back();
//     } finally {
//       isLoadingToken.value = false;
//     }
//   }

//   /// 2. Meninggalkan panggilan
//   Future<void> _leaveCall() async {
//     // Navigasi kembali ke chat room
//     Get.back();
//   }

//   @override
//   void onClose() {
//     // BEST PRACTICE: WAJIB leave channel dan destroy engine
//     // saat controller ditutup untuk membebaskan kamera/mic.
//     if (agoraClient != null) {
//       agoraClient!.release();
//     }
//     super.onClose();
//   }
// }

import 'package:get/get.dart';

class ConsultationVideoCallController extends GetxController {
  //TODO: Implement ConsultationVideoCallController

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}