// // lib/app/modules/consultation_video_call/views/consultation_video_call_view.dart

// import 'package:agora_uikit/agora_uikit.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controllers/consultation_video_call_controller.dart';

// class ConsultationVideoCallView extends GetView<ConsultationVideoCallController> {
//   const ConsultationVideoCallView({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Obx(() {
//         // Tampilkan loading saat mengambil token RTC
//         if (controller.isLoadingToken.value || controller.agoraClient == null) {
//           return const Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 CircularProgressIndicator(),
//                 SizedBox(height: 16),
//                 Text("Menyambungkan ke Video Call...", style: TextStyle(color: Colors.white)),
//               ],
//             ),
//           );
//         }
        
//         // Setelah token siap, serahkan UI ke Agora UIKit
//         return SafeArea(
//           child: Stack(
//             children: [
//               // 1. Widget yang menampilkan video stream
//               AgoraVideoViewer(
//                 client: controller.agoraClient!,
//                 layoutType: Layout.floating, // Tampilan 1 besar, 1 kecil
//                 showAVState: true,
//               ),
              
//               // 2. Widget yang menampilkan tombol kontrol
//               // (Mute, End Call, Flip Camera, Toggle Video)
//               AgoraVideoButtons(
//                 client: controller.agoraClient!,
//                 enabledButtons: const [
//                   BuiltInButtons.toggleMic,
//                   BuiltInButtons.toggleCamera,
//                   BuiltInButtons.switchCamera,
//                   BuiltInButtons.callEnd, // Tombol ini otomatis memanggil leaveChannel
//                 ],
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/consultation_video_call_controller.dart';

class ConsultationVideoCallView extends GetView<ConsultationVideoCallController> {
  const ConsultationVideoCallView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ConsultationVideoCallView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ConsultationVideoCallView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}