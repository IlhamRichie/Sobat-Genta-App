// lib/data/repositories/abstract/investment_repository.dart
// (Buat file baru)

import '../../models/investment_model.dart';

abstract class IInvestmentRepository {
  /// Mengambil semua data investasi milik user yang sedang login
  Future<List<InvestmentModel>> getMyInvestments();
}