// lib/data/repositories/implementations/fake_investment_repository.dart
// (Buat file baru)

import '../../models/investment_model.dart';
import '../abstract/investment_repository.dart';

class FakeInvestmentRepository implements IInvestmentRepository {

  // Kita hardcode data investasi palsu.
  // Ini mensimulasikan data dari tabel 'investments' yang sudah di-JOIN
  // dengan tabel 'projects'
  final List<Map<String, dynamic>> _mockMyInvestments = [
    {
      "investment_id": "INV-001",
      "amount": 25000000.0, // Investasi Citra 25 Juta
      "timestamp": "2024-10-20T10:00:00Z",
      "project": {
        // Ini adalah data mock dari PROJ-002 (Kandang Sapi)
        "project_id": "PROJ-002",
        "title": "Perluasan Kandang Sapi Perah",
        "target_fund": 75000000.0,
        "collected_fund": 55000000.0, // (Asumsi sudah bertambah 25jt dari kita)
        "status": "PUBLISHED", 
        "asset_name": "Peternakan Sapi Perah",
        "description": "...", "duration_days": 120, "roi_percentage": 18.0,
        "rab_details_json": [], "farmer_profile": {}
      }
    },
    {
      "investment_id": "INV-002",
      "amount": 50000000.0, // Investasi sebelumnya
      "timestamp": "2024-08-01T09:00:00Z",
      "project": {
        // Ini adalah data mock dari PROJ-001 (Bawang)
        "project_id": "PROJ-001",
        "title": "Siklus Tanam Bawang Merah Super",
        "target_fund": 50000000.0,
        "collected_fund": 50000000.0,
        "status": "FUNDED", // Proyek ini sudah didanai penuh
        "asset_name": "Lahan Subur Utama",
        "description": "...", "duration_days": 90, "roi_percentage": 15.0,
        "rab_details_json": [], "farmer_profile": {}
      }
    }
  ];


  @override
  Future<List<InvestmentModel>> getMyInvestments() async {
    await Future.delayed(const Duration(seconds: 1));
    return _mockMyInvestments.map((json) => InvestmentModel.fromJson(json)).toList();
  }
}