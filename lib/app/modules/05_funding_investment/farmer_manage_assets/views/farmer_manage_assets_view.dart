// lib/app/modules/farmer_manage_assets/views/farmer_manage_assets_view.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../data/models/asset_model.dart';
import '../../../../theme/app_colors.dart';
import '../controllers/farmer_manage_assets_controller.dart';

class FarmerManageAssetsView extends GetView<FarmerManageAssetsController> {
  const FarmerManageAssetsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manajemen Aset (Lahan/Ternak)"),
        elevation: 0,
      ),
      // Tombol untuk menambah aset baru
      floatingActionButton: FloatingActionButton.extended(
        onPressed: controller.goToAddAsset,
        icon: const FaIcon(FontAwesomeIcons.plus),
        label: const Text("Tambah Aset"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: controller.fetchAssets,
        child: Obx(() {
          // 1. Loading State
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          
          // 2. Empty State
          if (controller.assetList.isEmpty) {
            return _buildEmptyState();
          }

          // 3. Data State
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.assetList.length,
            itemBuilder: (context, index) {
              final asset = controller.assetList[index];
              return _buildAssetCard(asset);
            },
          );
        }),
      ),
    );
  }

  /// Tampilan jika Petani belum mendaftarkan aset
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(FontAwesomeIcons.mapLocationDot, size: 80, color: AppColors.greyLight),
            const SizedBox(height: 24),
            Text(
              "Anda Belum Punya Aset",
              style: Get.textTheme.titleLarge?.copyWith(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "Klik tombol 'Tambah Aset' untuk mendaftarkan lahan atau peternakan Anda agar bisa mengajukan pendanaan.",
              style: Get.textTheme.bodyMedium?.copyWith(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: controller.goToAddAsset,
              icon: const FaIcon(FontAwesomeIcons.plus),
              label: const Text("Daftarkan Aset Pertama"),
            ),
          ],
        ),
      ),
    );
  }

  /// Kartu untuk menampilkan satu aset
  Widget _buildAssetCard(AssetModel asset) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => controller.goToAssetDetail(asset),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Placeholder Gambar Aset
            Container(
              height: 140,
              decoration: BoxDecoration(
                color: AppColors.greyLight,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                // TODO: Ganti dengan Image.network(asset.imageUrl)
              ),
              child: Center(child: FaIcon(FontAwesomeIcons.image, color: Colors.grey.shade400)),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Badge (VERIFIED/PENDING)
                  _buildStatusBadge(asset.status),
                  const SizedBox(height: 8),
                  // Nama Aset
                  Text(
                    asset.name,
                    style: Get.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700, 
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Lokasi
                  Row(
                    children: [
                      const FaIcon(FontAwesomeIcons.locationDot, size: 14, color: AppColors.textLight),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(asset.location, style: Get.textTheme.bodyMedium),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Tipe Aset
                  Row(
                    children: [
                      FaIcon(
                        asset.assetType == 'PETERNAKAN' ? FontAwesomeIcons.cow : FontAwesomeIcons.leaf,
                        size: 14,
                        color: AppColors.textLight,
                      ),
                      const SizedBox(width: 8),
                      Text(asset.assetType.capitalizeFirst!, style: Get.textTheme.bodyMedium),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Badge untuk status verifikasi aset
  Widget _buildStatusBadge(AssetStatus status) {
    Color color;
    String text;
    IconData icon;

    switch (status) {
      case AssetStatus.VERIFIED:
        color = Colors.green.shade700;
        text = "Terverifikasi";
        icon = FontAwesomeIcons.check;
        break;
      case AssetStatus.REJECTED:
        color = Colors.red.shade700;
        text = "Ditolak";
        icon = FontAwesomeIcons.xmark;
        break;
      case AssetStatus.PENDING:
      default:
        color = Colors.orange.shade700;
        text = "Menunggu Verifikasi";
        icon = FontAwesomeIcons.clock;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(icon, size: 12, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: Get.textTheme.bodySmall?.copyWith(color: color, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}