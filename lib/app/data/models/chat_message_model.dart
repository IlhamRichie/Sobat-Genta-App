// lib/data/models/chat_message_model.dart
// (Buat file baru)
class ChatMessageModel {
  final String messageId;
  final String consultationId;
  final String senderId; // ID dari User (Petani atau Pakar)
  final String? messageContent;
  final String? imageUrl; // Untuk lampiran foto
  final DateTime timestamp;

  ChatMessageModel({
    required this.messageId,
    required this.consultationId,
    required this.senderId,
    this.messageContent,
    this.imageUrl,
    required this.timestamp,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      messageId: json['message_id'].toString(),
      consultationId: json['consultation_id'].toString(),
      senderId: json['sender_id'].toString(),
      messageContent: json['message_content'],
      imageUrl: json['image_url'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}