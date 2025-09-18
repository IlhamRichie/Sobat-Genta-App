// lib/data/models/rab_item_model.dart
// (Buat file baru)
class RabItemModel {
  final String itemName;
  final double cost;

  RabItemModel({required this.itemName, required this.cost});

  factory RabItemModel.fromJson(Map<String, dynamic> json) {
    return RabItemModel(
      itemName: json['item_name'] ?? 'N/A',
      cost: (json['cost'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

// lib/data/models/project_farmer_profile_model.dart
// (Buat file baru)
class ProjectFarmerProfileModel {
  final String userId;
  final String fullName;
  final String? profilePictureUrl;
  final int totalProjects; // Total proyek petani ini

  ProjectFarmerProfileModel({
    required this.userId,
    required this.fullName,
    this.profilePictureUrl,
    required this.totalProjects,
  });
  
  factory ProjectFarmerProfileModel.fromJson(Map<String, dynamic> json) {
    return ProjectFarmerProfileModel(
      userId: json['user_id'].toString(),
      fullName: json['full_name'] ?? 'Petani Genta',
      profilePictureUrl: json['profile_picture_url'],
      totalProjects: (json['total_projects'] as num?)?.toInt() ?? 0,
    );
  }
}