// lib/data/models/pakar_profile_model.dart
// (Buat file baru)

import 'package:sobatgenta/app/data/models/availability_slot_model.dart';

import 'user_model.dart';

class PakarProfileModel {
  final String pakarId;
  final User user; // Data user umum (nama, email)
  final String specialization;
  final String sipNumber;
  final double consultationFee;
  final bool isAvailable; // <-- DATA KUNCI

  final List<AvailabilitySlot> schedule;

  PakarProfileModel({
    required this.pakarId,
    required this.user,
    required this.specialization,
    required this.sipNumber,
    required this.consultationFee,
    required this.isAvailable,

    required this.schedule,
  });

  factory PakarProfileModel.fromJson(Map<String, dynamic> json) {
    // Parsing Jadwal
    List<AvailabilitySlot> parsedSchedule = [];
    if (json['availability_schedule'] != null && json['availability_schedule'] is List) {
      parsedSchedule = (json['availability_schedule'] as List)
          .map((item) => AvailabilitySlot.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      // Buat jadwal default jika kosong
      parsedSchedule = [
        AvailabilitySlot(dayOfWeek: 1, dayName: "Senin"),
        AvailabilitySlot(dayOfWeek: 2, dayName: "Selasa"),
        AvailabilitySlot(dayOfWeek: 3, dayName: "Rabu"),
        AvailabilitySlot(dayOfWeek: 4, dayName: "Kamis"),
        AvailabilitySlot(dayOfWeek: 5, dayName: "Jumat"),
        AvailabilitySlot(dayOfWeek: 6, dayName: "Sabtu"),
        AvailabilitySlot(dayOfWeek: 7, dayName: "Minggu"),
      ];
    }

    return PakarProfileModel(
      pakarId: json['pakar_id'].toString(),
      // Asumsi API melakukan JOIN dan menyertakan data user
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      specialization: json['specialization'] ?? 'N/A',
      sipNumber: json['sip_number'] ?? 'N/A',
      consultationFee: (json['consultation_fee'] as num?)?.toDouble() ?? 50000.0,
      isAvailable: json['is_available'] ?? false,

      schedule: parsedSchedule,
    );
  }
}