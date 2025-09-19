// lib/data/repositories/abstract/digital_library_repository.dart
// (Buat file baru)

import '../../models/digital_document_model.dart';

abstract class IDigitalLibraryRepository {
  /// Mengambil daftar dokumen (dengan pagination dan search)
  Future<List<DigitalDocumentModel>> getLibraryDocuments({
    required int page,
    int limit = 10,
    String? searchTerm,
    String? category,
  });
}