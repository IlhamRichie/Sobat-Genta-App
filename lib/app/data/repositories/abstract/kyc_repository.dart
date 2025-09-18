// lib/data/repositories/abstract/kyc_repository.dart
// (Buat file baru)

import 'dart:io';

import '../../models/user_model.dart';

abstract class IKycRepository {
  /// Submit data KYC ke backend
  /// Kita akan kirim Map data teks dan List file terpisah
  Future<User> submitKyc(Map<String, dynamic> textData, List<File> files);
}