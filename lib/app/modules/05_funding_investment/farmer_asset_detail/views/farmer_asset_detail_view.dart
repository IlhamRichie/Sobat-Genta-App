// lib/app/modules/farmer_asset_detail/views/farmer_asset_detail_view.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../data/models/asset_model.dart';
import '../../../../theme/app_colors.dart';
import '../controllers/farmer_asset_detail_controller.dart';
import 'package:intl/intl.dart';

class FarmerAssetDetailView extends GetView<FarmerAssetDetailController> {
  const FarmerAssetDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      bottomNavigationBar: _buildFundingButtonSection(),
      
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.asset.value == null) {
          return const Center(child: Text("Gagal memuat data aset."));
        }
        
        final asset = controller.asset.value!;
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAssetHeader(asset),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    _buildSectionTitle("Informasi Aset"),
                    const SizedBox(height: 12),
                    _buildInfoCard(asset),
                    const SizedBox(height: 24),
                    _buildSectionTitle("Dokumen Pendukung"),
                    const SizedBox(height: 12),
                    _buildDocumentCard(asset),
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  /// AppBar Kustom (Ditingkatkan)
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      title: Obx(() => Text(
        controller.isLoading.value
            ? "Memuat..."
            : controller.asset.value?.name ?? "Detail Aset",
        style: Get.textTheme.headlineSmall?.copyWith(
          color: AppColors.textDark,
          fontWeight: FontWeight.bold,
        ),
      )),
      centerTitle: false,
    );
  }

  /// Bagian Header Gambar (Didesain Ulang)
  Widget _buildAssetHeader(AssetModel asset) {
    return Stack(
      children: [
        Container(
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.greyLight,
            image: asset.imageUrl != null && asset.imageUrl!.isNotEmpty
                ? DecorationImage(
                    image: NetworkImage(asset.imageUrl!),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: asset.imageUrl == null || asset.imageUrl!.isEmpty
              ? Center(child: FaIcon(FontAwesomeIcons.image, size: 80, color: Colors.grey.shade400))
              : null,
        ),
        Positioned(
          bottom: 24,
          left: 24,
          child: _buildStatusBadge(asset.status),
        ),
      ],
    );
  }

  /// Widget Kartu Informasi Aset (Baru)
  Widget _buildInfoCard(AssetModel asset) {
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow(FontAwesomeIcons.locationDot, "Lokasi", asset.location),
          _buildInfoRow(
            asset.assetType == 'PETERNAKAN' ? FontAwesomeIcons.cow : FontAwesomeIcons.leaf,
            "Tipe Aset",
            asset.assetType.capitalizeFirst!,
          ),
          _buildInfoRow(FontAwesomeIcons.rulerCombined, "Luas Aset", asset.areaSize),
          
          if (asset.assetType == 'PETERNAKAN')
            _buildInfoRow(FontAwesomeIcons.hippo, "Jenis Ternak", asset.assetDetails!),
          if (asset.assetType == 'PERTANIAN')
            _buildInfoRow(FontAwesomeIcons.seedling, "Jenis Tanaman", asset.assetDetails!),
        ],
      ),
    );
  }

  /// Widget Kartu Dokumen (Baru)
  Widget _buildDocumentCard(AssetModel asset) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildDocumentRow("Foto Aset", asset.imageUrl),
          _buildDocumentRow("Sertifikat/Garapan", asset.certificateImageUrl),
        ],
      ),
    );
  }

  /// Widget Baris Info
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                Text(
                  value,
                  style: Get.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  /// Widget Baris Dokumen
  Widget _buildDocumentRow(String label, String? imageUrl) {
    return InkWell(
      onTap: () {
        if (imageUrl != null && imageUrl.isNotEmpty) {
          // TODO: Implement image preview logic
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.greyLight,
                borderRadius: BorderRadius.circular(8),
                image: imageUrl != null && imageUrl.isNotEmpty
                    ? DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover)
                    : null,
              ),
              child: imageUrl == null || imageUrl.isEmpty
                  ? const Center(child: FaIcon(FontAwesomeIcons.fileLines, color: Colors.grey))
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
            const SizedBox(width: 8),
            FaIcon(
              imageUrl != null && imageUrl.isNotEmpty ? FontAwesomeIcons.eye : FontAwesomeIcons.exclamationCircle,
              color: imageUrl != null && imageUrl.isNotEmpty ? AppColors.primary : Colors.red,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  /// Badge Status (Sama seperti di halaman list)
  Widget _buildStatusBadge(AssetStatus status) {
    Color color; String text; IconData icon;
    switch (status) {
      case AssetStatus.VERIFIED: color = Colors.green; text = "Terverifikasi"; icon = FontAwesomeIcons.checkCircle; break;
      case AssetStatus.REJECTED: color = Colors.red; text = "Ditolak"; icon = FontAwesomeIcons.timesCircle; break;
      default: color = Colors.orange; text = "Menunggu Verifikasi"; icon = FontAwesomeIcons.clock; break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(icon, size: 14, color: color),
          const SizedBox(width: 8),
          Text(
            text,
            style: Get.textTheme.bodySmall?.copyWith(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
  
  /// Judul Section (Baru)
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Get.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: AppColors.textDark,
      ),
    );
  }

  /// BAGIAN KRITIS: Tombol Aksi di Bawah (Didesain Ulang)
  Widget _buildFundingButtonSection() {
    return Obx(() {
      final isEnabled = controller.isFundingButtonEnabled.value;
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildStatusInfoBox(
              controller.asset.value?.status,
              controller.fundingButtonMessage.value,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: isEnabled ? controller.goToApplyFunding : null,
              style: FilledButton.styleFrom(
                backgroundColor: isEnabled ? AppColors.primary : Colors.grey,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: isEnabled ? 4 : 0,
              ),
              child: const Text(
                "Ajukan Pendanaan",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
    });
  }
  
  /// Info box yang menjelaskan status tombol (Didesain Ulang)
  Widget _buildStatusInfoBox(AssetStatus? status, String message) {
    if (status == null) return const SizedBox.shrink();
    
    IconData icon; Color color;
    switch (status) {
      case AssetStatus.VERIFIED: icon = FontAwesomeIcons.checkCircle; color = Colors.green; break;
      case AssetStatus.PENDING: icon = FontAwesomeIcons.clock; color = Colors.orange; break;
      case AssetStatus.REJECTED: icon = FontAwesomeIcons.timesCircle; color = Colors.red; break;
      default: return const SizedBox.shrink();
    }
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FaIcon(icon, size: 24, color: color),
          const SizedBox(width: 16),
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