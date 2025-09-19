// lib/data/models/payment_transaction_model.dart
// (Buat file baru)

class PaymentTransactionModel {
  final String transactionId;
  final String paymentMethodType; // Cth: "VA", "QRIS"
  final String paymentProvider;   // Cth: "BCA", "GOPAY"
  final String paymentCode;       // Nomor VA atau kode QRIS string
  final double amount;
  final DateTime expiryTime;

  PaymentTransactionModel({
    required this.transactionId,
    required this.paymentMethodType,
    required this.paymentProvider,
    required this.paymentCode,
    required this.amount,
    required this.expiryTime,
  });

  factory PaymentTransactionModel.fromJson(Map<String, dynamic> json) {
    return PaymentTransactionModel(
      transactionId: json['transaction_id'],
      paymentMethodType: json['payment_method_type'],
      paymentProvider: json['payment_provider'],
      paymentCode: json['payment_code'],
      amount: (json['amount'] as num).toDouble(),
      expiryTime: DateTime.parse(json['expiry_time']),
    );
  }
}