// lib/data/repositories/abstract/wallet_repository.dart
// (Buat file baru)

import '../../models/payment_transaction_model.dart';
import '../../models/wallet_model.dart';
import '../../models/wallet_transaction_model.dart';

abstract class IWalletRepository {
  /// Mengambil data dompet user yang sedang login
  Future<WalletModel> getMyWallet();
  // (Nanti kita akan tambahkan topUp, withdraw, dll di sini)

  Future<WalletModel> debitWallet(double amount); 

  Future<PaymentTransactionModel> requestTopUp(double amount);

  Future<List<WalletTransactionModel>> getWalletHistory(int page, {int limit = 20});

}