// lib/data/models/availability_slot_model.dart
// (Buat file baru)

import 'package:get/get.dart';

class AvailabilitySlot {
  final int dayOfWeek; // 1 = Senin, 7 = Minggu (sesuai Dart DateTime.weekday)
  final String dayName;
  RxBool isActive;
  RxString startTime; // Format "HH:mm"
  RxString endTime;   // Format "HH:mm"

  AvailabilitySlot({
    required this.dayOfWeek,
    required this.dayName,
    bool isActive = false,
    String startTime = "09:00",
    String endTime = "17:00",
  }) : this.isActive = isActive.obs,
       this.startTime = startTime.obs,
       this.endTime = endTime.obs;
       
  // Konversi ke JSON untuk dikirim ke API
  Map<String, dynamic> toJson() {
    return {
      'day_of_week': dayOfWeek,
      'is_active': isActive.value,
      'start_time': startTime.value,
      'end_time': endTime.value,
    };
  }

  factory AvailabilitySlot.fromJson(Map<String, dynamic> json) {
    List<String> days = ["", "Senin", "Selasa", "Rabu", "Kamis", "Jumat", "Sabtu", "Minggu"];
    int dayIndex = (json['day_of_week'] as num?)?.toInt() ?? 1;
    
    return AvailabilitySlot(
      dayOfWeek: dayIndex,
      dayName: days[dayIndex],
      isActive: json['is_active'] ?? false,
      startTime: json['start_time'] ?? "09:00",
      endTime: json['end_time'] ?? "17:00",
    );
  }
}