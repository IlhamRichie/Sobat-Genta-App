// lib/data/models/cart_item_model.dart
// (Buat file baru)

import 'product_model.dart';

class CartItemModel {
  final String cartItemId; // ID unik dari tabel cartitems
  int quantity;
  final ProductModel product; // Objek Product yang di-JOIN

  CartItemModel({
    required this.cartItemId,
    required this.quantity,
    required this.product,
  });

  // Kalkulasi subtotal
  double get subTotal => product.price * quantity;

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      cartItemId: json['cart_item_id'].toString(),
      quantity: (json['quantity'] as num).toInt(),
      // API backend harus melakukan JOIN dan menyertakan objek produk
      product: ProductModel.fromJson(json['product'] as Map<String, dynamic>),
    );
  }
}