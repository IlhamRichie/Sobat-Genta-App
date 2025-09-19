// lib/data/repositories/implementations/fake_payout_repository.dart
// (Buat file baru)

import '../abstract/payout_repository.dart';

class FakePayoutRepository implements IPayoutRepository {

  @override
  Future<void> requestPayout({
    required double amount,
    required String bankAccountId,
  }) async {
    await Future.delayed(const Duration(seconds: 2)); // Simulasi API

    // Backend akan membuat 'payout_ticket' dengan status PENDING_APPROVAL.
    // Saldo user TIDAK langsung berkurang. Saldo "tertahan" (on-hold).
    // Karena simulasi kita sederhana, kita anggap permintaan sukses diterima.
    
    print("--- FAKE PAYOUT REQUEST SENT ---");
    print("Amount: $amount TO Bank Account ID: $bankAccountId");
    
    // Simulasi jika gagal (jarang)
    // throw Exception("Gagal menghubungi layanan payout");
  }
}