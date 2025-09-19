// lib/data/repositories/abstract/ai_diagnosis_repository.dart
// (Buat file baru)
import 'dart:io';

import '../../models/ai_diagnosis_model.dart';

abstract class IAiDiagnosisRepository {
  /// Mengirim gambar untuk dianalisis oleh AI Backend
  Future<AiDiagnosisModel> analyzeImage(File imageFile, String type); // type: 'TANAMAN' atau 'TERNAK'
}