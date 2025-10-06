// lib/data/repositories/implementations/fake_wallet_repository.dart
// (Buat file baru)

import '../../models/payment_transaction_model.dart';
import '../../models/wallet_model.dart';
import '../../models/wallet_transaction_model.dart';
import '../abstract/wallet_repository.dart';

class FakeWalletRepository implements IWalletRepository {

  // Sesuai Skenario 2 (Citra), dia top-up Rp 100 Juta
  final Map<String, dynamic> _mockWalletData = {
    "wallet_id": "W-USER-001",
    "balance": 11250000.0 // Saldo Budi dari mock HomeDashboard
  };

  final List<Map<String, dynamic>> _mockWalletHistoryDB = List.generate(40, (i) {
    bool isKredit = i % 4 == 0; // Buat 1 kredit setiap 4 transaksi
    String desc;
    if (isKredit) {
      desc = "Top Up via Virtual Account";
    } else if (i % 3 == 0) {
      desc = "Pembayaran Konsultasi (Drh. Santoso)"; //
    } else if (i % 2 == 0) {
      desc = "Investasi pada Proyek (Bawang Merah)"; //
    } else {
      desc = "Pembayaran Pesanan Toko #ORD-100${25 - i}";
    }

    return {
      "transaction_id": "TRX-$i",
      "type": isKredit ? "KREDIT" : "DEBIT",
      "amount": isKredit ? 500000.0 : ((i + 1) * 10000.0),
      "description": desc,
      "timestamp": DateTime.now().subtract(Duration(hours: i * 5)).toIso8601String()
    };
  });


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

  @override
  Future<PaymentTransactionModel> requestTopUp(double amount) async {
    await Future.delayed(const Duration(seconds: 2)); // Simulasi API ke PG

    // Metode ini TIDAK menambah saldo _mockWalletData.
    // Metode ini HANYA membuat instruksi pembayaran.
    // Saldo baru bertambah saat backend menerima webhook "PAID" dari PG.
    
    final fakeTransaction = {
      "transaction_id": "TOPUP-${DateTime.now().millisecondsSinceEpoch}",
      "payment_method_type": "VA",
      "payment_provider": "BCA Virtual Account",
      "payment_code": "1234567890123", // Nomor VA Palsu
      "amount": amount,
      "expiry_time": DateTime.now().add(const Duration(hours: 24)).toIso8601String(),
    };
    
    return PaymentTransactionModel.fromJson(fakeTransaction);
  }

  @override
  Future<List<WalletTransactionModel>> getWalletHistory(int page, {int limit = 20}) async {
    await Future.delayed(const Duration(milliseconds: 900));
    
    // Logika Pagination Palsu (Identik dengan OrderHistory)
    final startIndex = (page - 1) * limit;
    if (startIndex >= _mockWalletHistoryDB.length) {
      return []; // Halaman habis
    }
    
    final endIndex = (startIndex + limit > _mockWalletHistoryDB.length)
        ? _mockWalletHistoryDB.length
        : (startIndex + limit);
        
    final pageData = _mockWalletHistoryDB.sublist(startIndex, endIndex);
    
    return pageData.map((json) => WalletTransactionModel.fromJson(json)).toList();
  }

  @override
  Future<bool> checkTopUpStatus(String transactionId, double amount) async {
    await Future.delayed(const Duration(seconds: 2)); // Simulasi pengecekan API

    // Di backend asli: Cek status transaksi 'transactionId' ke Midtrans.
    // Jika 'PAID':
    // 1. Update DB Transaksi -> "SUCCESS"
    // 2. Update DB Wallet -> balance += amount
    
    // Simulasi kita:
    double currentBalance = (_mockWalletData['balance'] as num).toDouble();
    _mockWalletData['balance'] = currentBalance + amount;
    
    print("Fake Wallet: Top Up $amount BERHASIL. Saldo baru: ${_mockWalletData['balance']}");
    
    // Kembalikan 'true' untuk menandakan sukses
    return true;
  }
}