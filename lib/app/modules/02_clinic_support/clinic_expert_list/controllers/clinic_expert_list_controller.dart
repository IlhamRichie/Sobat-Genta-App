import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../../../data/models/expert_model.dart';
import '../../../../routes/app_pages.dart';
import '../../../01_main_navigation/main_navigation/controllers/main_navigation_controller.dart';

// --- Best Practice: Definisikan Model Data ---
enum ExpertSpecialty { all, farmer, vet }

class ClinicExpertListController extends GetxController {
  
  late MainNavigationController mainNavController;

  late TextEditingController searchController;
  final RxString searchQuery = ''.obs;
  final Rx<ExpertSpecialty> selectedFilter = ExpertSpecialty.all.obs;
  final List<String> filterChips = ['Semua', 'Ahli Tani', 'Dokter Hewan'];

  final RxList<ExpertModel> allExperts = <ExpertModel>[].obs;
  final RxList<ExpertModel> filteredExperts = <ExpertModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    searchController = TextEditingController();
    mainNavController = Get.find<MainNavigationController>();
    
    _loadDummyData(); // Muat data dummy
    
    // Best Practice: Listener reaktif untuk filter
    searchController.addListener(() {
      searchQuery.value = searchController.text;
    });
    
    // 'ever' akan 'mendengarkan' perubahan pada 2 variabel ini dan memanggil filterList
    ever(searchQuery, (_) => filterList());
    ever(selectedFilter, (_) => filterList());
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  // --- Logic Utama ---
  
  void filterList() {
    List<ExpertModel> results = [];
    
    // 1. Filter berdasarkan Kategori (Chip)
    if (selectedFilter.value == ExpertSpecialty.all) {
      results = allExperts;
    } else {
      results = allExperts.where((p) => p.specialtyEnum == selectedFilter.value).toList();
    }
    
    // 2. Filter berdasarkan Pencarian (Search Query)
    if (searchQuery.value.isNotEmpty) {
      results = results.where((p) => 
        p.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
        p.specialtyName.toLowerCase().contains(searchQuery.value.toLowerCase())
      ).toList();
    }
    
    filteredExperts.value = results;
  }

  void selectFilter(int index) {
    if (index == 0) selectedFilter.value = ExpertSpecialty.all;
    if (index == 1) selectedFilter.value = ExpertSpecialty.farmer;
    if (index == 2) selectedFilter.value = ExpertSpecialty.vet;
  }

  // --- [SR-KYC-02] LOGIC KUNCI & SNACKBAR ---
  void onConsultationTap(BuildContext context, ExpertModel expert) {
    // Cek status KYC dari Main Controller
    if (mainNavController.kycStatus.value == UserKycStatus.verified) {
      // 1. JIKA LOLOS: Lanjut ke profil pakar
      Get.toNamed(Routes.CLINIC_EXPERT_PROFILE, arguments: expert);
    } else {
      // 2. JIKA TERKUNCI: Tampilkan Snackbar Informatif
      showKycSnackbar(context);
    }
  }

  void showKycSnackbar(BuildContext context) {
    // Ambil status KYC
    final kycStatus = mainNavController.kycStatus.value;
    String message = "";

    if (kycStatus == UserKycStatus.pending) {
      message = "Fitur terkunci. Harap lengkapi verifikasi KYC Anda untuk memulai konsultasi.";
    } else { // Ini berarti statusnya inReview
      message = "Fitur terkunci. Akun Anda sedang ditinjau, mohon tunggu persetujuan Admin.";
    }

    showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.error(
        message: message,
      ),
      displayDuration: 3.seconds,
    );
  }

  // --- Data Dummy (UI Dulu Aja) ---
  void _loadDummyData() {
    allExperts.value = [
      ExpertModel(id: 1, name: 'Dr. Budi Santoso', specialtyName: 'Ahli Hama Tanaman', specialtyEnum: ExpertSpecialty.farmer, rating: 4.9, price: '50rb', isOnline: true, imageUrl: 'https://picsum.photos/seed/doc1/200'),
      ExpertModel(id: 2, name: 'Drh. Anita Dewi', specialtyName: 'Dokter Hewan Ternak', specialtyEnum: ExpertSpecialty.vet, rating: 4.8, price: '75rb', isOnline: true, imageUrl: 'https://picsum.photos/seed/doc2/200'),
      ExpertModel(id: 3, name: 'Prof. Ir. Jaya Wijaya', specialtyName: 'Ahli Nutrisi Tanah', specialtyEnum: ExpertSpecialty.farmer, rating: 4.9, price: '80rb', isOnline: false, imageUrl: 'https://picsum.photos/seed/doc3/200'),
      ExpertModel(id: 4, name: 'Drh. Rina Pratiwi', specialtyName: 'Spesialis Unggas', specialtyEnum: ExpertSpecialty.vet, rating: 4.7, price: '60rb', isOnline: true, imageUrl: 'https://picsum.photos/seed/doc4/200'),
    ];
    filteredExperts.value = allExperts;
  }
}