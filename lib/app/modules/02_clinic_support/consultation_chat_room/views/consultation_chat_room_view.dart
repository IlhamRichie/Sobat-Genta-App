// lib/app/modules/consultation_chat_room/views/consultation_chat_room_view.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../data/models/chat_message_model.dart';
import '../../../../theme/app_colors.dart';
import '../controllers/consultation_chat_room_controller.dart';

class ConsultationChatRoomView extends GetView<ConsultationChatRoomController> {
  const ConsultationChatRoomView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(controller.consultation.pakar.user.fullName), // Nama Pakar
            Text(
              controller.consultation.pakar.specialization,
              style: Get.textTheme.bodySmall?.copyWith(color: Colors.white70),
            ),
          ],
        ),
        actions: [
          // Tombol Video Call
          IconButton(
            onPressed: controller.goToVideoCall,
            icon: const FaIcon(FontAwesomeIcons.video),
          ),
          IconButton(
            onPressed: () { /* TODO: Opsi lain (end chat) */ },
            icon: const FaIcon(FontAwesomeIcons.ellipsisVertical),
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Area List Chat
          Expanded(
            child: Obx(() {
              if (controller.isLoadingHistory.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.messageList.isEmpty) {
                return const Center(child: Text("Mulai percakapan Anda..."));
              }
              
              // Gunakan ListView.builder dengan reverse: true
              return ListView.builder(
                reverse: true, // Chat dimulai dari bawah
                padding: const EdgeInsets.all(16),
                itemCount: controller.messageList.length,
                itemBuilder: (context, index) {
                  final message = controller.messageList[index];
                  // Cek apakah pesan ini dari user saat ini
                  final isMe = message.senderId == controller.currentUserId;
                  return _buildChatBubble(message, isMe);
                },
              );
            }),
          ),
          
          // 2. Area Input Teks
          _buildTextInputArea(),
        ],
      ),
    );
  }

  /// Area Input di bagian bawah
  Widget _buildTextInputArea() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Tombol Lampiran (Skenario 3)
            IconButton(
              icon: const FaIcon(FontAwesomeIcons.paperclip, color: AppColors.textLight),
              onPressed: controller.sendImageAttachment,
            ),
            // Field Teks
            Expanded(
              child: TextField(
                controller: controller.textC,
                decoration: InputDecoration(
                  hintText: "Ketik pesan...",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: Colors.grey.shade300)),
                  filled: true,
                  fillColor: AppColors.greyLight,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                textInputAction: TextInputAction.send,
                onSubmitted: (value) => controller.sendTextMessage(),
              ),
            ),
            const SizedBox(width: 8),
            // Tombol Kirim
            FilledButton(
              onPressed: controller.sendTextMessage,
              style: FilledButton.styleFrom(shape: const CircleBorder(), padding: const EdgeInsets.all(16)),
              child: const FaIcon(FontAwesomeIcons.paperPlane, size: 20),
            ),
          ],
        ),
      ),
    );
  }
  
  /// Widget untuk satu gelembung chat
  Widget _buildChatBubble(ChatMessageModel message, bool isMe) {
    final alignment = isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final color = isMe ? AppColors.primary : AppColors.greyLight;
    final textColor = isMe ? Colors.white : AppColors.textDark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            constraints: BoxConstraints(maxWidth: Get.width * 0.75),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tampilkan gambar jika ada
                if (message.imageUrl != null)
                  _buildImageAttachment(message.imageUrl!),
                  
                // Tampilkan teks jika ada
                if (message.messageContent != null && message.messageContent!.isNotEmpty)
                  Text(
                    message.messageContent!,
                    style: TextStyle(color: textColor, fontSize: 16, height: 1.4),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(DateFormat('HH:mm').format(message.timestamp), style: Get.textTheme.bodySmall),
        ],
      ),
    );
  }
  
  Widget _buildImageAttachment(String imageUrl) {
     // Cek apakah gambar dari path lokal (optimistic) atau URL network
    bool isLocalFile = !imageUrl.startsWith('http');
    
    return Container(
      height: 150,
      width: Get.width * 0.7,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: isLocalFile 
              ? FileImage(File(imageUrl)) as ImageProvider 
              : NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}