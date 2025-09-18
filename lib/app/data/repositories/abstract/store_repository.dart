// lib/data/repositories/abstract/store_repository.dart
// (Buat file baru)

import '../../models/product_category_model.dart';
import '../../models/product_model.dart';

abstract class IStoreRepository {
  /// Mengambil daftar kategori produk
  Future<List<ProductCategoryModel>> getProductCategories();

  /// Mengambil daftar produk unggulan/terlaris untuk home
  Future<List<ProductModel>> getFeaturedProducts();
}