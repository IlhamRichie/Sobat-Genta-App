// lib/app/modules/farmer_asset_detail/controllers/farmer_asset_detail_controller.dart

import 'package:get/get.dart';

import '../../../../data/models/asset_model.dart';
import '../../../../data/repositories/abstract/asset_repository.dart';
import '../../../../routes/app_pages.dart';

class FarmerAssetDetailController extends GetxController {

  // --- DEPENDENCIES ---
  final IAssetRepository _assetRepo = Get.find<IAssetRepository>();
  
  // --- STATE ---
  final RxBool isLoading = true.obs;
  final Rx<AssetModel?> asset = Rx<AssetModel?>(null);
  
  // --- LOGIKA KUNCI ---
  // State untuk mengontrol tombol "Ajukan Pendanaan"
  final RxBool isFundingButtonEnabled = false.obs;
  final RxString fundingButtonMessage = "".obs; // Pesan jika non-aktif

  late final String _assetId;

  @override
  void onInit() {
    super.onInit();
    // 1. Ambil assetId dari argumen navigasi
    _assetId = Get.arguments as String;
    // 2. Ambil data detail terbaru
    fetchAssetDetail();
  }

  /// Mengambil data detail dari repository
  Future<void> fetchAssetDetail() async {
    isLoading.value = true;
    isFundingButtonEnabled.value = false;
    
    try {
      final data = await _assetRepo.getAssetById(_assetId);
      asset.value = data;
      
      // --- LOGIKA KRITIS (Flowchart P4 & P5) ---
      // Cek status aset dan set tombol
      switch (data.status) {
        case AssetStatus.VERIFIED:
          isFundingButtonEnabled.value = true;
          fundingButtonMessage.value = "Aset Anda telah terverifikasi dan siap diajukan pendanaan.";
          break;
        case AssetStatus.PENDING:
          isFundingButtonEnabled.value = false;
          fundingButtonMessage.value = "Tombol ini akan aktif setelah Admin memverifikasi aset Anda.";
          break;
        case AssetStatus.REJECTED:
          isFundingButtonEnabled.value = false;
          fundingButtonMessage.value = "Aset Anda ditolak. Harap edit data aset atau hubungi Admin.";
          break;
        default:
          isFundingButtonEnabled.value = false;
          fundingButtonMessage.value = "Status aset tidak diketahui.";
      }
      
    } catch (e) {
      Get.snackbar("Error", "Gagal mengambil data aset: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Aksi untuk tombol "Ajukan Pendanaan" (Flowchart P6)
  void goToApplyFunding() {
    if (isFundingButtonEnabled.value) {
      // Kirim objek Aset yang sudah lengkap ke form pengajuan
      Get.toNamed(Routes.FARMER_APPLY_FUNDING_FORM, arguments: asset.value);
    }
  }
}