// lib/data/repositories/implementations/fake_cart_repository.dart
// (Buat file baru)
import 'package:get/get.dart';

import '../../models/cart_item_model.dart';
import '../../models/product_model.dart';
import '../abstract/cart_repository.dart';
import '../abstract/store_repository.dart';

class FakeCartRepository implements ICartRepository {
  // Ambil repo toko untuk mengambil data produk palsu
  final IStoreRepository _storeRepo = Get.find<IStoreRepository>(); 
  
  // --- DATABASE KERANJANG PALSU (STATEFUL) ---
  // Mensimulasikan tabel 'cartitems'
  final List<Map<String, dynamic>> _fakeCartDB = [];

  @override
  Future<List<CartItemModel>> getMyCartItems() async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Konversi DB palsu kita ke List<CartItemModel>
    return _fakeCartDB.map((json) => CartItemModel.fromJson(json)).toList();
  }

  @override
  Future<void> addToCart(String productId, int quantity) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulasi API call
    
    // 1. Cek apakah produk sudah ada di keranjang
    final existingIndex = _fakeCartDB.indexWhere(
      (item) => item['product']['product_id'] == productId
    );

    if (existingIndex != -1) {
      // 2a. Jika ada: Update kuantitas
      int currentQty = _fakeCartDB[existingIndex]['quantity'];
      _fakeCartDB[existingIndex]['quantity'] = currentQty + quantity;
      print("Cart Repo: Quantity updated for $productId");
    } else {
      // 2b. Jika tidak ada: Ambil data produk & tambahkan
      final ProductModel productData = await _storeRepo.getProductById(productId);
      
      _fakeCartDB.add({
        "cart_item_id": "CART-ITEM-${DateTime.now().millisecondsSinceEpoch}",
        "quantity": quantity,
        "product": {
          // Kita hanya simpan data relevan
          "product_id": productData.productId,
          "name": productData.name,
          "price": productData.price,
          "image_url": productData.imageUrl,
          "stock_quantity": productData.stockQuantity,
          "average_rating": 0.0,
          "review_count": 0
        }
      });
      print("Cart Repo: New item added $productId");
    }
  }

  @override
  Future<void> updateCartItemQuantity(String cartItemId, int newQuantity) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _fakeCartDB.indexWhere((item) => item['cart_item_id'] == cartItemId);
    if (index != -1) {
      _fakeCartDB[index]['quantity'] = newQuantity;
    }
  }

  @override
  Future<void> removeCartItem(String cartItemId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _fakeCartDB.removeWhere((item) => item['cart_item_id'] == cartItemId);
  }

  @override
  Future<void> clearMyCart() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _fakeCartDB.clear();
    print("Fake Cart: Keranjang dikosongkan.");
  }
}