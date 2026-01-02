// lib/app/data/models/project_model.dart

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
  final double roiEstimate; // Diubah dari roiPercentage agar sesuai View
  final List<RabItemModel> rabItems;
  final ProjectFarmerProfileModel farmerProfile;

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
    required this.roiEstimate, // Update constructor
    required this.rabItems,
    required this.farmerProfile,
  });

  // Helper untuk progres bar (0.0 sampai 1.0)
  // Mencegah pembagian dengan nol atau nilai negatif
  double get fundingProgress {
    if (targetFund <= 0) return 0.0;
    double progress = collectedFund / targetFund;
    return progress > 1.0 ? 1.0 : progress; // Cap di 100%
  }

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    // Parsing RAB (Rencana Anggaran Biaya)
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
      // Data dummy/fallback jika join gagal
      parsedProfile = ProjectFarmerProfileModel(
        userId: json['user_id']?.toString() ?? '0',
        fullName: 'Petani SobatGenta',
        totalProjects: 1,
        profilePictureUrl: null,
      );
    }

    return ProjectModel(
      projectId: json['project_id'].toString(),
      title: json['title'] ?? 'Tanpa Judul',
      targetFund: (json['target_fund'] as num?)?.toDouble() ?? 0.0,
      collectedFund: (json['collected_fund'] as num?)?.toDouble() ?? 0.0,
      status: _parseStatus(json['status']),
      assetName: json['asset_name'] ?? 'Aset Tani',
      projectImageUrl: json['project_image_url'],
      description: json['description'] ?? 'Tidak ada deskripsi tersedia.',
      durationDays: (json['duration_days'] as num?)?.toInt() ?? 0,
      // Mapping dari key JSON 'roi_percentage' ke field 'roiEstimate'
      roiEstimate: (json['roi_percentage'] as num?)?.toDouble() ?? 0.0,
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