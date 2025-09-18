// lib/app/modules/store_home/controllers/store_home_controller.dart

import 'package:get/get.dart';

import '../../../../data/models/product_category_model.dart';
import '../../../../data/models/product_model.dart';
import '../../../../data/repositories/abstract/store_repository.dart';
import '../../../../routes/app_pages.dart';

class StoreHomeController extends GetxController {

  // --- DEPENDENCIES ---
  final IStoreRepository _storeRepo = Get.find<IStoreRepository>();

  // --- STATE ---
  final RxBool isLoading = true.obs;
  final RxList<ProductCategoryModel> categoryList = <ProductCategoryModel>[].obs;
  final RxList<ProductModel> featuredProductList = <ProductModel>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    fetchStoreDashboard();
  }

  /// Ambil semua data dashboard secara paralel
  Future<void> fetchStoreDashboard() async {
    isLoading.value = true;
    try {
      // BEST PRACTICE: Jalankan kedua fetch bersamaan
      final responses = await Future.wait([
        _storeRepo.getProductCategories(),
        _storeRepo.getFeaturedProducts(),
      ]);
      
      categoryList.assignAll(responses[0] as List<ProductCategoryModel>);
      featuredProductList.assignAll(responses[1] as List<ProductModel>);
      
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat data Toko: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // --- NAVIGASI ---
  
  void goToProductDetail(ProductModel product) {
    Get.toNamed(Routes.PRODUCT_DETAIL, arguments: product.productId);
  }

  void goToCategoryPage(ProductCategoryModel category) {
    Get.toNamed(Routes.PRODUCT_SEARCH, arguments: {'category': category});
  }
  
  void goToCart() {
    Get.toNamed(Routes.CART);
  }
  
  void goToFullSearch() {
    // Arahkan ke halaman search dengan filter kosong
    Get.toNamed(Routes.PRODUCT_SEARCH, arguments: null);
  }
}