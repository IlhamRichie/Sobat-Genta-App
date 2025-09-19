// lib/data/repositories/implementations/fake_bank_account_repository.dart
// (Buat file baru

import '../../models/bank_account_model.dart';
import '../abstract/bank_account_repository.dart';

class FakeBankAccountRepository implements IBankAccountRepository {

  // Data mock rekening Drh. Santoso
  final List<Map<String, dynamic>> _mockBankAccounts = [
    {
      "account_id": "BA-001",
      "bank_name": "BCA",
      "account_number": "0123456789",
      "account_holder_name": "Drh. Budi Santoso",
      "is_primary": true,
    }
  ];

  @override
  Future<List<BankAccountModel>> getMyBankAccounts() async {
    await Future.delayed(const Duration(milliseconds: 700));
    // Kembalikan empty list untuk menguji logika "belum ada rekening"
    // return []; 
    
    return _mockBankAccounts.map((json) => BankAccountModel.fromJson(json)).toList();
  }

  // --- IMPLEMENTASI (C) CREATE ---
  @override
  Future<BankAccountModel> addBankAccount(Map<String, dynamic> accountData) async {
    await Future.delayed(const Duration(seconds: 1));
    
    final newAccountJson = {
      "account_id": "BA-${DateTime.now().millisecondsSinceEpoch}",
      "bank_name": accountData['bank_name'],
      "account_number": accountData['account_number'],
      "account_holder_name": accountData['account_holder_name'],
      "is_primary": _mockBankAccounts.isEmpty, // Jadi primary jika ini yang pertama
    };
    
    _mockBankAccounts.add(newAccountJson);
    print("Fake DB: Bank account added.");
    return BankAccountModel.fromJson(newAccountJson);
  }

  // --- IMPLEMENTASI (U) UPDATE ---
  @override
  Future<void> setPrimaryAccount(String accountId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Set semua ke false, lalu set satu ke true
    for (var acc in _mockBankAccounts) {
      acc['is_primary'] = (acc['account_id'] == accountId);
    }
    print("Fake DB: Primary account set to $accountId");
  }

  // --- IMPLEMENTASI (D) DELETE ---
  @override
  Future<void> deleteBankAccount(String accountId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockBankAccounts.removeWhere((acc) => acc['account_id'] == accountId);
    print("Fake DB: Account $accountId deleted.");
  }
}