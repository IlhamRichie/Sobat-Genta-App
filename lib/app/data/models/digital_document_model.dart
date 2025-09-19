// lib/data/models/digital_document_model.dart
// (Buat file baru)
import 'package:intl/intl.dart';

enum DocumentType { ARTICLE, VIDEO, PDF }

class DigitalDocumentModel {
  final String documentId;
  final String title;
  final String category; // PERTANIAN / PETERNAKAN
  final String snippet; // Deskripsi singkat untuk list
  final String? contentUrl; // URL ke artikel/PDF/video
  final String? contentBody; // Teks lengkap jika tipenya ARTICLE
  final DocumentType type;
  final String? thumbnailUrl;
  final DateTime publishedDate;

  DigitalDocumentModel({
    required this.documentId,
    required this.title,
    required this.category,
    required this.snippet,
    this.contentUrl,
    this.contentBody,
    required this.type,
    this.thumbnailUrl,
    required this.publishedDate,
  });

  String get formattedDate => DateFormat('d MMMM yyyy', 'id_ID').format(publishedDate);

  factory DigitalDocumentModel.fromJson(Map<String, dynamic> json) {
    DocumentType docType;
    switch (json['content_type']?.toUpperCase()) {
      case 'VIDEO': docType = DocumentType.VIDEO; break;
      case 'PDF': docType = DocumentType.PDF; break;
      default: docType = DocumentType.ARTICLE;
    }
    
    return DigitalDocumentModel(
      documentId: json['document_id'].toString(),
      title: json['title'],
      category: json['category'],
      snippet: json['snippet'] ?? json['description'] ?? '',
      contentUrl: json['content_url'],
      contentBody: json['content_body'],
      type: docType,
      thumbnailUrl: json['thumbnail_url'],
      publishedDate: DateTime.parse(json['published_at']),
    );
  }
}