// lib/app/modules/farmer_my_projects_list/views/farmer_my_projects_list_view.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Kita butuh ini untuk format mata uang
import '../../../../data/models/project_model.dart';
import '../../../../theme/app_colors.dart';
import '../controllers/farmer_my_projects_list_controller.dart';

class FarmerMyProjectsListView extends GetView<FarmerMyProjectsListController> {
  FarmerMyProjectsListView({Key? key}) : super(key: key);

  // Helper untuk format Rupiah
  final rupiahFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Proyek Saya"),
      ),
      body: RefreshIndicator(
        onRefresh: controller.fetchMyProjects,
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
            FaIcon(FontAwesomeIcons.fileLines, size: 80, color: AppColors.greyLight),
            const SizedBox(height: 24),
            Text(
              "Anda Belum Memiliki Proposal Proyek",
              style: Get.textTheme.titleLarge?.copyWith(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "Ajukan pendanaan melalui halaman 'Aset Saya' yang sudah terverifikasi.",
              style: Get.textTheme.bodyMedium?.copyWith(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

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
                  // Status Badge
                  _buildProjectStatusBadge(project.status),
                  const SizedBox(height: 12),
                  // Judul Proyek
                  Text(
                    project.title,
                    style: Get.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, fontSize: 18),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Nama Aset
                  Text(
                    "Aset: ${project.assetName}",
                    style: Get.textTheme.bodySmall?.copyWith(color: AppColors.textLight, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 16),
                  // Info Pendanaan
                  Text(
                    "Terkumpul: ${rupiahFormatter.format(project.collectedFund)}",
                    style: Get.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                  Text(
                    "dari Target: ${rupiahFormatter.format(project.targetFund)}",
                    style: Get.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  // Progress Bar
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
        color = Colors.blue.shade700; text = "Dipublikasikan (Galang Dana)"; icon = FontAwesomeIcons.bullhorn; break;
      case ProjectStatus.FUNDED:
        color = Colors.green.shade700; text = "Didanai Penuh"; icon = FontAwesomeIcons.checkCircle; break;
      case ProjectStatus.COMPLETED:
        color = AppColors.textDark; text = "Selesai"; icon = FontAwesomeIcons.flagCheckered; break;
      case ProjectStatus.REJECTED:
        color = Colors.red.shade700; text = "Ditolak Admin"; icon = FontAwesomeIcons.xmarkCircle; break;
      case ProjectStatus.PENDING_ADMIN:
      default:
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