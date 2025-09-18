// lib/app/modules/farmer_asset_detail/views/farmer_asset_detail_view.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../data/models/asset_model.dart';
import '../../../../theme/app_colors.dart';
import '../controllers/farmer_asset_detail_controller.dart';

class FarmerAssetDetailView extends GetView<FarmerAssetDetailController> {
  const FarmerAssetDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Kita gunakan Obx untuk menampilkan judul AppBar secara dinamis
      appBar: AppBar(
        title: Obx(() => Text(
          controller.isLoading.value
              ? "Memuat..."
              : controller.asset.value?.name ?? "Detail Aset",
        )),
      ),
      // Tombol Aksi di Bawah (Flowchart P6)
      bottomNavigationBar: _buildFundingButtonSection(),
      
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.asset.value == null) {
          return const Center(child: Text("Gagal memuat data aset."));
        }
        
        // Data tersedia, tampilkan detail
        final asset = controller.asset.value!;
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAssetHeader(asset),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatusBadge(asset.status),
                    const SizedBox(height: 16),
                    Text(asset.name, style: Get.textTheme.titleLarge?.copyWith(fontSize: 24)),
                    const SizedBox(height: 16),
                    _buildInfoRow(FontAwesomeIcons.locationDot, "Lokasi", asset.location),
                    _buildInfoRow(FontAwesomeIcons.rulerCombined, "Luas Aset", asset.areaSize),
                    _buildInfoRow(
                      asset.assetType == 'PETERNAKAN' ? FontAwesomeIcons.cow : FontAwesomeIcons.leaf,
                      "Tipe Aset",
                      asset.assetType.capitalizeFirst!,
                    ),
                    _buildInfoRow(FontAwesomeIcons.tag, "Detail Aset", asset.assetDetails),
                    const Divider(height: 32),
                    Text("Dokumen Pendukung", style: Get.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    // TODO: Ganti dengan widget gambar
                    _buildDocumentRow("Foto Lahan/Aset", asset.imageUrl),
                    _buildDocumentRow("Foto Sertifikat/Garapan", asset.certificateImageUrl),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  /// Bagian Header Gambar
  Widget _buildAssetHeader(AssetModel asset) {
    return Container(
      height: 220,
      width: double.infinity,
      color: AppColors.greyLight,
      // TODO: Ganti dengan Image.network(asset.imageUrl)
      child: Center(child: FaIcon(FontAwesomeIcons.image, size: 80, color: Colors.grey.shade400)),
    );
  }

  /// Baris Info (Lokasi, Luas, dll)
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FaIcon(icon, size: 16, color: AppColors.textLight),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Get.textTheme.bodySmall?.copyWith(color: AppColors.textLight)),
                const SizedBox(height: 2),
                Text(value, style: Get.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  /// Baris Dokumen (Placeholder)
  Widget _buildDocumentRow(String label, String? imageUrl) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade300)
      ),
      child: ListTile(
        leading: const FaIcon(FontAwesomeIcons.solidFileLines, color: AppColors.primary),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: const FaIcon(FontAwesomeIcons.eye, color: AppColors.textLight),
        onTap: () { /* TODO: Buka preview gambar */ },
      ),
    );
  }

  /// Badge Status (Sama seperti di halaman list)
  Widget _buildStatusBadge(AssetStatus status) {
    // (Bisa copy-paste _buildStatusBadge dari FarmerManageAssetsView)
    Color color; String text; IconData icon;
    switch (status) {
      case AssetStatus.VERIFIED: color = Colors.green.shade700; text = "Terverifikasi"; icon = FontAwesomeIcons.check; break;
      case AssetStatus.REJECTED: color = Colors.red.shade700; text = "Ditolak"; icon = FontAwesomeIcons.xmark; break;
      default: color = Colors.orange.shade700; text = "Menunggu Verifikasi"; icon = FontAwesomeIcons.clock; break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        FaIcon(icon, size: 12, color: color), const SizedBox(width: 6),
        Text(text, style: Get.textTheme.bodySmall?.copyWith(color: color, fontWeight: FontWeight.w700)),
      ],),
    );
  }

  /// BAGIAN KRITIS: Tombol Aksi di Bawah
  Widget _buildFundingButtonSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Info Box Dinamis
          Obx(() => _buildStatusInfoBox(
                controller.asset.value?.status,
                controller.fundingButtonMessage.value,
              )),
          const SizedBox(height: 12),
          // Tombol Dinamis
          Obx(() => FilledButton(
                onPressed: controller.isFundingButtonEnabled.value
                    ? controller.goToApplyFunding
                    : null, // Tombol non-aktif jika false
                child: const Text("Ajukan Pendanaan"),
              )),
        ],
      ),
    );
  }

  /// Info box yang menjelaskan status tombol
  Widget _buildStatusInfoBox(AssetStatus? status, String message) {
    if (status == null) return const SizedBox.shrink();
    
    IconData icon; Color color;
    switch (status) {
      case AssetStatus.VERIFIED: icon = FontAwesomeIcons.checkCircle; color = Colors.green.shade700; break;
      case AssetStatus.PENDING: icon = FontAwesomeIcons.clock; color = Colors.orange.shade700; break;
      case AssetStatus.REJECTED: icon = FontAwesomeIcons.timesCircle; color = Colors.red.shade700; break;
      default: return const SizedBox.shrink();
    }
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          FaIcon(icon, size: 20, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: Get.textTheme.bodyMedium?.copyWith(color: AppColors.textDark, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}