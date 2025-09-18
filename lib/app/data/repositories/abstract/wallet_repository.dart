// lib/data/repositories/abstract/wallet_repository.dart
// (Buat file baru)

import '../../models/wallet_model.dart';

abstract class IWalletRepository {
  /// Mengambil data dompet user yang sedang login
  Future<WalletModel> getMyWallet();
  // (Nanti kita akan tambahkan topUp, withdraw, dll di sini)

  Future<WalletModel> debitWallet(double amount); 
}