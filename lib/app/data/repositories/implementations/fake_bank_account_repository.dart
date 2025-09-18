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
}