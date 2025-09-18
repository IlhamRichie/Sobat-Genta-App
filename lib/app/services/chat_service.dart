// lib/app/services/chat_service.dart
// (Buat file baru)
import 'dart:io';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../data/models/chat_message_model.dart';
import 'session_service.dart';

class ChatService extends GetxService {
  late IO.Socket socket;
  final SessionService _sessionService = Get.find<SessionService>(); // Butuh auth token

  // Ini adalah 'stream' yang akan didengarkan oleh ChatRoomController
  final Rx<ChatMessageModel?> newIncomingMessage = Rxn<ChatMessageModel>();

  @override
  void onInit() {
    super.onInit();
    _initSocket();
  }

  void _initSocket() {
    // String authToken = _sessionService.token; // Ambil token auth
    
    socket = IO.io('http://YOUR_BACKEND_URL:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
      // 'extraHeaders': {'Authorization': 'Bearer $authToken'} // Kirim token
    });

    socket.onConnect((_) {
      print('Socket Terhubung');
      // Kirim event join dengan user ID
      socket.emit('join', _sessionService.currentUser.value!.userId);
    });

    // Listener global untuk 'pesan_baru' dari server
    socket.on('new_message_received', (data) {
      try {
        final message = ChatMessageModel.fromJson(data as Map<String, dynamic>);
        newIncomingMessage.value = message; // Kirim data ke listener
      } catch (e) {
        print("Gagal parsing pesan socket: $e");
      }
    });

    socket.onDisconnect((_) => print('Socket Terputus'));
    socket.onError((data) => print("Socket Error: $data"));
  }

  /// Metode untuk mengirim pesan teks
  void sendMessage(String text, String consultationId) {
    socket.emit('send_message', {
      'consultation_id': consultationId,
      'sender_id': _sessionService.currentUser.value!.userId,
      'message_content': text,
    });
  }

  /// Metode untuk mengirim gambar (akan di-handle API upload terpisah)
  void sendImage(File image, String consultationId) {
    // LOGIKA SEBENARNYA:
    // 1. Upload gambar ke IFileRepository (mendapat URL)
    // 2. Kirim 'sendMessage' dengan 'image_url: URL'
    
    // Simulasi:
    print("Simulasi kirim gambar: ${image.path}");
  }

  @override
  void onClose() {
    socket.dispose();
    super.onClose();
  }
}