// lib/data/models/asset_model.dart
// (Buat file baru)

enum AssetStatus { PENDING, VERIFIED, REJECTED, UNKNOWN }

class AssetModel {
  final String assetId;
  final String name;
  final String location;
  final String assetType; // 'PERTANIAN' atau 'PETERNAKAN'
  final AssetStatus status;
  final String? imageUrl; // Ini akan jadi foto lahan
  
  // --- TAMBAHKAN FIELD INI ---
  final String areaSize;
  final String assetDetails; // (Jenis Tanaman / Jenis Ternak)
  final String? certificateImageUrl;

  AssetModel({
    required this.assetId,
    required this.name,
    required this.location,
    required this.assetType,
    required this.status,
    this.imageUrl,
    // --- TAMBAHKAN INI ---
    required this.areaSize,
    required this.assetDetails,
    this.certificateImageUrl,
  });

  factory AssetModel.fromJson(Map<String, dynamic> json) {
    // Ambil detail dinamis dari 'details_json'
    String details = "N/A";
    if (json['details_json'] != null) {
      // Asumsi 'details_json' adalah Map, tapi di fake repo kita
      // kita mungkin simpan sbg string. Kita buat aman.
      try {
         details = (json['details_json'] as Map<String, dynamic>)['jenis'] ?? 'Detail tidak ada';
      } catch (e) {
         details = json['details_json'].toString(); // fallback
      }
    }

    return AssetModel(
      assetId: json['land_id'].toString(),
      name: json['name'],
      location: json['location'],
      assetType: json['type'],
      status: _parseStatus(json['status']),
      imageUrl: json['image_url'],
      // --- TAMBAHKAN PARSING INI ---
      areaSize: json['area_size']?.toString() ?? 'N/A',
      assetDetails: details,
      certificateImageUrl: json['certificate_image_url'],
    );
  }

  static AssetStatus _parseStatus(String? status) {
    switch (status?.toUpperCase()) {
      case 'VERIFIED':
        return AssetStatus.VERIFIED;
      case 'REJECTED':
        return AssetStatus.REJECTED;
      case 'PENDING':
      default:
        return AssetStatus.PENDING;
    }
  }
}