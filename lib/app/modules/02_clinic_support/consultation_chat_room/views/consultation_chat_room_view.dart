import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:get/get.dart';
import 'package:sobatgenta/app/modules/02_clinic_support/clinic_expert_profile/views/clinic_expert_profile_view.dart';
import '../controllers/consultation_chat_room_controller.dart';

// ... (Konstanta warna tetap sama)

// --- [FIX] Ubah dari GetView menjadi StatelessWidget ---
class ConsultationChatRoomView extends StatelessWidget {
  const ConsultationChatRoomView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConsultationChatRoomController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 1,
            centerTitle: false,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: kDarkTextColor),
              onPressed: () => Get.back(),
            ),
            // PERBAIKAN: Bungkus Row di dalam `title` dengan Expanded
            title: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(controller.expertData.imageUrl),
                ),
                const SizedBox(width: 12),
                
                // PERBAIKAN: Bungkus Column dengan Expanded untuk mencegah overflowed
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.expertData.name,
                        style: const TextStyle(
                          color: kDarkTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        overflow: TextOverflow.ellipsis, // Tambahkan ellipsis
                        maxLines: 1, // Pastikan hanya satu baris
                      ),
                      Text(
                        controller.expertData.isOnline ? 'Online' : 'Offline',
                        style: TextStyle(
                          color: controller.expertData.isOnline ? kPrimaryDarkGreen : kBodyTextColor,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                onPressed: () {
                  // (TODO: Tambahkan logic untuk Audio Call nanti)
                },
                icon: const Icon(Icons.phone_outlined, color: kPrimaryDarkGreen),
              ),
              IconButton(
                onPressed: () => controller.goToVideoCallPage(),
                icon: const Icon(Icons.videocam_outlined, color: kPrimaryDarkGreen),
              ),
              const SizedBox(width: 10),
            ],
          ),
          body: Chat(
            messages: controller.messages,
            onSendPressed: controller.onSendPressed,
            user: controller.currentUser,
            theme: DefaultChatTheme(
              primaryColor: kPrimaryDarkGreen,
              secondaryColor: kLightGreenBlob,
              inputBackgroundColor: Colors.white,
              inputTextColor: kDarkTextColor,
              sendButtonIcon: const Icon(Icons.send, color: kPrimaryDarkGreen),
              sentMessageBodyTextStyle: const TextStyle(
                color: Colors.white, fontSize: 16, fontFamily: 'Inter',
              ),
              receivedMessageBodyTextStyle: const TextStyle(
                color: kDarkTextColor, fontSize: 16, fontFamily: 'Inter',
              ),
              messageBorderRadius: 16,
              inputBorderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              inputContainerDecoration: BoxDecoration(
                border: Border(top: BorderSide(color: kBodyTextColor.withOpacity(0.3))),
              ),
            ),
            showUserAvatars: true,
            showUserNames: true,
          ),
        );
      },
    );
  }
}