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
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      floatingActionButton: _buildFloatingActionButton(),
      body: RefreshIndicator(
        onRefresh: controller.fetchAssets,
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (controller.assetList.isEmpty) {
            return _buildEmptyState();
          }

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

  /// AppBar Kustom
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      title: Text(
        "Aset Saya",
        style: Get.textTheme.headlineSmall?.copyWith(
          color: AppColors.textDark,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: false,
    );
  }

  /// FAB yang Ditingkatkan
  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: controller.goToAddAsset,
      icon: const FaIcon(FontAwesomeIcons.plus),
      label: const Text("Tambah Aset"),
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8, // Tambah shadow
    );
  }

  /// Tampilan Empty State yang Didesain Ulang
  Widget _buildEmptyState() {
    return SingleChildScrollView( // Membungkus dengan SingleChildScrollView
      physics: const AlwaysScrollableScrollPhysics(), // Agar RefreshIndicator tetap berfungsi
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Menggunakan ilustrasi SVG atau gambar
              // Contoh: Gunakan SvgPicture.asset jika Anda punya ilustrasi
              // SvgPicture.asset('assets/illustrations/empty-asset.svg', height: 180),
              const FaIcon(FontAwesomeIcons.mapLocationDot, size: 96, color: AppColors.greyLight),
              const SizedBox(height: 32),
              Text(
                "Belum Ada Aset Terdaftar",
                style: Get.textTheme.titleLarge?.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                "Klik tombol 'Tambah Aset' untuk mendaftarkan lahan atau peternakan Anda dan memulai pendanaan.",
                style: Get.textTheme.bodyMedium?.copyWith(
                  fontSize: 16,
                  color: AppColors.textLight,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: controller.goToAddAsset,
                icon: const FaIcon(FontAwesomeIcons.plus),
                label: const Text("Daftarkan Aset Pertama"),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Kartu untuk menampilkan satu aset (Didesain Ulang)
  Widget _buildAssetCard(AssetModel asset) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20), // Sudut lebih rounded
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => controller.goToAssetDetail(asset),
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                // Gambar Aset atau Placeholder
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: asset.imageUrl != null && asset.imageUrl!.isNotEmpty
                      ? Image.network(
                          asset.imageUrl!,
                          height: 160,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 160,
                            color: AppColors.greyLight,
                            child: const Center(child: FaIcon(FontAwesomeIcons.image, size: 48, color: Colors.grey)),
                          ),
                        )
                      : Container(
                          height: 160,
                          color: AppColors.greyLight,
                          child: const Center(child: FaIcon(FontAwesomeIcons.image, size: 48, color: Colors.grey)),
                        ),
                ),
                // Status Badge di pojok kanan atas gambar
                Positioned(
                  top: 12,
                  right: 12,
                  child: _buildStatusBadge(asset.status),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    asset.name,
                    style: Get.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildAssetInfoRow(
                    FontAwesomeIcons.locationDot,
                    asset.location,
                    Get.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  _buildAssetInfoRow(
                    asset.assetType == 'PETERNAKAN' ? FontAwesomeIcons.cow : FontAwesomeIcons.leaf,
                    asset.assetType.capitalizeFirst!,
                    Get.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget untuk baris info (lokasi, tipe)
  Widget _buildAssetInfoRow(IconData icon, String text, TextStyle? style) {
    return Row(
      children: [
        FaIcon(icon, size: 16, color: AppColors.textLight),
        const SizedBox(width: 12),
        Expanded(
          child: Text(text, style: style?.copyWith(color: AppColors.textDark), overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }

  /// Badge untuk status verifikasi aset (Didesain Ulang)
  Widget _buildStatusBadge(AssetStatus status) {
    Color color;
    String text;
    IconData icon;

    switch (status) {
      case AssetStatus.VERIFIED:
        color = Colors.green;
        text = "Terverifikasi";
        icon = FontAwesomeIcons.solidCircleCheck;
        break;
      case AssetStatus.REJECTED:
        color = Colors.red;
        text = "Ditolak";
        icon = FontAwesomeIcons.solidCircleXmark;
        break;
      case AssetStatus.PENDING:
      default:
        color = Colors.orange;
        text = "Menunggu Verifikasi";
        icon = FontAwesomeIcons.solidClock;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(icon, size: 12, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: Get.textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}