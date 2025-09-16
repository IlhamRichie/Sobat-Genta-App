import 'package:get/get.dart';
import '../../../../routes/app_pages.dart';

// Best Practice: Gunakan Enum untuk role agar kode lebih aman dan bersih
enum UserRole { farmer, investor, expert }

class RegisterRoleChooserController extends GetxController {
  
  // State reaktif untuk melacak peran yang dipilih
  // (null berarti belum ada yang dipilih)
  final Rx<UserRole?> selectedRole = Rx<UserRole?>(null);

  // Dipanggil oleh View saat card peran di-tap
  void selectRole(UserRole role) {
    selectedRole.value = role;
  }

  // Aksi tombol "Lanjutkan Pendaftaran"
  void continueRegistration() {
    // Gunakan switch-case untuk navigasi yang bersih
    switch (selectedRole.value) {
      case UserRole.farmer:
        Get.toNamed(Routes.REGISTER_FARMER);
        break;
      case UserRole.investor:
        Get.toNamed(Routes.REGISTER_INVESTOR);
        break;
      case UserRole.expert:
        Get.toNamed(Routes.REGISTER_EXPERT);
        break;
      default:
        // Seharusnya tidak akan pernah terjadi karena tombol di-disable
        Get.snackbar("Error", "Silakan pilih peran terlebih dahulu.");
        break;
    }
  }
}

// (Jangan lupa tambahkan enum UserRole di atas atau di file terpisah)