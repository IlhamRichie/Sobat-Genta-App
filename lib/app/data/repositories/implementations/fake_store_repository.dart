// lib/data/repositories/implementations/fake_store_repository.dart
// (Buat file baru)

import '../../models/product_category_model.dart';
import '../../models/product_model.dart';
import '../abstract/store_repository.dart';

class FakeStoreRepository implements IStoreRepository {

  final List<Map<String, dynamic>> _mockCategories = [
    {"category_id": "CAT-01", "name": "Bibit", "icon_url": "leaf"}, //
    {"category_id": "CAT-02", "name": "Pupuk", "icon_url": "seedling"}, //
    {"category_id": "CAT-03", "name": "Obat Ternak", "icon_url": "syringe"}, //
    {"category_id": "CAT-04", "name": "Pestisida", "icon_url": "spider"},
    {"category_id": "CAT-05", "name": "Alat Tani", "icon_url": "tractor"},
  ];

  final List<Map<String, dynamic>> _mockProducts = [
    {
      "product_id": "PROD-001", "name": "Pupuk NPK Mutiara (Repack 1kg)",
      "price": 18000.0, "image_url": null, "average_rating": 4.8, "review_count": 120
    },
    {
      "product_id": "PROD-002", "name": "Bibit Bawang Merah (Super)", //
      "price": 45000.0, "image_url": null, "average_rating": 4.9, "review_count": 88
    },
    {
      "product_id": "PROD-003", "name": "Obat PMK (Antibiotik)", //
      "price": 75000.0, "image_url": null, "average_rating": 4.7, "review_count": 45
    },
    {
      "product_id": "PROD-004", "name": "Cangkul Baja Modern",
      "price": 150000.0, "image_url": null, "average_rating": 4.6, "review_count": 92
    }
  ];

  @override
  Future<List<ProductCategoryModel>> getProductCategories() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockCategories.map((json) => ProductCategoryModel.fromJson(json)).toList();
  }

  @override
  Future<List<ProductModel>> getFeaturedProducts() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return _mockProducts.map((json) => ProductModel.fromJson(json)).toList();
  }
}