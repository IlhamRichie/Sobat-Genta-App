// lib/data/repositories/implementations/fake_kyc_repository.dart
// (Buat file baru)

import 'dart:io';
import 'package:get/get.dart';

import '../../../services/session_service.dart';
import '../../models/user_model.dart';
import '../abstract/kyc_repository.dart';

class FakeKycRepository implements IKycRepository {
  final SessionService _sessionService = Get.find<SessionService>();

  @override
  Future<User> submitKyc(Map<String, dynamic> textData, List<File> files) async {
    await Future.delayed(const Duration(seconds: 2));
    
    print("--- FAKE KYC SUBMISSION ---");
    print("User Role: ${_sessionService.userRole}");
    print("Data Teks: $textData");
    print("Total File: ${files.length}");
    for (var file in files) {
      print("File: ${file.path}");
    }
    print("---------------------------");

    // Simulasi sukses
    // Backend akan mengubah status user menjadi "PENDING_REVIEW"
    // Kita update user di session service
    User? currentUser = _sessionService.currentUser.value;
    if (currentUser != null) {
      // Kita buat user baru dengan status PENDING_KYC
      // (di user_model, PENDING_KYC mencakup PENDING_REVIEW)
      final updatedUser = User(
        userId: currentUser.userId,
        fullName: currentUser.fullName,
        email: currentUser.email,
        role: currentUser.role,
        kycStatus: KycStatus.PENDING_KYC, // atau buat status baru 'PENDING_REVIEW'
      );
      return updatedUser;
    }
    
    throw Exception("User tidak ditemukan saat submit KYC");
  }
}