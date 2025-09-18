// lib/data/repositories/implementations/fake_pakar_profile_repository.dart
// (Buat file baru)

import '../../models/availability_slot_model.dart';
import '../../models/pakar_profile_model.dart';
import '../abstract/pakar_profile_repository.dart';

class FakePakarProfileRepository implements IPakarProfileRepository {

  final List<Map<String, dynamic>> _mockPakarDatabase = [
    // 0: Drh. Santoso (PETERNAKAN)
    {
      "pakar_id": "PKR-001",
      "specialization": "Dokter Hewan (Spesialis Sapi)",
      "sip_number": "SIP-123456789",
      "consultation_fee": 50000.0,
      "is_available": true, // Buat Drh. Santoso online
      "user": {
        "user_id": "pakar_101",
        "full_name": "Drh. Budi Santoso",
        "email": "pakar@genta.com", "role": "EXPERT", "status": "VERIFIED"
      },
      "availability_schedule": [
        {"day_of_week": 1, "is_active": false, "start_time": "09:00", "end_time": "17:00"},
        {"day_of_week": 2, "is_active": false, "start_time": "09:00", "end_time": "17:00"},
        {"day_of_week": 3, "is_active": false, "start_time": "09:00", "end_time": "17:00"},
        {"day_of_week": 4, "is_active": false, "start_time": "09:00", "end_time": "17:00"},
        {"day_of_week": 5, "is_active": false, "start_time": "09:00", "end_time": "17:00"},
        {"day_of_week": 6, "is_active": false, "start_time": "09:00", "end_time": "17:00"},
        {"day_of_week": 7, "is_active": false, "start_time": "09:00", "end_time": "17:00"}
      ]
    },
    // 1: Pakar Pertanian
    {
      "pakar_id": "PKR-002",
      "specialization": "Ahli Hama & Penyakit Tanaman",
      "sip_number": "SIP-987654321",
      "consultation_fee": 45000.0,
      "is_available": false, // Offline
      "user": {
        "user_id": "pakar_102",
        "full_name": "Ir. Siti Aminah",
        "email": "sitipakar@genta.com", "role": "EXPERT", "status": "VERIFIED"
      },
      "availability_schedule": [
        {"day_of_week": 1, "is_active": false, "start_time": "09:00", "end_time": "17:00"},
        {"day_of_week": 2, "is_active": false, "start_time": "09:00", "end_time": "17:00"},
        {"day_of_week": 3, "is_active": false, "start_time": "09:00", "end_time": "17:00"},
        {"day_of_week": 4, "is_active": false, "start_time": "09:00", "end_time": "17:00"},
        {"day_of_week": 5, "is_active": false, "start_time": "09:00", "end_time": "17:00"},
        {"day_of_week": 6, "is_active": false, "start_time": "09:00", "end_time": "17:00"},
        {"day_of_week": 7, "is_active": false, "start_time": "09:00", "end_time": "17:00"}
      ]
    },
    // 2: Pakar Peternakan Lain
    {
      "pakar_id": "PKR-003",
      "specialization": "Ahli Nutrisi Unggas",
      "sip_number": "SIP-112233445",
      "consultation_fee": 40000.0,
      "is_available": true, // Online
      "user": {
        "user_id": "pakar_103",
        "full_name": "Dr. Rahmat Hidayat",
        "email": "rahmatpakar@genta.com", "role": "EXPERT", "status": "VERIFIED"
      },
      "availability_schedule": [
        {"day_of_week": 1, "is_active": false, "start_time": "09:00", "end_time": "17:00"},
        {"day_of_week": 2, "is_active": false, "start_time": "09:00", "end_time": "17:00"},
        {"day_of_week": 3, "is_active": false, "start_time": "09:00", "end_time": "17:00"},
        {"day_of_week": 4, "is_active": false, "start_time": "09:00", "end_time": "17:00"},
        {"day_of_week": 5, "is_active": false, "start_time": "09:00", "end_time": "17:00"},
        {"day_of_week": 6, "is_active": false, "start_time": "09:00", "end_time": "17:00"},
        {"day_of_week": 7, "is_active": false, "start_time": "09:00", "end_time": "17:00"}
      ]
    }
  ];

  @override
  Future<PakarProfileModel> getMyPakarProfile() async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Asumsi kita login sebagai Drh. Santoso (index 0)
    return PakarProfileModel.fromJson(_mockPakarDatabase[0]);
  }

  @override
  Future<void> updateAvailabilityStatus(bool isAvailable) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _mockPakarDatabase[0]['is_available'] = isAvailable;
    return;
  }

  @override
  Future<void> updatePakarProfileSettings(double consultationFee, List<AvailabilitySlot> schedule) async {
     await Future.delayed(const Duration(seconds: 1));
    _mockPakarDatabase[0]['consultation_fee'] = consultationFee;
    _mockPakarDatabase[0]['availability_schedule'] = schedule.map((s) => s.toJson()).toList();
    return;
  }

  @override
  Future<List<PakarProfileModel>> getPakarList(String? category) async {
    await Future.delayed(const Duration(seconds: 1));
    
    // Konversi semua data di DB
    final allPakar = _mockPakarDatabase.map((json) => PakarProfileModel.fromJson(json)).toList();

    // Filter berdasarkan kategori (jika ada)
    if (category != null) {
      if (category == 'PERTANIAN') {
        return allPakar.where((p) => p.specialization.contains("Tanaman") || p.specialization.contains("Hama")).toList();
      }
      if (category == 'PETERNAKAN') {
        return allPakar.where((p) => p.specialization.contains("Dokter Hewan") || p.specialization.contains("Unggas")).toList();
      }
    }
    
    // Kembalikan semua jika tidak ada filter
    return allPakar;
  }
}