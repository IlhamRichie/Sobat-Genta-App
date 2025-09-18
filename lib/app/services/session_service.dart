// lib/app/services/session_service.dart

import 'package:get/get.dart';
import '../data/models/user_model.dart';

class SessionService extends GetxService {
  
  // State reaktif untuk menyimpan data user yang login
  final Rx<User?> currentUser = Rx<User?>(null);

  // --- Helper Getters ---
  
  /// Cek apakah user sudah login
  bool get isLoggedIn => currentUser.value != null;

  /// Mendapatkan role user saat ini
  UserRole get userRole => currentUser.value?.role ?? UserRole.UNKNOWN;

  /// Mendapatkan status KYC user saat ini
  KycStatus get kycStatus => currentUser.value?.kycStatus ?? KycStatus.UNKNOWN;

  // --- Public Methods ---

  /// Menyimpan data user ke state
  void setCurrentUser(User user) {
    currentUser.value = user;
    // ... (TODO: Simpan ke GetStorage)
  }

  /// Menghapus sesi (logout)
  void clearSession() {
    currentUser.value = null;
    // TODO: Hapus token/user dari GetStorage
  }
  
}