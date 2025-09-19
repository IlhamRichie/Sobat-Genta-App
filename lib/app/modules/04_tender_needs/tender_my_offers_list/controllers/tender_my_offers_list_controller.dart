// lib/app/modules/tender_my_offers_list/controllers/tender_my_offers_list_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/models/tender_offer_model.dart';
import '../../../../data/repositories/abstract/tender_repository.dart';
import '../../../../routes/app_pages.dart';

class TenderMyOffersListController extends GetxController {

  // --- DEPENDENCIES ---
  final ITenderRepository _tenderRepo = Get.find<ITenderRepository>();

  // --- STATE ---
  final RxBool isLoading = true.obs;
  final RxList<TenderOfferModel> offerList = <TenderOfferModel>[].obs;

  // --- PAGINATION STATE (Identik dengan modul lain) ---
  final ScrollController scrollController = ScrollController();
  final RxBool isLoadingMore = false.obs;
  final RxInt currentPage = 1.obs;
  final RxBool hasMoreData = true.obs;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_scrollListener);
    fetchInitialOffers();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  /// 1. Ambil data halaman pertama
  Future<void> fetchInitialOffers() async {
    isLoading.value = true;
    hasMoreData.value = true;
    currentPage.value = 1;
    offerList.clear();
    
    try {
      final offers = await _tenderRepo.getMySubmittedOffers(1);
      if (offers.isEmpty) {
        hasMoreData.value = false;
      }
      offerList.assignAll(offers);
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat daftar penawaran: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// 2. Listener scroll
  void _scrollListener() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent &&
        !isLoadingMore.value &&
        hasMoreData.value) {
      loadMoreOffers();
    }
  }

  /// 3. Ambil data halaman berikutnya
  Future<void> loadMoreOffers() async {
    isLoadingMore.value = true;
    currentPage.value++;

    try {
      final newOffers = await _tenderRepo.getMySubmittedOffers(currentPage.value);
      if (newOffers.isEmpty) {
        hasMoreData.value = false;
      } else {
        offerList.addAll(newOffers);
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat data tambahan: $e");
    } finally {
      isLoadingMore.value = false;
    }
  }
  
  /// 4. Navigasi ke detail tender (induk)
  void goToTenderDetail(TenderOfferModel offer) {
    Get.toNamed(Routes.TENDER_DETAIL, arguments: offer.tenderRequest.requestId);
  }
}