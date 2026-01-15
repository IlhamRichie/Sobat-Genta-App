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
      backgroundColor: const Color(0xFFE5DDD5), // Warna background ala WhatsApp (opsional) atau F5F6F8
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // 1. Area List Chat
          Expanded(
            child: Obx(() {
              if (controller.isLoadingHistory.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.messageList.isEmpty) {
                return _buildEmptyState();
              }
              
              return ListView.builder(
                reverse: true, // Chat dari bawah ke atas
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                itemCount: controller.messageList.length,
                itemBuilder: (context, index) {
                  final message = controller.messageList[index];
                  final isMe = message.senderId == controller.currentUserId;
                  
                  // Logic untuk grouping waktu (opsional, bisa dikembangkan)
                  return _buildChatBubble(message, isMe);
                },
              );
            }),
          ),
          
          // 2. Area Input Teks
          _buildInputArea(),
        ],
      ),
    );
  }

  /// AppBar dengan Profil Dokter
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      titleSpacing: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Get.back(),
      ),
      title: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white24,
            child: const FaIcon(FontAwesomeIcons.userDoctor, size: 20, color: Colors.white),
            // backgroundImageUrl: NetworkImage(...) // Kalau ada foto
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.consultation.pakar.user.fullName,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "Online", // Bisa dibuat dinamis dari controller
                  style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.8)),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: controller.goToVideoCall,
          icon: const FaIcon(FontAwesomeIcons.video, size: 18),
          tooltip: "Video Call",
        ),
        IconButton(
          onPressed: () {}, 
          icon: const FaIcon(FontAwesomeIcons.phone, size: 18),
          tooltip: "Voice Call",
        ),
        PopupMenuButton(
          icon: const Icon(Icons.more_vert),
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'end', child: Text("Akhiri Sesi")),
            const PopupMenuItem(value: 'report', child: Text("Laporkan")),
          ],
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "👋",
              style: TextStyle(fontSize: 40),
            ),
            const SizedBox(height: 10),
            Text(
              "Mulai konsultasi dengan\nDr. ${controller.consultation.pakar.user.fullName}",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  /// Bubble Chat Modern
  Widget _buildChatBubble(ChatMessageModel message, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        constraints: BoxConstraints(maxWidth: Get.width * 0.75),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFFDCF8C6) : Colors.white, // Hijau WA vs Putih
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: isMe ? const Radius.circular(12) : Radius.zero, // Ekor kiri
            bottomRight: isMe ? Radius.zero : const Radius.circular(12), // Ekor kanan
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0), // Padding luar konten
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // A. GAMBAR (Jika Ada)
              if (message.imageUrl != null)
                _buildImageAttachment(message.imageUrl!),

              // B. TEKS (Jika Ada)
              if (message.messageContent != null && message.messageContent!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                  child: Text(
                    message.messageContent!,
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ),

              // C. WAKTU
              Padding(
                padding: const EdgeInsets.only(right: 6, bottom: 2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Spacer biar waktu di kanan
                    if (message.messageContent != null) const SizedBox(width: 40), 
                    Text(
                      DateFormat('HH:mm').format(message.timestamp),
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                    ),
                    if (isMe) ...[
                      const SizedBox(width: 4),
                      const Icon(Icons.done_all, size: 14, color: Colors.blue), // Read receipt
                    ]
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget Gambar dengan Error Handling (Anti Crash)
  Widget _buildImageAttachment(String imageUrl) {
    bool isLocalFile = !imageUrl.startsWith('http');

    return Container(
      constraints: const BoxConstraints(maxHeight: 250),
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: isLocalFile
            ? Image.file(
                File(imageUrl),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _buildErrorImage(),
              )
            : Image.network(
                imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 150,
                    color: Colors.grey.shade200,
                    child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                  );
                },
                // --- SOLUSI CRASH DI SINI ---
                errorBuilder: (context, error, stackTrace) {
                  return _buildErrorImage();
                },
              ),
      ),
    );
  }

  /// Placeholder kalau gambar gagal load (404)
  Widget _buildErrorImage() {
    return Container(
      height: 150,
      width: double.infinity,
      color: Colors.grey.shade200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.broken_image, color: Colors.grey.shade400, size: 40),
          const SizedBox(height: 8),
          Text(
            "Gagal memuat gambar",
            style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
          ),
        ],
      ),
    );
  }

  /// Input Area
  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      color: Colors.white,
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const FaIcon(FontAwesomeIcons.plus, color: AppColors.primary),
              onPressed: controller.sendImageAttachment,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F6F8),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: controller.textC,
                  decoration: const InputDecoration(
                    hintText: "Ketik pesan...",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  minLines: 1,
                  maxLines: 5,
                  textInputAction: TextInputAction.newline,
                ),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: AppColors.primary,
              radius: 22,
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white, size: 20),
                onPressed: controller.sendTextMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}