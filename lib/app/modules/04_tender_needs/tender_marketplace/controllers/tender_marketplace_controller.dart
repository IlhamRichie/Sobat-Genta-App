// lib/app/modules/tender_marketplace/controllers/tender_marketplace_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/models/tender_request_model.dart';
import '../../../../data/repositories/abstract/tender_repository.dart';
import '../../../../routes/app_pages.dart';

class TenderMarketplaceController extends GetxController {

  // --- DEPENDENCIES ---
  final ITenderRepository _tenderRepo = Get.find<ITenderRepository>();

  // --- STATE ---
  final RxBool isLoading = true.obs;
  final RxList<TenderRequestModel> tenderList = <TenderRequestModel>[].obs;

  // --- PAGINATION STATE ---
  final ScrollController scrollController = ScrollController();
  final RxBool isLoadingMore = false.obs;
  final RxInt currentPage = 1.obs;
  final RxBool hasMoreData = true.obs;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_scrollListener);
    fetchInitialTenders();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  /// 1. Ambil data halaman pertama
  Future<void> fetchInitialTenders() async {
    isLoading.value = true;
    hasMoreData.value = true;
    currentPage.value = 1;
    tenderList.clear();
    
    try {
      final tenders = await _tenderRepo.getActiveTenders(1);
      if (tenders.isEmpty) {
        hasMoreData.value = false;
      }
      tenderList.assignAll(tenders);
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat tender: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// 2. Listener scroll
  void _scrollListener() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent &&
        !isLoadingMore.value &&
        hasMoreData.value) {
      loadMoreTenders();
    }
  }

  /// 3. Ambil data halaman berikutnya
  Future<void> loadMoreTenders() async {
    isLoadingMore.value = true;
    currentPage.value++;

    try {
      final newTenders = await _tenderRepo.getActiveTenders(currentPage.value);
      if (newTenders.isEmpty) {
        hasMoreData.value = false;
      } else {
        tenderList.addAll(newTenders);
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat data tambahan: $e");
    } finally {
      isLoadingMore.value = false;
    }
  }

  // --- NAVIGASI ---
  
  void goToCreateTender() async { // <-- 1. Tambahkan 'async'
    // 2. 'await' navigasi untuk menunggu hasil
    final result = await Get.toNamed(Routes.TENDER_CREATE_REQUEST);

    // 3. Jika hasilnya 'success', panggil refresh data
    if (result == 'success') {
      fetchInitialTenders(); // Ini akan mengambil halaman 1 lagi
    }
  }
  
  void goToTenderDetail(TenderRequestModel tender) {
    Get.toNamed(Routes.TENDER_DETAIL, arguments: tender.requestId);
  }
}