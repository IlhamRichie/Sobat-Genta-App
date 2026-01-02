// lib/app/modules/investor_project_detail/views/investor_project_detail_view.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../data/models/project_model.dart';
import '../../../../data/models/rab_item_model.dart';
import '../../../../theme/app_colors.dart';
import '../controllers/investor_project_detail_controller.dart';

class InvestorProjectDetailView extends GetView<InvestorProjectDetailController> {
  InvestorProjectDetailView({Key? key}) : super(key: key);

  final rupiahFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.project.value == null) {
          return const Center(child: Text("Gagal memuat data proyek."));
        }
        
        final project = controller.project.value!;
        return Stack(
          children: [
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildSliverAppBar(project),
                
                SliverList(
                  delegate: SliverChildListDelegate([
                    _buildFarmerProfileCard(project),
                    const SizedBox(height: 16),
                    _buildFundingProgressCard(project),
                    const SizedBox(height: 16),
                    _buildProjectStatsCard(project),
                    const SizedBox(height: 16),
                    _buildDescriptionCard(project),
                    const SizedBox(height: 16),
                    _buildRabCard(project.rabItems),
                    const SizedBox(height: 120), // Bottom padding untuk tombol floating
                  ]),
                ),
              ],
            ),
            
            // Bottom Action Bar
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: _buildInvestButtonSection(),
            ),
          ],
        );
      }),
    );
  }

  /// SliverAppBar (Immersive Header)
  Widget _buildSliverAppBar(ProjectModel project) {
    return SliverAppBar(
      expandedHeight: 320.0,
      pinned: true,
      backgroundColor: AppColors.primary,
      elevation: 0,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: () { /* TODO: Share */ },
            icon: const Icon(Icons.share_rounded, color: Colors.black, size: 20),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image
            project.projectImageUrl != null && project.projectImageUrl!.isNotEmpty
                ? Image.network(
                    project.projectImageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => Container(color: AppColors.greyLight),
                  )
                : Container(color: AppColors.greyLight),
            
            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.2),
                    Colors.transparent,
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
            ),

            // Content on Image
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatusBadge(project.status),
                  const SizedBox(height: 12),
                  Text(
                    project.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(color: Colors.black45, blurRadius: 10)],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.white70, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        project.assetName,
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                      ),
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

  /// Status Badge
  Widget _buildStatusBadge(ProjectStatus status) {
    Color color; String text;
    switch (status) {
      case ProjectStatus.PUBLISHED: color = AppColors.primary; text = "Galang Dana"; break;
      case ProjectStatus.FUNDED: color = Colors.blue; text = "Didanai"; break;
      case ProjectStatus.COMPLETED: color = Colors.green; text = "Selesai"; break;
      default: color = Colors.orange; text = "Proses"; break;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }

  /// 1. Profil Petani
  Widget _buildFarmerProfileCard(ProjectModel project) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.greyLight,
            backgroundImage: (project.farmerProfile.profilePictureUrl != null)
                ? NetworkImage(project.farmerProfile.profilePictureUrl!)
                : null,
            child: (project.farmerProfile.profilePictureUrl == null)
                ? const Icon(Icons.person, color: Colors.grey)
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Pemilik Proyek", style: TextStyle(color: AppColors.textLight, fontSize: 12)),
                const SizedBox(height: 2),
                Text(
                  project.farmerProfile.fullName,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDark),
                ),
                Text(
                  "${project.farmerProfile.totalProjects} Proyek Sebelumnya",
                  style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () {}, 
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              side: const BorderSide(color: AppColors.greyLight),
            ),
            child: const Text("Lihat", style: TextStyle(color: AppColors.textDark)),
          ),
        ],
      ),
    );
  }

  /// 2. Progress Pendanaan
  Widget _buildFundingProgressCard(ProjectModel project) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Dana Terkumpul", style: TextStyle(color: AppColors.textLight, fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(
                    rupiahFormatter.format(project.collectedFund),
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: AppColors.primary),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text("Target", style: TextStyle(color: AppColors.textLight, fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(
                    rupiahFormatter.format(project.targetFund),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDark),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: project.fundingProgress,
            minHeight: 12,
            backgroundColor: AppColors.greyLight,
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(6),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "${(project.fundingProgress * 100).toStringAsFixed(0)}% Terpenuhi",
              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  /// 3. Statistik Proyek
  Widget _buildProjectStatsCard(ProjectModel project) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              "Estimasi ROI", 
              "${project.roiEstimate}%", 
              FontAwesomeIcons.arrowTrendUp,
              Colors.green
            ),
          ),
          Container(width: 1, height: 40, color: AppColors.greyLight),
          Expanded(
            child: _buildStatItem(
              "Durasi", 
              "${project.durationDays} Hari", 
              FontAwesomeIcons.clock,
              Colors.orange
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        FaIcon(icon, size: 20, color: color),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDark)),
      ],
    );
  }

  /// 4. Deskripsi
  Widget _buildDescriptionCard(ProjectModel project) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Tentang Proyek", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textDark)),
          const SizedBox(height: 12),
          Text(
            project.description,
            style: const TextStyle(color: AppColors.textLight, height: 1.6, fontSize: 14),
          ),
        ],
      ),
    );
  }

  /// 5. RAB List
  Widget _buildRabCard(List<RabItemModel> rabItems) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Rincian Anggaran (RAB)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textDark)),
          const SizedBox(height: 16),
          ...rabItems.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.check_circle_outline, size: 16, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(item.itemName, style: const TextStyle(color: AppColors.textDark, fontSize: 14)),
                  ],
                ),
                Text(rupiahFormatter.format(item.cost), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  /// Sticky Bottom Button
  Widget _buildInvestButtonSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5)),
        ],
      ),
      child: Obx(() {
        final project = controller.project.value;
        bool isPublished = project?.status == ProjectStatus.PUBLISHED;
        
        return SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: isPublished ? controller.goToInvestForm : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              disabledBackgroundColor: AppColors.greyLight,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: isPublished ? 4 : 0,
            ),
            child: Text(
              isPublished ? "Danai Sekarang" : "Pendanaan Ditutup",
              style: TextStyle(
                fontWeight: FontWeight.bold, 
                fontSize: 16,
                color: isPublished ? Colors.white : AppColors.textLight,
              ),
            ),
          ),
        );
      }),
    );
  }
}