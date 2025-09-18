// lib/data/models/project_update_model.dart
// (Buat file baru)
import 'package:intl/intl.dart';

class ProjectUpdateModel {
  final String updateId;
  final String title;
  final String description;
  final String? imageUrl;
  final DateTime timestamp;

  ProjectUpdateModel({
    required this.updateId,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.timestamp,
  });

  // Helper untuk format tanggal
  String get formattedDate => DateFormat('d MMMM yyyy, HH:mm', 'id_ID').format(timestamp);

  factory ProjectUpdateModel.fromJson(Map<String, dynamic> json) {
    return ProjectUpdateModel(
      updateId: json['update_id'].toString(),
      title: json['title'],
      description: json['description'],
      imageUrl: json['image_url'],
      timestamp: DateTime.tryParse(json['timestamp']) ?? DateTime.now(),
    );
  }
}