// lib/app/modules/product_detail/controllers/product_detail_controller.dart

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../data/models/product_model.dart';
import '../../../../data/repositories/abstract/store_repository.dart';
import '../../../../routes/app_pages.dart';
import '../../../../services/cart_service.dart';


class ProductDetailController extends GetxController {

  // --- DEPENDENCIES ---
  final IStoreRepository _storeRepo = Get.find<IStoreRepository>();

  // --- STATE ---
  final RxBool isLoadingPage = true.obs;
  final Rx<ProductModel?> product = Rxn<ProductModel>();
  late final String _productId;
  
  // --- STATE AKSI ---
  final RxInt quantity = 1.obs;
  final RxBool isAddingToCart = false.obs;

  final CartService _cartService = Get.find<CartService>(); // <-- INJEKSI SERVICE

  @override
  void onInit() {
    super.onInit();
    // 1. Ambil ID dari navigasi
    _productId = Get.arguments as String;
    // 2. Ambil data detail
    fetchProductDetail();
  }

  /// Ambil data detail lengkap dari repo
  Future<void> fetchProductDetail() async {
    isLoadingPage.value = true;
    try {
      final data = await _storeRepo.getProductById(_productId);
      product.value = data;
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat produk: $e");
    } finally {
      isLoadingPage.value = false;
    }
  }
  
  // --- LOGIKA KUANTITAS ---
  void incrementQuantity() {
    int stock = product.value?.stockQuantity ?? 0;
    if (quantity.value < stock) {
      quantity.value++;
    } else {
      Get.snackbar("Stok", "Kuantitas melebihi stok yang tersedia ($stock unit).");
    }
  }

  void decrementQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  // --- LOGIKA AKSI ---
  
  /// Aksi "Tambah ke Keranjang"
  Future<void> addToCart() async {
    isAddingToCart.value = true;
    try {
      // Panggil CartService yang sebenarnya!
      await _cartService.addItemToCart(product.value!, quantity.value);

      showTopSnackBar(
        Overlay.of(Get.context!),
        CustomSnackBar.success(
          message: "${product.value!.name} (x${quantity.value}) berhasil ditambahkan.",
          backgroundColor: Colors.green.shade700,
        ),
      );
    } catch (e) {
      showTopSnackBar(
        Overlay.of(Get.context!),
        CustomSnackBar.error(message: "Gagal: $e"),
      );
    } finally {
      isAddingToCart.value = false;
    }
  }

  void goToAllReviews() {
    Get.toNamed(Routes.PRODUCT_REVIEWS, arguments: _productId);
  }
}