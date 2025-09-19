// lib/app/modules/consultation_chat_room/controllers/consultation_chat_room_controller.dart

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../data/models/chat_message_model.dart';
import '../../../../data/models/consultation_model.dart';
import '../../../../data/repositories/abstract/consultation_repository.dart';
import '../../../../routes/app_pages.dart';
import '../../../../services/chat_service.dart';
import '../../../../services/session_service.dart';

class ConsultationChatRoomController extends GetxController {

  // --- DEPENDENCIES ---
  final IConsultationRepository _consultationRepo = Get.find<IConsultationRepository>();
  final ChatService _chatService = Get.find<ChatService>();
  final SessionService _sessionService = Get.find<SessionService>();

  // --- STATE ---
  final TextEditingController textC = TextEditingController();
  final RxBool isLoadingHistory = true.obs;
  final RxList<ChatMessageModel> messageList = <ChatMessageModel>[].obs;
  
  late final ConsultationModel consultation; // Data sesi dari argumen
  late final String currentUserId;
  late StreamSubscription _messageSubscription; // Listener socket

  @override
  void onInit() {
    super.onInit();
    consultation = Get.arguments as ConsultationModel;
    currentUserId = _sessionService.currentUser.value!.userId;
    
    fetchChatHistory();
    
    // 3. Mulai MENDENGARKAN pesan baru dari ChatService
    _messageSubscription = _chatService.newIncomingMessage.listen(_onNewMessageReceived);
  }

  @override
  void onClose() {
    textC.dispose();
    _messageSubscription.cancel(); // Wajib stop listener
    super.onClose();
  }

  /// 1. Mengambil riwayat chat dari REST API
  Future<void> fetchChatHistory() async {
    isLoadingHistory.value = true;
    try {
      final history = await _consultationRepo.getChatHistory(consultation.consultationId);
      messageList.assignAll(history);
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat riwayat chat.");
    } finally {
      isLoadingHistory.value = false;
    }
  }

  /// 2. Listener: Dipanggil oleh ChatService jika ada pesan baru
  void _onNewMessageReceived(ChatMessageModel? message) {
    if (message != null && message.consultationId == consultation.consultationId) {
      // Tambahkan pesan baru ke paling atas list
      messageList.insert(0, message);
    }
  }

  /// 4. Mengirim pesan teks (via Socket Service)
  void sendTextMessage() {
    if (textC.text.isEmpty) return;
    
    // Panggil service untuk kirim
    // _chatService.sendMessage(textC.text, consultation.consultationId);
    
    // Optimistic UI Update: Langsung tambahkan pesan kita ke list
    // tanpa menunggu balasan server (server akan kirim ke penerima)
    final optimisticMessage = ChatMessageModel(
      messageId: "temp_${DateTime.now().millisecondsSinceEpoch}",
      consultationId: consultation.consultationId,
      senderId: currentUserId,
      messageContent: textC.text,
      timestamp: DateTime.now(),
    );
    messageList.insert(0, optimisticMessage);
    
    textC.clear();
  }

  /// 5. Mengirim lampiran foto (Skenario 3)
  Future<void> sendImageAttachment() async {
    try {
      final XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final file = File(pickedFile.path);
        // Panggil service untuk upload & kirim
        // _chatService.sendImage(file, consultation.consultationId);
        
        // Optimistic UI (simulasi)
         final optimisticMessage = ChatMessageModel(
            messageId: "temp_img_${DateTime.now().millisecondsSinceEpoch}",
            consultationId: consultation.consultationId,
            senderId: currentUserId,
            imageUrl: file.path, // Tampilkan dari path lokal dulu
            timestamp: DateTime.now(),
         );
         messageList.insert(0, optimisticMessage);
      }
    } catch (e) {
       Get.snackbar("Error", "Gagal memilih gambar.");
    }
  }

  /// 6. Navigasi ke Video Call
  void goToVideoCall() {
    Get.toNamed(Routes.CONSULTATION_VIDEO_CALL, arguments: consultation);
  }
}