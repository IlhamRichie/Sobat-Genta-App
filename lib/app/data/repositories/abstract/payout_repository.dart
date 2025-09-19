// lib/data/repositories/abstract/payout_repository.dart
// (Buat file baru)

abstract class IPayoutRepository {
  /// Mengirim permintaan penarikan dana ke rekening bank spesifik
  Future<void> requestPayout({
    required double amount,
    required String bankAccountId, // ID Rekening tujuan
  });
}