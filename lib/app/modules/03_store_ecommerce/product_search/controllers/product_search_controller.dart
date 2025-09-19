// lib/app/modules/product_search/controllers/product_search_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/models/product_category_model.dart';
import '../../../../data/models/product_model.dart';
import '../../../../data/repositories/abstract/store_repository.dart';
import '../../../../routes/app_pages.dart';

class ProductSearchController extends GetxController {

  // --- DEPENDENCIES ---
  final IStoreRepository _storeRepo = Get.find<IStoreRepository>();

  // --- STATE ---
  final RxBool isLoading = true.obs;
  final RxList<ProductModel> productList = <ProductModel>[].obs;

  // --- FILTER STATE ---
  final TextEditingController searchC = TextEditingController();
  final Rxn<ProductCategoryModel> selectedCategory = Rxn<ProductCategoryModel>();
  final RxString searchTerm = ''.obs;
  final RxString sortBy = 'rating'.obs; // Default sort

  @override
  void onInit() {
    super.onInit();
    
    // 1. Ambil argumen dari StoreHome (jika ada)
    if (Get.arguments != null && Get.arguments['category'] != null) {
      selectedCategory.value = Get.arguments['category'] as ProductCategoryModel;
    }
    
    // 2. Setup DEBOUNCER (Best Practice)
    // Ini memastikan kita tidak memanggil API di setiap ketikan,
    // tapi hanya menunggu 800ms setelah user berhenti mengetik.
    debounce(searchTerm, (_) => searchAndFilterProducts(), 
      time: const Duration(milliseconds: 800));
    
    // 3. Panggilan API Awal
    searchAndFilterProducts();
  }

  @override
  void onClose() {
    searchC.dispose();
    super.onClose();
  }

  /// Metode PUSAT untuk mengambil data dari API
  Future<void> searchAndFilterProducts() async {
    isLoading.value = true;
    productList.clear();
    
    try {
      final results = await _storeRepo.searchProducts(
        categoryId: selectedCategory.value?.categoryId,
        searchTerm: searchTerm.value.isEmpty ? null : searchTerm.value,
        sortBy: sortBy.value,
      );
      productList.assignAll(results);
    } catch (e) {
      Get.snackbar("Error", "Gagal mencari produk: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // --- METODE YANG DIPANGGIL DARI UI ---

  /// Dipanggil oleh Search Bar (onChanged)
  void onSearchChanged(String query) {
    searchTerm.value = query; // Ini akan memicu Debouncer
  }
  
  /// Dipanggil saat 'Clear' di search bar
  void onClearSearch() {
    searchC.clear();
    searchTerm.value = '';
    // (Debouncer akan otomatis memicu searchAndFilterProducts)
  }

  /// Dipanggil dari tombol Sort By
  void setSortBy(String newSortValue) {
    sortBy.value = newSortValue;
    Get.back(); // Tutup modal bottom sheet
    searchAndFilterProducts(); // Panggil API lagi dengan urutan baru
  }
  
  /// Dipanggil jika user menghapus chip kategori
  void clearCategoryFilter() {
    selectedCategory.value = null;
    searchAndFilterProducts(); // Panggil API lagi tanpa filter kategori
  }

  /// Navigasi ke Detail
  void goToProductDetail(ProductModel product) {
    Get.toNamed(Routes.PRODUCT_DETAIL, arguments: product.productId);
  }
}