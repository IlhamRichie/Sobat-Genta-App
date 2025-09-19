// lib/data/repositories/implementations/fake_ai_diagnosis_repository.dart
// (Buat file baru)
import 'dart:io';

import '../../models/ai_diagnosis_model.dart';
import '../abstract/ai_diagnosis_repository.dart';

class FakeAiDiagnosisRepository implements IAiDiagnosisRepository {

  @override
  Future<AiDiagnosisModel> analyzeImage(File imageFile, String type) async {
    // Simulasi proses upload dan analisis AI Backend yang berat
    await Future.delayed(const Duration(seconds: 3));
    
    print("Fake AI Repo: Menerima gambar ${imageFile.path} untuk dianalisis...");
    
    // Kembalikan data diagnosis palsu (hardcoded)
    final fakeResponse = {
      "disease_name": "Bercak Daun (Cercospora)",
      "confidence_score": 0.92,
      "description": "Cercospora adalah jamur yang menyebabkan bercak coklat kering pada daun tanaman Anda, mengurangi kemampuan fotosintesis.",
      "first_aid_solution": "1. Segera isolasi dan pangkas daun yang terinfeksi.\n2. Berikan fungisida berbahan aktif Mankozeb.\n3. Kurangi kelembapan di sekitar tanaman.",
      "suggested_pakar_category": "PERTANIAN" // Data Upsell
    };
    
    return AiDiagnosisModel.fromJson(fakeResponse);
  }
}