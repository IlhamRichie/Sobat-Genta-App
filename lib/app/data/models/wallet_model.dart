// lib/data/models/wallet_model.dart
// (Buat file baru)

class WalletModel {
  final String walletId;
  final double balance;

  WalletModel({required this.walletId, required this.balance});

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      walletId: json['wallet_id'].toString(),
      balance: (json['balance'] as num).toDouble(),
    );
  }
}