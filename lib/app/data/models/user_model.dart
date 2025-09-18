// lib/data/models/user_model.dart

// Enum ini krusial untuk parsing data dari API/Fake
// dan untuk logika UI
enum UserRole { FARMER, INVESTOR, EXPERT, UNKNOWN }
enum KycStatus { PENDING_KYC, VERIFIED, REJECTED, UNKNOWN }

class User {
  final String userId;
  final String fullName;
  final String email;
  final UserRole role;
  final KycStatus kycStatus;
  final String? profilePictureUrl;

  User({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.role,
    required this.kycStatus,
    this.profilePictureUrl,
  });

  // Factory constructor untuk parsing JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'] as String,
      fullName: json['full_name'] as String,
      email: json['email'] as String,
      role: _parseUserRole(json['role'] as String?),
      kycStatus: _parseKycStatus(json['status'] as String?),
      profilePictureUrl: json['profile_picture_url'] as String?,
    );
  }

  // Helper untuk parsing enum string dengan aman
  static UserRole _parseUserRole(String? role) {
    switch (role?.toUpperCase()) {
      case 'FARMER':
        return UserRole.FARMER;
      case 'INVESTOR':
        return UserRole.INVESTOR;
      case 'EXPERT':
        return UserRole.EXPERT;
      default:
        return UserRole.UNKNOWN;
    }
  }

  static KycStatus _parseKycStatus(String? status) {
    switch (status?.toUpperCase()) {
      case 'VERIFIED':
        return KycStatus.VERIFIED;
      case 'REJECTED':
        return KycStatus.REJECTED;
      case 'PENDING_KYC':
      default:
        // Kita anggap semua status lain (spt PENDING_EMAIL_OTP)
        // sebagai PENDING_KYC dari sisi UI lock.
        return KycStatus.PENDING_KYC;
    }
  }
}