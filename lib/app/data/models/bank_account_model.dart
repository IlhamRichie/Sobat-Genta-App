// lib/data/models/bank_account_model.dart
// (Buat file baru)

class BankAccountModel {
  final String accountId;
  final String bankName;
  final String accountNumber;
  final String accountHolderName;
  final bool isPrimary;

  BankAccountModel({
    required this.accountId,
    required this.bankName,
    required this.accountNumber,
    required this.accountHolderName,
    required this.isPrimary,
  });

  factory BankAccountModel.fromJson(Map<String, dynamic> json) {
    return BankAccountModel(
      accountId: json['account_id'].toString(),
      bankName: json['bank_name'],
      accountNumber: json['account_number'],
      accountHolderName: json['account_holder_name'],
      isPrimary: json['is_primary'] ?? false,
    );
  }
}