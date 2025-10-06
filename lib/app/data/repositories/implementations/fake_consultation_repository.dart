// lib/data/repositories/implementations/fake_consultation_repository.dart

import 'package:get/get.dart';
import '../../../services/session_service.dart';
import '../../models/chat_message_model.dart';
import '../../models/consultation_model.dart';
import '../../models/rtc_token_model.dart';
import '../abstract/consultation_repository.dart';
import '../abstract/pakar_profile_repository.dart';
import '../abstract/wallet_repository.dart';

class FakeConsultationRepository implements IConsultationRepository {
  // Repository ini butuh dependensi lain untuk simulasi transaksi
  final IWalletRepository _walletRepo = Get.find<IWalletRepository>();
  final IPakarProfileRepository _pakarRepo = Get.find<IPakarProfileRepository>();
  final SessionService _sessionService = Get.find<SessionService>();

  // --- PERBAIKAN: Gunakan 'static final' untuk data mock ---
  // Ini menyelesaikan error 'initializer'

  static final Map<String, dynamic> _mockPakarUser = {
    "user_id": "pakar_101",
    "full_name": "Drh. Budi Santoso",
    "email": "pakar@genta.com",
    "role": "EXPERT",
    "status": "VERIFIED"
  };

  static final Map<String, dynamic> _mockPetaniUser = {
    "user_id": "farmer_123",
    "full_name": "Budi (Petani)",
    "email": "petani@genta.com",
    "role": "FARMER",
    "status": "VERIFIED"
  };

  static final Map<String, dynamic> _mockPakarProfile = {
    "pakar_id": "PKR-001",
    "specialization": "Dokter Hewan",
    "sip_number": "SIP-123",
    "consultation_fee": 50000.0,
    "is_available": true,
    "user": _mockPakarUser, // Sekarang valid karena _mockPakarUser adalah static
    "availability_schedule": []
  };
  // --------------------------------------------------------

  // Database palsu ini harus stateful (bisa diubah), jadi JANGAN static
  final List<Map<String, dynamic>> _mockConsultationDB = [];

  @override
  Future<ConsultationModel> createConsultationSession(
      String pakarId, double fee) async {
    await Future.delayed(const Duration(seconds: 1)); // Delay validasi

    // 1. Cek Saldo (Langkah I6 Skenario 3)
    final wallet = await _walletRepo.getMyWallet();
    if (wallet.balance < fee) {
      throw Exception("Saldo Dompet tidak cukup. Harap Top Up.");
    }

    // 2. Debit Dompet (Jika saldo cukup)
    await _walletRepo.debitWallet(fee);

    await Future.delayed(const Duration(seconds: 1)); // Delay pembuatan sesi

    // 3. Buat Sesi Konsultasi Palsu
    // Kita perlu data Pakar dan data User
    
    // (Kita cheat, pakai data pakar Dr. Santoso yang static)
    final pakarProfileData = _mockPakarProfile; 
    final currentUser = _sessionService.currentUser.value!;

    final Map<String, dynamic> fakeSessionJson = {
      "consultation_id": "CONS-${DateTime.now().millisecondsSinceEpoch}",
      "user": {
        // Data Budi (Petani)
        "user_id": currentUser.userId,
        "full_name": currentUser.fullName,
        "email": currentUser.email,
        "role": "FARMER", "status": "VERIFIED"
      },
      "pakar": pakarProfileData, // Gunakan data static
      "status": "ACTIVE" // Pembayaran sukses, sesi aktif
    };

    // --- UPDATE: Simpan sesi baru ke DB palsu kita ---
    _mockConsultationDB.insert(0, fakeSessionJson);

    return ConsultationModel.fromJson(fakeSessionJson);
  }

  @override
  Future<List<ChatMessageModel>> getChatHistory(String consultationId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Data mock riwayat chat
    final List<Map<String, dynamic>> fakeHistory = [
      {
        "message_id": "MSG-002",
        "consultation_id": consultationId,
        "sender_id": "pakar_101", // Drh. Santoso
        "message_content":
            "Baik Pak Budi, ini gejala awal PMK. Segera isolasi.",
        "image_url": null,
        "timestamp": "2024-11-20T10:05:00Z"
      },
      {
        "message_id": "MSG-001",
        "consultation_id": consultationId,
        "sender_id": "farmer_123", // Budi (asumsi ID-nya)
        "message_content": "Halo Dok, sapi saya tidak mau makan.",
        "image_url": "https://example.com/sapi_sakit.jpg", // Skenario Budi
        "timestamp": "2024-11-20T10:03:00Z"
      }
    ];

    return fakeHistory.map((json) => ChatMessageModel.fromJson(json)).toList();
  }

  @override
  Future<RtcTokenModel> getRtcToken(String consultationId) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final fakeCredentials = {
      "app_id": "YOUR_AGORA_APP_ID", // HARUS DIISI
      "channel_name": "channel_$consultationId",
      "rtc_token": "YOUR_TEMPORARY_AGORA_TOKEN" // HARUS DIISI
    };

    if (fakeCredentials["app_id"] == "YOUR_AGORA_APP_ID") {
      throw Exception(
          "Fitur Video Call belum dikonfigurasi. Harap masukkan App ID Agora di FakeConsultationRepository.");
    }

    return RtcTokenModel.fromJson(fakeCredentials);
  }

  // --- IMPLEMENTASI METODE YANG HILANG DARI TURN SEBELUMNYA ---
  @override
  Future<List<ConsultationModel>> getMyConsultationList() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Kembalikan semua yang ada di DB palsu
    return _mockConsultationDB
        .map((json) => ConsultationModel.fromJson(json))
        .toList();
  }
}