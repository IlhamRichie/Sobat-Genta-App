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

  final rupiahFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: controller.fetchPublishedProjects,
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (controller.projectList.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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

  /// AppBar Kustom
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      title: Text(
        "Marketplace Proyek",
        style: Get.textTheme.headlineSmall?.copyWith(
          color: AppColors.textDark,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: false,
      actions: [
        IconButton(
          onPressed: () { /* TODO: Buka Halaman Filter */ },
          icon: const FaIcon(FontAwesomeIcons.filter, color: AppColors.iconSecondary),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FaIcon(FontAwesomeIcons.storeSlash, size: 96, color: AppColors.greyLight),
            const SizedBox(height: 32),
            Text(
              "Belum Ada Proyek Tersedia",
              style: Get.textTheme.titleLarge?.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              "Saat ini belum ada proposal proyek yang dipublikasikan. Silakan cek kembali nanti.",
              style: Get.textTheme.bodyMedium?.copyWith(
                fontSize: 16,
                color: AppColors.textLight,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Kartu untuk menampilkan satu proyek (Didesain Ulang)
  Widget _buildProjectCard(ProjectModel project) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: InkWell(
        onTap: () => controller.goToProjectDetail(project),
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: project.projectImageUrl != null && project.projectImageUrl!.isNotEmpty
                      ? Image.network(
                          project.projectImageUrl!,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 180,
                            color: AppColors.greyLight,
                            child: const Center(child: FaIcon(FontAwesomeIcons.image, color: Colors.grey)),
                          ),
                        )
                      : Container(
                          height: 180,
                          color: AppColors.greyLight,
                          child: const Center(child: FaIcon(FontAwesomeIcons.image, color: Colors.grey)),
                        ),
                ),
                Positioned(
                  top: 12, left: 12,
                  child: _buildProjectStatusBadge(project.status),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.title,
                    style: Get.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Aset: ${project.assetName}", // Menggunakan `assetName` yang sudah ada di model
                    style: Get.textTheme.bodySmall?.copyWith(color: AppColors.textLight, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Terkumpul: ${rupiahFormatter.format(project.collectedFund)}",
                    style: Get.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Target: ${rupiahFormatter.format(project.targetFund)}",
                    style: Get.textTheme.bodySmall?.copyWith(color: AppColors.textLight),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: project.fundingProgress,
                    backgroundColor: AppColors.greyLight,
                    color: AppColors.primary,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${(project.fundingProgress * 100).toStringAsFixed(0)}% Terkumpul",
                    style: Get.textTheme.bodySmall?.copyWith(color: AppColors.textLight),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Badge untuk status proyek (Didesain Ulang)
  Widget _buildProjectStatusBadge(ProjectStatus status) {
    Color color; String text; IconData icon;

    switch (status) {
      case ProjectStatus.PUBLISHED:
        color = AppColors.primary; text = "Galang Dana"; icon = FontAwesomeIcons.bullhorn; break;
      case ProjectStatus.FUNDED:
        color = Colors.green; text = "Didanai Penuh"; icon = FontAwesomeIcons.solidCircleCheck; break;
      case ProjectStatus.COMPLETED:
        color = AppColors.textDark; text = "Selesai"; icon = FontAwesomeIcons.flagCheckered; break;
      case ProjectStatus.REJECTED:
        color = Colors.red; text = "Ditolak"; icon = FontAwesomeIcons.solidCircleXmark; break;
      default:
        color = Colors.orange; text = "Menunggu Moderasi"; icon = FontAwesomeIcons.clock; break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(icon, size: 12, color: color),
          const SizedBox(width: 6),
          Text(text, style: Get.textTheme.bodySmall?.copyWith(color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}