// lib/data/repositories/abstract/consultation_repository.dart
// (Buat file baru)

import '../../models/chat_message_model.dart';
import '../../models/consultation_model.dart';
import '../../models/rtc_token_model.dart';

abstract class IConsultationRepository {
  /// Memulai/membuat sesi konsultasi baru.
  /// Ini adalah metode transaksional (termasuk pembayaran).
  Future<ConsultationModel> createConsultationSession(String pakarId, double fee);

  Future<List<ChatMessageModel>> getChatHistory(String consultationId);

  Future<RtcTokenModel> getRtcToken(String consultationId);

  Future<List<ConsultationModel>> getMyConsultationList();

}