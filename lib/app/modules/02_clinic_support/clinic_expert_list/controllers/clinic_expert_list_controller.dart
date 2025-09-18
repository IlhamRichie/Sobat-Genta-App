// lib/app/modules/clinic_expert_list/controllers/clinic_expert_list_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/models/pakar_profile_model.dart';
import '../../../../data/repositories/abstract/pakar_profile_repository.dart';
import '../../../../routes/app_pages.dart';

class ClinicExpertListController extends GetxController {

  // --- DEPENDENCIES ---
  final IPakarProfileRepository _pakarRepo = Get.find<IPakarProfileRepository>();
  
  // --- STATE ---
  final RxBool isLoading = true.obs;
  
  // --- FILTER & SEARCH STATE ---
  final TextEditingController searchC = TextEditingController();
  final RxString filterCategory = ''.obs;
  final RxString filterSearchTerm = ''.obs;
  final RxBool filterOnlineOnly = false.obs;

  // --- DATA LISTS ---
  /// List master yang menyimpan data asli dari API
  final List<PakarProfileModel> _masterPakarList = [];
  /// List yang ditampilkan ke UI dan akan dimodifikasi oleh filter
  final RxList<PakarProfileModel> displayedPakarList = <PakarProfileModel>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    // 1. Ambil argumen kategori (cth: "PETERNAKAN")
    final String? initialCategory = Get.arguments?['category'];
    if (initialCategory != null) {
      filterCategory.value = initialCategory;
    }
    
    // 2. Ambil data awal berdasarkan filter kategori
    fetchInitialPakarList(initialCategory);
    
    // 3. BEST PRACTICE: Buat listener (worker) untuk filter lokal.
    // 'ever' akan mendengarkan perubahan pada filter-filter ini
    // dan memanggil '_applyLocalFilters' secara otomatis.
    ever(filterSearchTerm, (_) => _applyLocalFilters());
    ever(filterOnlineOnly, (_) => _applyLocalFilters());
  }

  @override
  void onClose() {
    searchC.dispose();
    super.onClose();
  }

  /// 1. Ambil data dari API (SATU KALI)
  Future<void> fetchInitialPakarList(String? category) async {
    isLoading.value = true;
    _masterPakarList.clear();
    displayedPakarList.clear();
    
    try {
      final pakar = await _pakarRepo.getPakarList(category);
      // Sortir yang Online duluan
      pakar.sort((a, b) => (a.isAvailable ? 0 : 1).compareTo(b.isAvailable ? 0 : 1));
      
      _masterPakarList.assignAll(pakar); // Simpan ke list master
      displayedPakarList.assignAll(pakar); // Tampilkan ke UI
      
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat daftar pakar: $e");
    } finally {
      isLoading.value = false;
    }
  }
  
  /// 2. Jalankan filter lokal (CLIENT-SIDE FILTERING)
  void _applyLocalFilters() {
    List<PakarProfileModel> filteredList = List.from(_masterPakarList);

    // Filter A: Status Online
    if (filterOnlineOnly.value) {
      filteredList = filteredList.where((pakar) => pakar.isAvailable).toList();
    }
    
    // Filter B: Search Term (Nama atau Spesialisasi)
    if (filterSearchTerm.value.isNotEmpty) {
      String searchTerm = filterSearchTerm.value.toLowerCase();
      filteredList = filteredList.where((pakar) {
        return pakar.user.fullName.toLowerCase().contains(searchTerm) ||
               pakar.specialization.toLowerCase().contains(searchTerm);
      }).toList();
    }
    
    // Update UI
    displayedPakarList.assignAll(filteredList);
  }

  // --- METODE YANG DIPANGGIL DARI UI ---

  /// Dipanggil oleh Search Bar (onChanged)
  void onSearchChanged(String query) {
    filterSearchTerm.value = query;
  }

  /// Dipanggil oleh Toggle/Switch
  void onOnlineOnlyToggled(bool value) {
    filterOnlineOnly.value = value;
  }
  
  /// Navigasi ke detail profil pakar
  void goToPakarDetail(PakarProfileModel pakar) {
    Get.toNamed(Routes.CLINIC_EXPERT_PROFILE, arguments: pakar);
  }
}