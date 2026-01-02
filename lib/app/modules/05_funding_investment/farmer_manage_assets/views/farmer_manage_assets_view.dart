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
      body: Stack(
        children: [
          // 1. BACKGROUND DECORATION
          Positioned(
            top: -100,
            right: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.05), // Nuansa pertanian
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 150,
            left: -80,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // 2. MAIN CONTENT
          SafeArea(
            child: Column(
              children: [
                _buildCustomAppBar(),
                
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: controller.fetchAssets,
                    color: AppColors.primary,
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      
                      if (controller.assetList.isEmpty) {
                        return _buildEmptyState();
                      }

                      return ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 80), // Bottom padding for FAB
                        itemCount: controller.assetList.length,
                        separatorBuilder: (ctx, i) => const SizedBox(height: 20),
                        itemBuilder: (context, index) {
                          final asset = controller.assetList[index];
                          return _buildAssetCard(asset);
                        },
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  /// Custom AppBar
  Widget _buildCustomAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Aset Pertanian",
                style: Get.textTheme.headlineSmall?.copyWith(
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w800,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Kelola lahan dan sumber daya Anda",
                style: Get.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textLight,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          // Filter Icon
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: IconButton(
              onPressed: () { /* TODO: Filter Assets */ },
              icon: const FaIcon(FontAwesomeIcons.sliders, size: 18, color: AppColors.textDark),
              splashRadius: 24,
            ),
          ),
        ],
      ),
    );
  }

  /// Empty State Modern
  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppColors.greyLight.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: const FaIcon(FontAwesomeIcons.tractor, size: 64, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Text(
              "Belum Ada Aset",
              style: Get.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "Daftarkan lahan atau peternakan Anda untuk mulai mendapatkan pendanaan.",
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textLight),
              ),
            ),
            const SizedBox(height: 32),
            OutlinedButton.icon(
              onPressed: controller.goToAddAsset,
              icon: const Icon(Icons.add),
              label: const Text("Tambah Aset"),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Modern Asset Card
  Widget _buildAssetCard(AssetModel asset) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: () => controller.goToAssetDetail(asset),
          borderRadius: BorderRadius.circular(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Image Header
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    child: Container(
                      height: 180,
                      width: double.infinity,
                      color: AppColors.greyLight,
                      child: (asset.imageUrl != null && asset.imageUrl!.isNotEmpty)
                          ? Image.network(
                              asset.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (c, e, s) => const Center(child: Icon(Icons.image, color: Colors.grey)),
                            )
                          : const Center(child: FaIcon(FontAwesomeIcons.image, color: Colors.grey)),
                    ),
                  ),
                  // Gradient Overlay
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.3),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Status Badge
                  Positioned(
                    top: 16, right: 16,
                    child: _buildStatusBadge(asset.status),
                  ),
                  // Type Icon
                  Positioned(
                    bottom: 16, left: 16,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: FaIcon(
                        asset.assetType == 'PETERNAKAN' ? FontAwesomeIcons.cow : FontAwesomeIcons.leaf,
                        size: 16,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),

              // 2. Content Body
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      asset.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const FaIcon(FontAwesomeIcons.locationDot, size: 14, color: AppColors.textLight),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            asset.location,
                            style: const TextStyle(fontSize: 14, color: AppColors.textLight),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoItem("Luas/Jumlah", "2 Ha"), // Placeholder, ganti dengan data real jika ada
                        ),
                        Container(width: 1, height: 24, color: AppColors.greyLight),
                        Expanded(
                          child: _buildInfoItem("Estimasi Nilai", "Rp 500Jt"), // Placeholder
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textLight)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark)),
      ],
    );
  }

  /// Status Badge Helper
  Widget _buildStatusBadge(AssetStatus status) {
    Color color;
    String text;
    IconData icon;

    switch (status) {
      case AssetStatus.VERIFIED:
        color = Colors.green; text = "Terverifikasi"; icon = FontAwesomeIcons.check; break;
      case AssetStatus.REJECTED:
        color = Colors.red; text = "Ditolak"; icon = FontAwesomeIcons.xmark; break;
      default:
        color = Colors.orange; text = "Menunggu"; icon = FontAwesomeIcons.clock; break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(icon, size: 10, color: Colors.white),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
        ],
      ),
    );
  }

  /// Modern FAB
  Widget _buildFloatingActionButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: FloatingActionButton.extended(
        onPressed: controller.goToAddAsset,
        backgroundColor: AppColors.primary,
        elevation: 0,
        highlightElevation: 0,
        label: const Text(
          "Tambah Aset",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        icon: const FaIcon(FontAwesomeIcons.plus, size: 16),
      ),
    );
  }
}