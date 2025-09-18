// lib/data/repositories/implementations/fake_asset_repository.dart
// (Buat file baru)

import 'dart:io';

import '../../models/asset_model.dart';
import '../abstract/asset_repository.dart';

class FakeAssetRepository implements IAssetRepository {
  
  // Sesuai Skenario 1 (Budi)
  final List<Map<String, dynamic>> _mockAssets = [
    {
      "land_id": "LHN-001",
      "name": "Lahan Bawang Kejayaan",
      "location": "Temanggung, Jawa Tengah",
      "type": "PERTANIAN",
      "status": "VERIFIED", // Sesuai Skenario 1
      "image_url": "https://example.com/images/bawang.jpg",
      "area_size": "2 Hektar",
      "details_json": {"jenis": "Bawang Merah"},
      "certificate_image_url": "https://example.com/images/sertifikat1.jpg"
    },
    {
      "land_id": "TRK-002",
      "name": "Peternakan Sapi Perah",
      "location": "Boyolali, Jawa Tengah",
      "type": "PETERNAKAN",
      "status": "PENDING",
      "image_url": "https://example.com/images/sapi.jpg",
      "area_size": "500 m²",
      "details_json": {"jenis": "Sapi Perah Friesian Holstein"},
      "certificate_image_url": "https://example.com/images/sertifikat2.jpg"
    }
  ];

  @override
  Future<List<AssetModel>> getMyAssets() async {
    await Future.delayed(const Duration(seconds: 1));
    
    // Konversi map menjadi list model
    return _mockAssets.map((json) => AssetModel.fromJson(json)).toList();
  }

  @override
  Future<void> addAsset(Map<String, dynamic> textData, List<File> files) async {
    await Future.delayed(const Duration(seconds: 2));
    
    print("--- FAKE ASSET ADDED ---");
    print("Data: $textData");
    print("Files: ${files.map((f) => f.path).toList()}");
    
    // Buat data aset baru (palsu)
    final newAsset = {
      "land_id": "NEW-${DateTime.now().millisecondsSinceEpoch}",
      "name": textData['name'],
      "location": textData['location'],
      "type": textData['asset_type'],
      "status": "PENDING",
      "image_url": null,
      "area_size": textData['area_size'],
      "details_json": textData['details_json'],
      "certificate_image_url": null,
    };
    _mockAssets.add(newAsset);
  }

  @override
  Future<AssetModel> getAssetById(String assetId) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulasi network
    
    final assetJson = _mockAssets.firstWhere(
      (asset) => asset['land_id'] == assetId,
      orElse: () => throw Exception("Aset tidak ditemukan"),
    );
    
    return AssetModel.fromJson(assetJson);
  }
}