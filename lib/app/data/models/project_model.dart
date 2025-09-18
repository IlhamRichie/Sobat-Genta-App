// lib/data/models/project_model.dart
// (Buat file baru atau update yang sebelumnya)

import 'rab_item_model.dart';

enum ProjectStatus { PENDING_ADMIN, PUBLISHED, FUNDED, COMPLETED, REJECTED, UNKNOWN }

class ProjectModel {
  final String projectId;
  final String title;
  final double targetFund;
  final double collectedFund;
  final ProjectStatus status;
  final String assetName;
  final String? projectImageUrl;

  final String description;
  final int durationDays;
  final double roiPercentage;
  final List<RabItemModel> rabItems; // <-- RAB yang sudah diparsing
  final ProjectFarmerProfileModel farmerProfile; // <-- Info Petani

  ProjectModel({
    required this.projectId,
    required this.title,
    required this.targetFund,
    required this.collectedFund,
    required this.status,
    required this.assetName,
    this.projectImageUrl,

    required this.description,
    required this.durationDays,
    required this.roiPercentage,
    required this.rabItems,
    required this.farmerProfile,
  });

  // Helper untuk progres bar (0.0 sampai 1.0)
  double get fundingProgress => (collectedFund > 0 && targetFund > 0) ? (collectedFund / targetFund) : 0.0;

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    // Parsing RAB
    List<RabItemModel> parsedRab = [];
    if (json['rab_details_json'] != null && json['rab_details_json'] is List) {
      parsedRab = (json['rab_details_json'] as List)
          .map((item) => RabItemModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    
    // Parsing Profil Petani
    ProjectFarmerProfileModel parsedProfile;
    if (json['farmer_profile'] != null) {
      parsedProfile = ProjectFarmerProfileModel.fromJson(json['farmer_profile']);
    } else {
      // Fallback jika data petani tidak di-JOIN
      parsedProfile = ProjectFarmerProfileModel.fromJson({
        'user_id': json['user_id']?.toString() ?? '0',
        'full_name': 'Petani SobatGenta',
        'total_projects': 1
      });
    }

    return ProjectModel(
      projectId: json['project_id'].toString(),
      title: json['title'],
      targetFund: (json['target_fund'] as num).toDouble(),
      collectedFund: (json['collected_fund'] as num?)?.toDouble() ?? 0.0,
      status: _parseStatus(json['status']),
      assetName: json['asset_name'] ?? 'Nama Aset Tidak Ada',
      projectImageUrl: json['project_image_url'],

      description: json['description'] ?? 'Tidak ada deskripsi.',
      durationDays: (json['duration_days'] as num?)?.toInt() ?? 0,
      roiPercentage: (json['roi_percentage'] as num?)?.toDouble() ?? 0.0,
      rabItems: parsedRab,
      farmerProfile: parsedProfile,
    );
  }

  static ProjectStatus _parseStatus(String? status) {
    switch (status?.toUpperCase()) {
      case 'PENDING_ADMIN': return ProjectStatus.PENDING_ADMIN;
      case 'PUBLISHED': return ProjectStatus.PUBLISHED;
      case 'FUNDED': return ProjectStatus.FUNDED;
      case 'COMPLETED': return ProjectStatus.COMPLETED;
      case 'REJECTED': return ProjectStatus.REJECTED;
      default: return ProjectStatus.UNKNOWN;
    }
  }
}