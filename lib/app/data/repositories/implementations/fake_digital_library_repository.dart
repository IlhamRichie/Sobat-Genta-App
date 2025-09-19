// lib/data/repositories/implementations/fake_digital_library_repository.dart
// (Buat file baru)

import '../../models/digital_document_model.dart';
import '../abstract/digital_library_repository.dart';

class FakeDigitalLibraryRepository implements IDigitalLibraryRepository {

  // --- DATABASE PERPUSTAKAAN PALSU ---
  final List<Map<String, dynamic>> _mockLibraryDB = List.generate(40, (i) {
    bool isTani = i % 2 == 0;
    return {
      "document_id": "DOC-${i+1}",
      "title": isTani ? "Cara Atasi Hama Wereng #${i+1}" : "Mengenal Gejala PMK pada Sapi #${i+1}",
      "category": isTani ? "PERTANIAN" : "PETERNAKAN",
      "snippet": "Deskripsi singkat tentang dokumen #${i+1}...",
      "content_url": isTani ? null : "https://youtube.com/watch?v=123", // Video
      "content_body": isTani ? "Ini adalah isi artikel lengkap..." : null, // Artikel
      "content_type": isTani ? "ARTICLE" : "VIDEO",
      "thumbnail_url": null,
      "published_at": DateTime.now().subtract(Duration(days: i)).toIso8601String()
    };
  });


  @override
  Future<List<DigitalDocumentModel>> getLibraryDocuments({
    required int page,
    int limit = 10,
    String? searchTerm,
    String? category,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800)); // Simulasi API
    
    List<Map<String, dynamic>> results = List.from(_mockLibraryDB);
    
    // 1. Filter Kategori
    if (category != null) {
      results = results.where((doc) => doc['category'] == category).toList();
    }
    
    // 2. Filter Search
    if (searchTerm != null && searchTerm.isNotEmpty) {
      results = results.where((doc) => 
        (doc['title'] as String).toLowerCase().contains(searchTerm.toLowerCase())
      ).toList();
    }

    // 3. Logika Pagination Palsu
    final startIndex = (page - 1) * limit;
    if (startIndex >= results.length) {
      return []; // Halaman habis
    }
    final endIndex = (startIndex + limit > results.length) ? results.length : (startIndex + limit);
    final pageData = results.sublist(startIndex, endIndex);
    
    return pageData.map((json) => DigitalDocumentModel.fromJson(json)).toList();
  }
}