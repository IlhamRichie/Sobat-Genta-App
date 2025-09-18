// lib/data/repositories/abstract/pakar_profile_repository.dart
// (Buat file baru)

import '../../models/availability_slot_model.dart';
import '../../models/pakar_profile_model.dart';

abstract class IPakarProfileRepository {
  /// Mengambil data profil pakar yang sedang login
  Future<PakarProfileModel> getMyPakarProfile();
  
  /// Mengubah status ketersediaan (Online/Offline)
  Future<void> updateAvailabilityStatus(bool isAvailable);

  Future<void> updatePakarProfileSettings(double consultationFee, List<AvailabilitySlot> schedule);

  Future<List<PakarProfileModel>> getPakarList(String? category);
}