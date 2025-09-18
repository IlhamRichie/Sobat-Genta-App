// lib/data/models/consultation_model.dart
// (Buat file baru)

import 'pakar_profile_model.dart';
import 'user_model.dart';

enum ConsultationStatus { PENDING_PAYMENT, ACTIVE, COMPLETED, CANCELED }

class ConsultationModel {
  final String consultationId;
  final User user; // Info Petani
  final PakarProfileModel pakar; // Info Pakar
  final ConsultationStatus status;

  ConsultationModel({
    required this.consultationId,
    required this.user,
    required this.pakar,
    required this.status,
  });

  factory ConsultationModel.fromJson(Map<String, dynamic> json) {
    return ConsultationModel(
      consultationId: json['consultation_id'].toString(),
      user: User.fromJson(json['user']),
      pakar: PakarProfileModel.fromJson(json['pakar']),
      status: _parseStatus(json['status']),
    );
  }
  
  static ConsultationStatus _parseStatus(String? status) {
    // (Tambahkan logika parsing status)
    return ConsultationStatus.ACTIVE;
  }
}