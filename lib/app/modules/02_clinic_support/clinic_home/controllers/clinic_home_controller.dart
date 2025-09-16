import 'package:get/get.dart';
import '../../../../routes/app_pages.dart';

class ClinicHomeController extends GetxController {
  
  // Aksi untuk 3 tombol fitur
  void goToTelekonsultasi() {
    // (Akan mengarah ke halaman daftar pakar)
    Get.toNamed(Routes.CLINIC_EXPERT_LIST);
  }

  void goToAiScan() {
    // (Akan mengarah ke halaman scan)
    Get.toNamed(Routes.CLINIC_AI_SCAN);
  }

  void goToPustakaDigital() {
    // (Akan mengarah ke perpustakaan)
    Get.toNamed(Routes.CLINIC_DIGITAL_LIBRARY);
  }
}