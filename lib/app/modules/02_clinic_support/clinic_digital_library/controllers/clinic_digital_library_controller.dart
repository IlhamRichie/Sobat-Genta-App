// lib/app/modules/clinic_digital_library/controllers/clinic_digital_library_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/models/digital_document_model.dart';
import '../../../../data/repositories/abstract/digital_library_repository.dart';
import '../../../../routes/app_pages.dart';

class ClinicDigitalLibraryController extends GetxController {

  final IDigitalLibraryRepository _libraryRepo = Get.find<IDigitalLibraryRepository>();

  final RxBool isLoading = true.obs;
  final RxList<DigitalDocumentModel> documentList = <DigitalDocumentModel>[].obs;
  
  // -- PAGINATION STATE --
  final ScrollController scrollController = ScrollController();
  final RxBool isLoadingMore = false.obs;
  final RxInt currentPage = 1.obs;
  final RxBool hasMoreData = true.obs;

  // -- FILTER STATE --
  final TextEditingController searchC = TextEditingController();
  final RxString searchTerm = ''.obs;
  final RxString categoryFilter = 'SEMUA'.obs; // SEMUA, PERTANIAN, PETERNAKAN

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_scrollListener);
    
    // Debouncer untuk search
    debounce(searchTerm, (_) => fetchInitialDocs(), time: const Duration(milliseconds: 600));
    
    fetchInitialDocs(); // Ambil data awal
  }

  @override
  void onClose() {
    scrollController.dispose();
    searchC.dispose();
    super.onClose();
  }

  /// 1. Ambil data Halaman 1 (juga dipanggil oleh Filter/Search)
  Future<void> fetchInitialDocs() async {
    isLoading.value = true;
    hasMoreData.value = true;
    currentPage.value = 1;
    documentList.clear();
    
    await _fetchDocs(page: 1);
    
    isLoading.value = false;
  }

  /// 2. Listener scroll (Pagination)
  void _scrollListener() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent &&
        !isLoadingMore.value && hasMoreData.value) {
      loadMoreDocs();
    }
  }

  /// 3. Ambil data halaman berikutnya
  Future<void> loadMoreDocs() async {
    isLoadingMore.value = true;
    currentPage.value++;
    await _fetchDocs(page: currentPage.value);
    isLoadingMore.value = false;
  }

  /// 4. Metode Fetch Internal (Generik)
  Future<void> _fetchDocs({required int page}) async {
    try {
      final docs = await _libraryRepo.getLibraryDocuments(
        page: page,
        searchTerm: searchTerm.value.isEmpty ? null : searchTerm.value,
        category: categoryFilter.value == 'SEMUA' ? null : categoryFilter.value,
      );
      
      if (docs.isEmpty) {
        hasMoreData.value = false;
      } else {
        if (page == 1) {
          documentList.assignAll(docs); // Jika halaman 1, ganti list
        } else {
          documentList.addAll(docs); // Jika > 1, tambahkan ke list
        }
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat perpustakaan: $e");
    }
  }

  // --- AKSI DARI UI ---

  void onSearchChanged(String query) {
    searchTerm.value = query; // Debouncer akan memicu fetchInitialDocs
  }

  void setCategoryFilter(String category) {
    categoryFilter.value = category;
    fetchInitialDocs(); // Langsung panggil API
  }

  void goToReader(DigitalDocumentModel document) {
    // Navigasi ke Halaman Reader
    Get.toNamed(Routes.CLINIC_LIBRARY_READER, arguments: document);
  }
}