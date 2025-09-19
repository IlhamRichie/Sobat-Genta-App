// lib/data/repositories/implementations/fake_store_repository.dart
// (Buat file baru)

import '../../models/product_category_model.dart';
import '../../models/product_model.dart';
import '../../models/product_review_model.dart';
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
      "price": 18000.0, "category_id": "CAT-02", // Pupuk
      "image_url": null, "average_rating": 4.8, "review_count": 120
    },
    {
      "product_id": "PROD-002", "name": "Bibit Bawang Merah (Super)", //
      "price": 45000.0, "category_id": "CAT-01", // Bibit
      "image_url": null, "average_rating": 4.9, "review_count": 88
    },
    {
      "product_id": "PROD-003", "name": "Obat PMK (Antibiotik)", //
      "price": 75000.0, "category_id": "CAT-03", // Obat Ternak
      "image_url": null, "average_rating": 4.7, "review_count": 45
    },
    {
      "product_id": "PROD-004", "name": "Cangkul Baja Modern",
      "price": 150000.0, "category_id": "CAT-05", // Alat
      "image_url": null, "average_rating": 4.6, "review_count": 92
    },
    {
      "product_id": "PROD-005", "name": "Bibit Cabai Rawit Unggul (500 biji)",
      "price": 22000.0, "category_id": "CAT-01", // Bibit
      "image_url": null, "average_rating": 4.8, "review_count": 210
    },
    {
      "product_id": "PROD-006", "name": "Sprayer Elektrik 16L",
      "price": 350000.0, "category_id": "CAT-05", // Alat
      "image_url": null, "average_rating": 4.9, "review_count": 55
    }
  ];

  final Map<String, List<Map<String, dynamic>>> _mockReviewDatabase = {
    "PROD-002": List.generate(25, (i) => { // Buat 25 review palsu
        "review_id": "REV-B$i",
        "user_name": "Petani #${i + 1}",
        "rating": (i % 2 == 0) ? 5.0 : 4.0,
        "comment": "Ini adalah komentar review palsu nomor ${i + 1} untuk bibit bawang.",
        "timestamp": DateTime.now().subtract(Duration(days: i)).toIso8601String()
      }),
    // Produk lain punya sedikit review
     "PROD-001": [
       {"review_id": "REV-A1", "user_name": "Investor Citra", "rating": 5.0, "comment": "Pupuknya bagus.", "timestamp": "2024-11-01T00:00:00Z"}
     ]
  };

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

  @override
  Future<List<ProductModel>> searchProducts({
    String? categoryId,
    String? searchTerm,
    String? sortBy,
  }) async {
    await Future.delayed(const Duration(milliseconds: 700)); // Simulasi API call
    
    List<Map<String, dynamic>> results = List.from(_mockProducts);

    // 1. Filter Kategori (Simulasi Backend)
    if (categoryId != null) {
      results = results.where((p) => p['category_id'] == categoryId).toList();
    }

    // 2. Filter Search Term (Simulasi Backend)
    if (searchTerm != null && searchTerm.isNotEmpty) {
      results = results.where((p) => 
        (p['name'] as String).toLowerCase().contains(searchTerm.toLowerCase())
      ).toList();
    }
    
    // 3. Sorting (Simulasi Backend)
    if (sortBy != null) {
      if (sortBy == 'price_asc') {
        results.sort((a, b) => (a['price'] as double).compareTo(b['price'] as double));
      } else if (sortBy == 'price_desc') {
        results.sort((a, b) => (b['price'] as double).compareTo(a['price'] as double));
      } else if (sortBy == 'rating') {
         results.sort((a, b) => (b['average_rating'] as double).compareTo(a['average_rating'] as double));
      }
    }
    
    return results.map((json) => ProductModel.fromJson(json)).toList();
  }

  @override
  Future<ProductModel> getProductById(String productId) async {
    await Future.delayed(const Duration(milliseconds: 600));

    // 1. Temukan produk dasar dari list palsu kita
    final baseProduct = _mockProducts.firstWhere(
      (p) => p['product_id'] == productId,
      orElse: () => throw Exception("Produk tidak ditemukan"),
    );

    // 2. Tambahkan data detail palsu (yang tidak ada di list)
    baseProduct['full_description'] = "Ini adalah deskripsi lengkap untuk ${baseProduct['name']}. Produk ini sangat berkualitas dan direkomendasikan oleh banyak ahli pertanian dan peternakan di seluruh Indonesia.";
    baseProduct['stock_quantity'] = 88;
    baseProduct['gallery_image_urls'] = [
      "https://example.com/img1.jpg",
      "https://example.com/img2.jpg",
      "https://example.com/img3.jpg"
    ];
    baseProduct['recent_reviews'] = (_mockReviewDatabase[productId] ?? []).take(2).toList();
    return ProductModel.fromJson(baseProduct);
  }

  @override
  Future<List<ProductReviewModel>> getReviewsForProduct(String productId, int page, {int limit = 10}) async {
    await Future.delayed(const Duration(milliseconds: 900)); // Simulasi network

    final allReviewsForProduct = _mockReviewDatabase[productId];
    if (allReviewsForProduct == null) {
      return []; // Tidak ada review
    }
    
    // Logika Pagination Palsu
    final startIndex = (page - 1) * limit;
    if (startIndex >= allReviewsForProduct.length) {
      return []; // Halaman sudah habis, kembalikan list kosong
    }
    
    final endIndex = (startIndex + limit > allReviewsForProduct.length) 
        ? allReviewsForProduct.length 
        : (startIndex + limit);
        
    final pageData = allReviewsForProduct.sublist(startIndex, endIndex);
    
    return pageData.map((json) => ProductReviewModel.fromJson(json)).toList();
  }
}