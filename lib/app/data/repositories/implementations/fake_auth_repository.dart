// lib/data/repositories/implementations/fake_auth_repository.dart

import '../../models/user_model.dart';
import '../abstract/auth_repository.dart';

class FakeAuthRepository implements IAuthRepository {
  
  // --- Mock Data ---
  final Map<String, dynamic> _mockFarmerData = {
    "user_id": "farmer_123",
    "full_name": "Budi (Petani)",
    "email": "petani@genta.com",
    "role": "FARMER",
    "status": "PENDING_KYC" // Sesuai Skenario Budi
  };

  final Map<String, dynamic> _mockInvestorData = {
    "user_id": "investor_456",
    "full_name": "Citra (Investor)",
    "email": "investor@genta.com",
    "role": "INVESTOR",
    "status": "VERIFIED" // Sesuai Skenario Citra
  };

  final Map<String, dynamic> _mockExpertData = {
    "user_id": "expert_101",
    "full_name": "Drh. Santoso",
    "email": "pakar@genta.com",
    "role": "EXPERT",
    "status": "VERIFIED" // Sesuai Skenario 3 (sudah KYC)
  };

  final Map<String, dynamic> _mockFarmerDataPendingOtp = {
    "user_id": "farmer_123",
    "full_name": "Budi (Pending OTP)",
    "email": "petani@genta.com",
    "role": "FARMER",
    "status": "PENDING_EMAIL_OTP" // Sesuai Skenario 1
  };

  final Map<String, dynamic> _mockInvestorDataPendingOtp = {
    "user_id": "investor_789",
    "full_name": "Citra (Pending OTP)",
    "email": "investor@genta.com",
    "role": "INVESTOR",
    "status": "PENDING_EMAIL_OTP" // Sesuai Skenario 2
  };

  final Map<String, dynamic> _mockExpertDataPendingOtp = {
    "user_id": "expert_101",
    "full_name": "Drh. Santoso (Pending OTP)",
    "email": "pakar@genta.com",
    "role": "EXPERT",
    "status": "PENDING_EMAIL_OTP"
  };
  
  // --- Fake Session Storage ---
  String? _fakeToken;

  @override
  Future<User> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulasi delay API

    if (email == "petani@genta.com") {
      _fakeToken = "token_petani_123";
      return User.fromJson(_mockFarmerData);
    }
    if (email == "investor@genta.com") {
      _fakeToken = "token_investor_456";
      return User.fromJson(_mockInvestorData);
    }
    if (email == "pakar@genta.com") {
      _fakeToken = "token_pakar_789";
      // Gunakan data mock baru yang VERIFIED
      return User.fromJson(_mockExpertData); 
    }
    
    throw Exception("User tidak ditemukan");
  }

  @override
  Future<User> getMyProfile() async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (_fakeToken == "token_petani_123") {
      return User.fromJson(_mockFarmerData);
    }
    if (_fakeToken == "token_investor_456") {
      return User.fromJson(_mockInvestorData);
    }
    if (_fakeToken == "token_pakar_789") {
      return User.fromJson(_mockExpertData);
    }

    // Ini akan ditangkap oleh SplashController sebagai "tidak login"
    throw Exception("Token tidak valid atau tidak ada");
  }

  @override
  Future<User> register(Map<String, dynamic> data) async {
    await Future.delayed(const Duration(seconds: 1));

    String email = data['email'];
    String role = data['role'];

    // Validasi email unik (simulasi)
    if (email == _mockFarmerData["email"] ||
        email == _mockInvestorData["email"]) {
      throw Exception("Email sudah terdaftar");
    }

    // Kembalikan data mock berdasarkan peran
    switch (role) {
      case 'FARMER':
        return User.fromJson(_mockFarmerDataPendingOtp..['email'] = email);
      case 'INVESTOR':
        return User.fromJson(_mockInvestorDataPendingOtp..['email'] = email);
      case 'EXPERT':
        return User.fromJson(_mockExpertDataPendingOtp..['email'] = email);
      default:
        throw Exception("Peran tidak valid");
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    await Future.delayed(const Duration(seconds: 1));
    
    // Simulasi: Cek apakah email ada di salah satu mock data
    // (Gunakan data email yang sudah terdaftar, misal dari _mockFarmerData)
    if (email == _mockFarmerData["email"] ||
        email == _mockInvestorData["email"] ||
        email == "pakar@genta.com") {
      
      // Sukses.
      // Di dunia nyata, backend akan mengirim email OTP/link.
      // Di sini kita anggap sukses saja.
      return;
    }
    
    // Jika email tidak terdaftar
    throw Exception("Email tidak terdaftar di sistem");
  }

  @override
  Future<void> resendOtp(String email, String purpose) async {
    await Future.delayed(const Duration(seconds: 1));
    // Simulasi sukses kirim ulang
    print("Fake OTP Resent to $email for $purpose");
    return;
  }

  @override
  Future<String> verifyOtp(String email, String otp, String purpose) async {
    await Future.delayed(const Duration(seconds: 1));

    // OTP palsu kita
    const String fakeOtp = "123456"; 

    if (otp != fakeOtp) {
      throw Exception("Kode OTP salah atau tidak valid");
    }

    // Jika OTP benar, tentukan respons berdasarkan 'purpose'
    if (purpose == 'registration') {
      // Tidak perlu token, status user di backend akan diubah
      return "success_registration";
    } 
    
    if (purpose == 'reset_password') {
      // Kembalikan token palsu untuk otorisasi reset password
      return "fake_reset_token_for_${email}";
    }

    throw Exception("Tujuan verifikasi tidak diketahui");
  }

  @override
  Future<void> createNewPassword(String email, String token, String newPassword) async {
    await Future.delayed(const Duration(seconds: 1));
    
    // Verifikasi token palsu yang kita generate di 'verifyOtp'
    if (token == "fake_reset_token_for_${email}") {
      // Sukses
      print("Password for $email has been reset to $newPassword");
      // Di backend asli, token ini akan di-invalidate setelah dipakai.
      return;
    }
    
    // Jika token tidak valid
    throw Exception("Token reset password tidak valid atau kedaluwarsa.");
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 100));
    // Logika logout palsu kita adalah menghapus token
    _fakeToken = null;
    print("Fake Auth Repo: User logged out, token cleared.");
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulasi API

    // Simulasi validasi password lama
    // Kita asumsikan password lama semua user palsu kita adalah "password123"
    const String fakeCurrentPasswordInDB = "password123"; 

    if (currentPassword != fakeCurrentPasswordInDB) {
      // Ini adalah error case yang paling umum
      throw Exception("Password Anda saat ini salah.");
    }

    // Jika password lama benar
    print("Fake DB: Password berhasil diubah ke: $newPassword");
    return;
  }
}