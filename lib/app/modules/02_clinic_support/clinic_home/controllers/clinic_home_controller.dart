// lib/app/modules/clinic_home/controllers/clinic_home_controller.dart

import 'package:get/get.dart';

import '../../../../data/models/pakar_profile_model.dart';
import '../../../../data/repositories/abstract/pakar_profile_repository.dart';
import '../../../../routes/app_pages.dart';

class ClinicHomeController extends GetxController {

  // --- DEPENDENCIES ---
  final IPakarProfileRepository _pakarRepo = Get.find<IPakarProfileRepository>();

  // --- STATE ---
  final RxBool isLoadingPakar = true.obs;
  final RxList<PakarProfileModel> featuredPakarList = <PakarProfileModel>[].obs;
  
  // --- PRAGMATIC SHORTCUT: Mock Data Lokal ---
  // Kita mock data artikel digital library
  final List<Map<String, String>> featuredArticles = [
    {
      "title": "5 Cara Efektif Atasi Hama Wereng",
      "category": "Pertanian",
      "image_url": "https.../wereng.jpg"
    },
    {
      "title": "Mengenal Gejala Awal PMK pada Sapi",
      "category": "Peternakan",
      "image_url": "https.../sapi_pmk.jpg"
    }
  ];
  // ------------------------------------------

  @override
  void onInit() {
    super.onInit();
    fetchFeaturedPakar();
  }

  /// Mengambil daftar pakar (misal, 3 teratas/online)
  Future<void> fetchFeaturedPakar() async {
    isLoadingPakar.value = true;
    try {
      // Kita panggil getPakarList(null) untuk ambil semua
      final allPakar = await _pakarRepo.getPakarList(null);
      
      // Sortir agar yang "Online" tampil duluan
      allPakar.sort((a, b) => (a.isAvailable ? 0 : 1).compareTo(b.isAvailable ? 0 : 1));
      
      // Ambil 3 teratas untuk ditampilkan sebagai "featured"
      featuredPakarList.assignAll(allPakar.take(3)); 
      
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat daftar pakar: $e");
    } finally {
      isLoadingPakar.value = false;
    }
  }

  // --- NAVIGASI ---
  
  /// Navigasi ke halaman list pakar (dengan filter)
  void goToPakarList(String category) {
    // Skenario 3: Budi filter "Peternakan"
    Get.toNamed(Routes.CLINIC_EXPERT_LIST, arguments: {'category': category});
  }

  /// Navigasi ke halaman detail pakar
  void goToPakarDetail(PakarProfileModel pakar) {
    // Skenario 3: Budi klik profil Drh. Santoso
    Get.toNamed(Routes.CLINIC_EXPERT_PROFILE, arguments: pakar);
  }
  
  /// Navigasi ke fitur AI Scan
  void goToAiScan() {
    Get.toNamed(Routes.CLINIC_AI_SCAN);
  }
  
  /// Navigasi ke perpustakaan digital
  void goToDigitalLibrary() {
    Get.toNamed(Routes.CLINIC_DIGITAL_LIBRARY);
  }
}