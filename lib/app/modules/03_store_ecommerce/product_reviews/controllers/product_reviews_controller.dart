// lib/app/modules/product_reviews/controllers/product_reviews_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/models/product_review_model.dart';
import '../../../../data/repositories/abstract/store_repository.dart';

class ProductReviewsController extends GetxController {

  // --- DEPENDENCIES ---
  final IStoreRepository _storeRepo = Get.find<IStoreRepository>();

  // --- STATE ---
  final RxBool isLoading = true.obs;
  final RxList<ProductReviewModel> reviewList = <ProductReviewModel>[].obs;
  late final String _productId;

  // --- PAGINATION STATE ---
  final ScrollController scrollController = ScrollController();
  final RxBool isLoadingMore = false.obs; // Loader di bagian bawah list
  final RxInt currentPage = 1.obs;
  final RxBool hasMoreData = true.obs; // Untuk stop listener jika data habis

  @override
  void onInit() {
    super.onInit();
    _productId = Get.arguments as String;
    
    // 1. Tambahkan listener ke ScrollController
    scrollController.addListener(_scrollListener);
    
    // 2. Ambil data halaman pertama
    fetchInitialReviews();
  }

  @override
  void onClose() {
    scrollController.dispose(); // Wajib dispose!
    super.onClose();
  }

  /// 1. Ambil data halaman pertama
  Future<void> fetchInitialReviews() async {
    isLoading.value = true;
    hasMoreData.value = true;
    currentPage.value = 1;
    
    try {
      final reviews = await _storeRepo.getReviewsForProduct(_productId, 1);
      if (reviews.isEmpty) {
        hasMoreData.value = false;
      }
      reviewList.assignAll(reviews);
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat ulasan: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// 2. Listener scroll (dipicu saat user scroll)
  void _scrollListener() {
    // Cek jika user sudah di akhir list DAN tidak sedang loading
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent &&
        !isLoadingMore.value &&
        hasMoreData.value) {
      
      loadMoreReviews();
    }
  }

  /// 3. Ambil data halaman berikutnya
  Future<void> loadMoreReviews() async {
    isLoadingMore.value = true;
    currentPage.value++; // Naikkan halaman

    try {
      final newReviews = await _storeRepo.getReviewsForProduct(_productId, currentPage.value);
      
      if (newReviews.isEmpty) {
        // Data sudah habis
        hasMoreData.value = false;
      } else {
        reviewList.addAll(newReviews); // Tambahkan ke list yang ada
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat lebih banyak ulasan: $e");
    } finally {
      isLoadingMore.value = false;
    }
  }
}