// lib/data/repositories/abstract/cart_repository.dart
// (Buat file baru)

import '../../models/cart_item_model.dart';

abstract class ICartRepository {
  /// Mengambil semua item di keranjang user
  Future<List<CartItemModel>> getMyCartItems();

  /// Menambah produk ke keranjang (API akan menangani logic 'tambah qty jika ada')
  Future<void> addToCart(String productId, int quantity);

  /// Update kuantitas item spesifik
  Future<void> updateCartItemQuantity(String cartItemId, int newQuantity);

  /// Menghapus item dari keranjang
  Future<void> removeCartItem(String cartItemId);

  Future<void> clearMyCart();
}