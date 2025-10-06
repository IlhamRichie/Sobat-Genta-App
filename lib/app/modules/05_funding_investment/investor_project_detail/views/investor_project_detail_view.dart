// lib/app/modules/investor_project_detail/views/investor_project_detail_view.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../data/models/project_model.dart';
import '../../../../data/models/rab_item_model.dart';
import '../../../../theme/app_colors.dart';
import '../../../../routes/app_pages.dart';
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
        return CustomScrollView(
          slivers: [
            _buildSliverAppBar(project),
            
            SliverList(
              delegate: SliverChildListDelegate([
                _buildFarmerProfileCard(project),
                const SizedBox(height: 24),
                _buildFundingProgressCard(project),
                const SizedBox(height: 24),
                _buildProjectStatsCard(project),
                const SizedBox(height: 24),
                _buildDescriptionCard(project),
                const SizedBox(height: 24),
                _buildRabCard(project.rabItems),
                const SizedBox(height: 24),
              ]),
            ),
          ],
        );
      }),
      bottomNavigationBar: _buildInvestButtonSection(),
    );
  }

  /// SliverAppBar Kustom (Didesain Ulang)
  Widget _buildSliverAppBar(ProjectModel project) {
    return SliverAppBar(
      expandedHeight: 300.0,
      pinned: true,
      backgroundColor: AppColors.primary,
      leading: BackButton(onPressed: () => Get.back(), color: Colors.white),
      actions: [
        IconButton(
          onPressed: () { /* TODO: Share */ },
          icon: const FaIcon(FontAwesomeIcons.shareNodes, color: Colors.white),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          project.title,
          style: Get.textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: false,
        titlePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        background: Stack(
          children: [
            project.projectImageUrl != null && project.projectImageUrl!.isNotEmpty
                ? Image.network(
                    project.projectImageUrl!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppColors.greyLight,
                      child: const Center(child: FaIcon(FontAwesomeIcons.image, size: 80, color: Colors.grey)),
                    ),
                  )
                : Container(
                    color: AppColors.greyLight,
                    child: const Center(child: FaIcon(FontAwesomeIcons.image, size: 80, color: Colors.grey)),
                  ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            Positioned(
              top: 80, left: 24,
              child: _buildProjectStatusBadge(project.status),
            ),
          ],
        ),
      ),
    );
  }

  /// Tombol "Danai Sekarang" (Langkah I6)
  Widget _buildInvestButtonSection() {
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
      child: Obx(() => FilledButton(
        onPressed: (controller.project.value?.status == ProjectStatus.PUBLISHED)
            ? controller.goToInvestForm
            : null,
        style: FilledButton.styleFrom(
          backgroundColor: (controller.project.value?.status == ProjectStatus.PUBLISHED) ? AppColors.primary : AppColors.greyLight,
          foregroundColor: (controller.project.value?.status == ProjectStatus.PUBLISHED) ? Colors.white : AppColors.textLight,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: (controller.project.value?.status == ProjectStatus.PUBLISHED) ? 4 : 0,
        ),
        child: Text(
          (controller.project.value?.status == ProjectStatus.PUBLISHED)
              ? "Danai Sekarang"
              : "Pendanaan Ditutup",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      )),
    );
  }

  /// Widget yang direfaktor dari `_buildProjectStatusBadge`
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

  /// Kartu #1: Profil Petani (Didesain Ulang)
  Widget _buildFarmerProfileCard(ProjectModel project) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
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
          onTap: () { /* TODO: Navigasi ke profil publik petani */ },
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: AppColors.greyLight,
                backgroundImage: project.farmerProfile?.profilePictureUrl != null && project.farmerProfile!.profilePictureUrl!.isNotEmpty
                    ? NetworkImage(project.farmerProfile!.profilePictureUrl!)
                    : null,
                child: project.farmerProfile?.profilePictureUrl == null || project.farmerProfile!.profilePictureUrl!.isEmpty
                    ? const FaIcon(FontAwesomeIcons.solidUser, size: 30, color: Colors.grey)
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.farmerProfile?.fullName ?? "Petani",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      "Total ${project.farmerProfile?.totalProjects ?? 0} proyek diajukan",
                      style: Get.textTheme.bodyMedium?.copyWith(color: AppColors.textLight),
                    ),
                  ],
                ),
              ),
              const FaIcon(FontAwesomeIcons.chevronRight, size: 16, color: AppColors.textLight),
            ],
          ),
        ),
      ),
    );
  }

  /// Kartu #2: Progres Pendanaan (Didesain Ulang)
  Widget _buildFundingProgressCard(ProjectModel project) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
      child: Container(
        padding: const EdgeInsets.all(24),
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
            Text(
              "Dana Terkumpul",
              style: Get.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              rupiahFormatter.format(project.collectedFund),
              style: Get.textTheme.headlineSmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              "dari target ${rupiahFormatter.format(project.targetFund)}",
              style: Get.textTheme.bodyMedium?.copyWith(color: AppColors.textLight),
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: project.fundingProgress,
              backgroundColor: AppColors.greyLight,
              color: AppColors.primary,
              minHeight: 10,
              borderRadius: BorderRadius.circular(5),
            ),
          ],
        ),
      ),
    );
  }

  /// Kartu #3: Statistik Proyek (Didesain Ulang)
  Widget _buildProjectStatsCard(ProjectModel project) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16.0),
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
                    Text(
                      "Estimasi ROI",
                      style: Get.textTheme.bodyMedium?.copyWith(color: AppColors.textLight),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${project.roiPercentage.toStringAsFixed(0)}%",
                      style: Get.textTheme.headlineSmall?.copyWith(color: Colors.green.shade700, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16.0),
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
                    Text(
                      "Durasi Proyek",
                      style: Get.textTheme.bodyMedium?.copyWith(color: AppColors.textLight),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${project.durationDays} Hari",
                      style: Get.textTheme.headlineSmall?.copyWith(color: AppColors.textDark, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// Kartu #4: Deskripsi (Didesain Ulang)
  Widget _buildDescriptionCard(ProjectModel project) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
      child: Container(
        padding: const EdgeInsets.all(24.0),
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
            Text("Tentang Proyek Ini", style: Get.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(
              project.description,
              style: Get.textTheme.bodyMedium?.copyWith(fontSize: 16, height: 1.5, color: AppColors.textDark),
            ),
          ],
        ),
      ),
    );
  }
  
  /// Kartu #5: Rencana Anggaran Biaya (RAB) (Didesain Ulang)
  Widget _buildRabCard(List<RabItemModel> rabItems) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
      child: Container(
        padding: const EdgeInsets.all(24.0),
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
            Text("Rencana Anggaran Biaya (RAB)", style: Get.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ...rabItems.map((item) => _buildRabItem(item)).toList(),
          ],
        ),
      ),
    );
  }
  
  /// Helper untuk satu baris item RAB
  Widget _buildRabItem(RabItemModel item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const FaIcon(FontAwesomeIcons.check, size: 16, color: AppColors.primary),
              const SizedBox(width: 12),
              Text(item.itemName, style: Get.textTheme.bodyMedium),
            ],
          ),
          Text(
            rupiahFormatter.format(item.cost),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}