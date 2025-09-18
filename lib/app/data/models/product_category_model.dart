// lib/data/models/product_category_model.dart
// (Buat file baru)

class ProductCategoryModel {
  final String categoryId;
  final String name;
  final String iconUrl; // Bisa URL atau path asset lokal

  ProductCategoryModel({
    required this.categoryId,
    required this.name,
    required this.iconUrl,
  });

  factory ProductCategoryModel.fromJson(Map<String, dynamic> json) {
    return ProductCategoryModel(
      categoryId: json['category_id'].toString(),
      name: json['name'],
      iconUrl: json['icon_url'],
    );
  }
}