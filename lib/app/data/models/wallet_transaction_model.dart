// lib/data/models/wallet_transaction_model.dart
// (Buat file baru)
import 'package:intl/intl.dart';

enum TransactionType { KREDIT, DEBIT, UNKNOWN }

class WalletTransactionModel {
  final String transactionId;
  final TransactionType type;
  final double amount;
  final String description; // Cth: "Investasi Proyek", "Pembayaran Order", "Top Up"
  final DateTime timestamp;

  WalletTransactionModel({
    required this.transactionId,
    required this.type,
    required this.amount,
    required this.description,
    required this.timestamp,
  });

  String get formattedDate => DateFormat('d MMM yyyy, HH:mm', 'id_ID').format(timestamp);

  factory WalletTransactionModel.fromJson(Map<String, dynamic> json) {
    return WalletTransactionModel(
      transactionId: json['transaction_id'].toString(),
      type: (json['type'] == 'KREDIT') ? TransactionType.KREDIT : TransactionType.DEBIT,
      amount: (json['amount'] as num).toDouble(),
      description: json['description'] ?? 'Tidak ada deskripsi',
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}