// lib/data/models/product_model.dart
// (Buat file baru)
import 'package:intl/intl.dart';

import 'product_review_model.dart';

class ProductModel {
  final String productId;
  final String name;
  final double price;
  final String? imageUrl;
  final double rating;
  final int reviewCount;

  final String? fullDescription;
  final List<String>? galleryImageUrls;
  final int? stockQuantity;
  final List<ProductReviewModel>? recentReviews;

  ProductModel({
    required this.productId,
    required this.name,
    required this.price,
    this.imageUrl,
    required this.rating,
    required this.reviewCount,

    this.fullDescription,
    this.galleryImageUrls,
    this.stockQuantity,
    this.recentReviews,
  });

  // Helper
  String get formattedPrice => 
    NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(price);

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // Parsing data opsional (detail)
    List<ProductReviewModel> reviews = [];
    if (json['recent_reviews'] != null && json['recent_reviews'] is List) {
      reviews = (json['recent_reviews'] as List)
          .map((r) => ProductReviewModel.fromJson(r as Map<String, dynamic>))
          .toList();
    }
    
    List<String> gallery = [];
    if (json['gallery_image_urls'] != null && json['gallery_image_urls'] is List) {
      gallery = List<String>.from(json['gallery_image_urls']);
    } else if (json['image_url'] != null) {
      gallery = [json['image_url']]; // Fallback ke gambar utama
    }

    return ProductModel(
      productId: json['product_id'].toString(),
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      imageUrl: json['image_url'],
      rating: (json['average_rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (json['review_count'] as num?)?.toInt() ?? 0,
      
      // --- Parsing data detail ---
      fullDescription: json['full_description'],
      galleryImageUrls: gallery,
      stockQuantity: (json['stock_quantity'] as num?)?.toInt() ?? 0,
      recentReviews: reviews,
    );
  }
}