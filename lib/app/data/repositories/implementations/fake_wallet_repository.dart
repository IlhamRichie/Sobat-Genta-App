// lib/data/repositories/implementations/fake_wallet_repository.dart
// (Buat file baru)

import '../../models/wallet_model.dart';
import '../abstract/wallet_repository.dart';

class FakeWalletRepository implements IWalletRepository {

  // Sesuai Skenario 2 (Citra), dia top-up Rp 100 Juta
  final Map<String, dynamic> _mockWalletData = {
    "wallet_id": "W-USER-001",
    "balance": 1250000.0 // Saldo Budi dari mock HomeDashboard
  };

  @override
  Future<WalletModel> getMyWallet() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return WalletModel.fromJson(_mockWalletData);
  }

  @override
  Future<WalletModel> debitWallet(double amount) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulasi transaksi
    
    double currentBalance = (_mockWalletData['balance'] as num).toDouble();
    
    if (amount > currentBalance) {
      throw Exception("Saldo Dompet tidak cukup.");
    }
    
    // Kurangi saldo di 'database' palsu kita
    _mockWalletData['balance'] = currentBalance - amount;
    
    print("Fake Wallet: Saldo didebit $amount. Sisa: ${_mockWalletData['balance']}");
    
    // Kembalikan data dompet yang sudah ter-update
    return WalletModel.fromJson(_mockWalletData);
  }
}