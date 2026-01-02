// lib/app/modules/investor_funding_marketplace/views/investor_funding_marketplace_view.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../data/models/project_model.dart';
import '../../../../theme/app_colors.dart';
import '../controllers/investor_funding_marketplace_controller.dart';

class InvestorFundingMarketplaceView extends GetView<InvestorFundingMarketplaceController> {
  InvestorFundingMarketplaceView({Key? key}) : super(key: key);

  final rupiahFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // 1. BACKGROUND DECORATION
          Positioned(
            top: -100,
            left: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.05), // Nuansa biru untuk investasi/bisnis
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 150,
            right: -80,
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
                    onRefresh: controller.fetchPublishedProjects,
                    color: AppColors.primary,
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      
                      if (controller.projectList.isEmpty) {
                        return _buildEmptyState();
                      }

                      return ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        itemCount: controller.projectList.length,
                        separatorBuilder: (ctx, i) => const SizedBox(height: 20),
                        itemBuilder: (context, index) {
                          final project = controller.projectList[index];
                          return _buildProjectCard(project);
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
                "Marketplace Investasi",
                style: Get.textTheme.headlineSmall?.copyWith(
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w800,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Temukan proyek potensial",
                style: Get.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textLight,
                  fontSize: 14,
                ),
              ),
            ],
          ),
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
              onPressed: () { /* TODO: Filter */ },
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
      child: SingleChildScrollView( // Agar bisa di-scroll to refresh
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
              child: const FaIcon(FontAwesomeIcons.magnifyingGlassChart, size: 64, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Text(
              "Belum Ada Proyek",
              style: Get.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Saat ini belum ada proyek yang dibuka untuk pendanaan.\nSilakan cek kembali nanti.",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textLight),
            ),
          ],
        ),
      ),
    );
  }

  /// Modern Project Card
  Widget _buildProjectCard(ProjectModel project) {
    // Hitung persentase untuk progress bar
    double progress = project.fundingProgress;
    if (progress > 1.0) progress = 1.0;
    if (progress < 0.0) progress = 0.0;

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
          onTap: () => controller.goToProjectDetail(project),
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
                      child: (project.projectImageUrl != null && project.projectImageUrl!.isNotEmpty)
                          ? Image.network(
                              project.projectImageUrl!,
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
                            Colors.black.withOpacity(0.4),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Status Badge
                  Positioned(
                    top: 16, left: 16,
                    child: _buildStatusBadge(project.status),
                  ),
                  // ROI Badge (Bottom Right Image)
                  Positioned(
                    bottom: 16, right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const FaIcon(FontAwesomeIcons.arrowTrendUp, size: 12, color: Colors.green),
                          const SizedBox(width: 6),
                          Text(
                            "${project.roiEstimate}% ROI", // Pastikan ada field roiEstimate di model, atau hitung manual
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Colors.green,
                            ),
                          ),
                        ],
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
                      project.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const FaIcon(FontAwesomeIcons.locationDot, size: 12, color: AppColors.textLight),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            "Lokasi: ${project.assetName}", // Mengasumsikan assetName berisi info lokasi/lahan
                            style: const TextStyle(fontSize: 12, color: AppColors.textLight),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Funding Progress
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Terkumpul", style: TextStyle(fontSize: 11, color: AppColors.textLight)),
                            const SizedBox(height: 2),
                            Text(
                              rupiahFormatter.format(project.collectedFund),
                              style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.primary, fontSize: 14),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text("Target", style: TextStyle(fontSize: 11, color: AppColors.textLight)),
                            const SizedBox(height: 2),
                            Text(
                              rupiahFormatter.format(project.targetFund),
                              style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textDark, fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: AppColors.greyLight,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "${(progress * 100).toStringAsFixed(0)}% Terpenuhi",
                        style: const TextStyle(fontSize: 11, color: AppColors.textLight, fontWeight: FontWeight.w600),
                      ),
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

  /// Status Badge Helper
  Widget _buildStatusBadge(ProjectStatus status) {
    Color color;
    String text;
    
    switch (status) {
      case ProjectStatus.PUBLISHED:
        color = AppColors.primary; text = "Galang Dana"; break;
      case ProjectStatus.FUNDED:
        color = Colors.blue; text = "Didanai"; break;
      case ProjectStatus.COMPLETED:
        color = Colors.grey; text = "Selesai"; break;
      default:
        color = Colors.orange; text = "Proses"; break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }
}