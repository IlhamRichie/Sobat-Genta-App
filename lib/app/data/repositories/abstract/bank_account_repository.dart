// lib/data/repositories/abstract/bank_account_repository.dart
// (Buat file baru)

import '../../models/bank_account_model.dart';

abstract class IBankAccountRepository {
  /// Mengambil semua rekening bank milik user
  Future<List<BankAccountModel>> getMyBankAccounts();
  
  /// (Nanti kita akan tambah 'addBankAccount', 'deleteBankAccount', dll
  /// saat membuat halaman MANAGE_BANK_ACCOUNTS)
  /// 
  /// (C) Menambah rekening bank baru
  Future<BankAccountModel> addBankAccount(Map<String, dynamic> accountData);

  /// (U) Mengatur satu rekening sebagai utama
  Future<void> setPrimaryAccount(String accountId);
  
  /// (D) Menghapus rekening bank
  Future<void> deleteBankAccount(String accountId);
}