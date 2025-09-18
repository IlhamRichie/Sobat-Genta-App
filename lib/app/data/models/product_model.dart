// lib/data/models/product_model.dart
// (Buat file baru)
import 'package:intl/intl.dart';

class ProductModel {
  final String productId;
  final String name;
  final double price;
  final String? imageUrl;
  final double rating;
  final int reviewCount;

  ProductModel({
    required this.productId,
    required this.name,
    required this.price,
    this.imageUrl,
    required this.rating,
    required this.reviewCount,
  });

  // Helper
  String get formattedPrice => 
    NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(price);

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      productId: json['product_id'].toString(),
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      imageUrl: json['image_url'],
      rating: (json['average_rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (json['review_count'] as num?)?.toInt() ?? 0,
    );
  }
}