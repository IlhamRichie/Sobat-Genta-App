// lib/app/modules/farmer_manage_assets/controllers/farmer_manage_assets_controller.dart

import 'package:get/get.dart';

import '../../../../data/models/asset_model.dart';
import '../../../../data/repositories/abstract/asset_repository.dart';
import '../../../../routes/app_pages.dart';

class FarmerManageAssetsController extends GetxController {
  
  // --- DEPENDENCIES ---
  final IAssetRepository _assetRepo = Get.find<IAssetRepository>();

  // --- STATE ---
  final RxBool isLoading = true.obs;
  final RxList<AssetModel> assetList = <AssetModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAssets();
  }

  /// Mengambil data aset dari repository
  Future<void> fetchAssets() async {
    isLoading.value = true;
    assetList.clear(); // Kosongkan list dulu
    
    try {
      final assets = await _assetRepo.getMyAssets();
      assetList.assignAll(assets);
    } catch (e) {
      Get.snackbar("Error", "Gagal mengambil data aset: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Navigasi ke form tambah aset
  void goToAddAsset() async {
    // --- UPDATE DI SINI ---
    // Kita 'await' navigasi ini untuk mendapatkan 'result'
    final result = await Get.toNamed(Routes.FARMER_ADD_ASSET_FORM);

    // Jika 'result' adalah 'success' (dari form controller),
    // kita panggil 'fetchAssets' lagi untuk refresh list.
    if (result == 'success') {
      fetchAssets();
    }
  }

  /// Navigasi ke detail aset
  void goToAssetDetail(AssetModel asset) {
    Get.toNamed(Routes.FARMER_ASSET_DETAIL, arguments: asset.assetId);
  }
}