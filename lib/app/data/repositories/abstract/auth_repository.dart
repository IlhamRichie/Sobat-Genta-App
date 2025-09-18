// lib/data/repositories/abstract/auth_repository.dart

import '../../models/user_model.dart';

abstract class IAuthRepository {
  /// Mengautentikasi user dan mengembalikan data user
  Future<User> login(String email, String password);

  /// Mengambil data user saat ini (via token/session)
  Future<User> getMyProfile();

  Future<User> register(Map<String, dynamic> data); 

  Future<void> forgotPassword(String email);

  Future<void> resendOtp(String email, String purpose);

  Future<String> verifyOtp(String email, String otp, String purpose);

  Future<void> createNewPassword(String email, String token, String newPassword);

}