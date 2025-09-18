// lib/data/repositories/abstract/asset_repository.dart
// (Buat file baru)

import 'dart:io';

import '../../models/asset_model.dart';

abstract class IAssetRepository {
  /// Mengambil semua aset yang dimiliki user saat ini
  Future<List<AssetModel>> getMyAssets();

  Future<void> addAsset(Map<String, dynamic> textData, List<File> files);

  Future<AssetModel> getAssetById(String assetId);
}