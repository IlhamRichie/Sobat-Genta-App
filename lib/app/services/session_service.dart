// lib/app/services/session_service.dart

import 'package:get/get.dart';
import '../data/models/user_model.dart';
import '../data/repositories/abstract/auth_repository.dart';
import '../routes/app_pages.dart';

class SessionService extends GetxService {
  
  // State reaktif untuk menyimpan data user yang login
  final Rx<User?> currentUser = Rx<User?>(null);

  final IAuthRepository _authRepo = Get.find<IAuthRepository>();

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

  Future<void> logoutUser() async {
    try {
      // 1. (Opsional) Panggil API backend untuk invalidate token di server
      await _authRepo.logout(); 
    } catch (e) {
      // Abaikan error saat logout, tetap lanjutkan proses
      print("Error calling API logout: $e");
    }
    
    // 2. Bersihkan state lokal (currentUser = null)
    clearSession(); 
    
    // 3. (PENTING) Paksa navigasi ke Login dan HAPUS semua halaman sebelumnya.
    // Ini memastikan user tidak bisa 'back' ke halaman profil setelah logout.
    Get.offAllNamed(Routes.LOGIN);
  }
  
}