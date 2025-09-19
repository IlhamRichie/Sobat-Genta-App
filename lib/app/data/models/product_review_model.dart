// lib/data/models/product_review_model.dart
// (Buat file baru)

class ProductReviewModel {
  final String reviewId;
  final String userName;
  final String? userImageUrl;
  final double rating;
  final String comment;
  final DateTime timestamp;

  ProductReviewModel({
    required this.reviewId,
    required this.userName,
    this.userImageUrl,
    required this.rating,
    required this.comment,
    required this.timestamp,
  });

  factory ProductReviewModel.fromJson(Map<String, dynamic> json) {
    return ProductReviewModel(
      reviewId: json['review_id'].toString(),
      userName: json['user_name'] ?? 'Pengguna Genta', // Hasil JOIN
      userImageUrl: json['user_image_url'],
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] ?? '',
      timestamp: DateTime.tryParse(json['timestamp']) ?? DateTime.now(),
    );
  }
}