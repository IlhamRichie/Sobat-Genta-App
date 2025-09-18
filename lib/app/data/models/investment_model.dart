// lib/data/models/investment_model.dart
// (Buat file baru)

import 'project_model.dart';

class InvestmentModel {
  final String investmentId;
  final double amountInvested;  // <-- Data Kunci
  final String investmentDate;
  final ProjectModel project;     // <-- Data Proyek yang diinvestasikan

  InvestmentModel({
    required this.investmentId,
    required this.amountInvested,
    required this.investmentDate,
    required this.project,
  });

  factory InvestmentModel.fromJson(Map<String, dynamic> json) {
    return InvestmentModel(
      investmentId: json['investment_id'].toString(),
      amountInvested: (json['amount'] as num).toDouble(),
      investmentDate: json['timestamp'] ?? DateTime.now().toIso8601String(),
      // API backend harus melakukan JOIN dan menyertakan objek proyek
      project: ProjectModel.fromJson(json['project'] as Map<String, dynamic>),
    );
  }
}