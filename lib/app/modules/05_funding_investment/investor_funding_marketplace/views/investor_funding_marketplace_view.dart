// lib/app/modules/investor_funding_marketplace/views/investor_funding_marketplace_view.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../data/models/project_model.dart';
import '../../../../theme/app_colors.dart';
import '../controllers/investor_funding_marketplace_controller.dart';

class InvestorFundingMarketplaceView
    extends GetView<InvestorFundingMarketplaceController> {
  InvestorFundingMarketplaceView({Key? key}) : super(key: key);

  // Helper untuk format Rupiah
  final rupiahFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Marketplace Proyek"),
        actions: [
          IconButton(
            onPressed: () { /* TODO: Buka Halaman Filter */ },
            icon: const FaIcon(FontAwesomeIcons.filter),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: controller.fetchPublishedProjects,
        child: Obx(() {
          // 1. Loading State
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          
          // 2. Empty State
          if (controller.projectList.isEmpty) {
            return _buildEmptyState();
          }

          // 3. Data State
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.projectList.length,
            itemBuilder: (context, index) {
              final project = controller.projectList[index];
              // Kita gunakan widget kartu yang SAMA PERSIS
              // dengan di halaman Petani
              return _buildProjectCard(project);
            },
          );
        }),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(FontAwesomeIcons.storeSlash, size: 80, color: AppColors.greyLight),
            const SizedBox(height: 24),
            Text(
              "Belum Ada Proyek Tersedia",
              style: Get.textTheme.titleLarge?.copyWith(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "Saat ini belum ada proposal proyek yang dipublikasikan. Silakan cek kembali nanti.",
              style: Get.textTheme.bodyMedium?.copyWith(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET REUSABLE ---
  // ARSITEKTUR: Ini adalah duplikasi dari FarmerMyProjectsListView
  // Idealnya, ini di-refactor menjadi satu file widget 'ProjectCard.dart'
  // Tapi untuk kecepatan sprint, kita copy-paste.

  /// Kartu untuk menampilkan satu proyek
  Widget _buildProjectCard(ProjectModel project) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => controller.goToProjectDetail(project),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Placeholder Gambar Proyek
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: AppColors.greyLight,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Center(child: FaIcon(FontAwesomeIcons.image, color: Colors.grey.shade400)),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProjectStatusBadge(project.status),
                  const SizedBox(height: 12),
                  Text(
                    project.title,
                    style: Get.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, fontSize: 18),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Petani tidak perlu lihat nama aset,
                  // tapi investor mungkin perlu. Kita biarkan.
                  Text(
                    "Aset: ${project.assetName}",
                    style: Get.textTheme.bodySmall?.copyWith(color: AppColors.textLight, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Terkumpul: ${rupiahFormatter.format(project.collectedFund)}",
                    style: Get.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                  Text(
                    "dari Target: ${rupiahFormatter.format(project.targetFund)}",
                    style: Get.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: project.fundingProgress,
                    backgroundColor: AppColors.greyLight,
                    color: AppColors.primary,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Badge untuk status proyek
  Widget _buildProjectStatusBadge(ProjectStatus status) {
    Color color; String text; IconData icon;

    switch (status) {
      case ProjectStatus.PUBLISHED:
        color = Colors.blue.shade700; text = "Galang Dana"; icon = FontAwesomeIcons.bullhorn; break;
      case ProjectStatus.FUNDED:
        color = Colors.green.shade700; text = "Didanai Penuh"; icon = FontAwesomeIcons.checkCircle; break;
      case ProjectStatus.COMPLETED:
        color = AppColors.textDark; text = "Selesai"; icon = FontAwesomeIcons.flagCheckered; break;
      case ProjectStatus.REJECTED:
        color = Colors.red.shade700; text = "Ditolak"; icon = FontAwesomeIcons.xmarkCircle; break;
      case ProjectStatus.PENDING_ADMIN:
      default:
        // Ini seharusnya tidak tampil di marketplace, tapi kita siapkan
        color = Colors.orange.shade700; text = "Menunggu Moderasi"; icon = FontAwesomeIcons.clock; break;
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
}