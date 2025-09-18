// lib/app/modules/register_role_chooser/controllers/register_role_chooser_controller.dart

import 'package:get/get.dart';
import '../../../../routes/app_pages.dart';

class RegisterRoleChooserController extends GetxController {

  /// Navigasi ke form registrasi Petani
  void navigateToFarmerRegistration() {
    Get.toNamed(Routes.REGISTER_FARMER);
  }

  /// Navigasi ke form registrasi Investor
  void navigateToInvestorRegistration() {
    Get.toNamed(Routes.REGISTER_INVESTOR);
  }

  /// Navigasi ke form registrasi Pakar
  void navigateToExpertRegistration() {
    Get.toNamed(Routes.REGISTER_EXPERT);
  }

  /// Kembali ke halaman Login jika sudah punya akun
  void navigateToLogin() {
    // Kita gunakan offNamed untuk 'mengganti' halaman ini
    // dengan halaman Login, membersihkan stack.
    Get.offNamed(Routes.LOGIN);
  }
}