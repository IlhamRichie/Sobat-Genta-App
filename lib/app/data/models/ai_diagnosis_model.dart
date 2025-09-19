// lib/data/models/ai_diagnosis_model.dart
// (Buat file baru)

class AiDiagnosisModel {
  final String diseaseName;
  final double confidenceScore; // Skor keyakinan (misal: 0.95)
  final String description;
  final String firstAidSolution; // Solusi pertolongan pertama
  final String suggestedPakarCategory; // Data PENTING untuk upsell (Misal: "PERTANIAN")

  AiDiagnosisModel({
    required this.diseaseName,
    required this.confidenceScore,
    required this.description,
    required this.firstAidSolution,
    required this.suggestedPakarCategory,
  });

  factory AiDiagnosisModel.fromJson(Map<String, dynamic> json) {
    return AiDiagnosisModel(
      diseaseName: json['disease_name'],
      confidenceScore: (json['confidence_score'] as num).toDouble(),
      description: json['description'],
      firstAidSolution: json['first_aid_solution'],
      suggestedPakarCategory: json['suggested_pakar_category'], // Kategori untuk dilempar ke Klinik
    );
  }
}