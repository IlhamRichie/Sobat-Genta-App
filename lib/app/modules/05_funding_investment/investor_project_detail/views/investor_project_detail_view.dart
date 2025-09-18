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

  // Helper untuk format Rupiah
  final rupiahFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Tombol Aksi Bawah
      bottomNavigationBar: _buildInvestButtonSection(),
      
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.project.value == null) {
          return const Center(child: Text("Gagal memuat data proyek."));
        }
        
        final project = controller.project.value!;
        // Gunakan CustomScrollView untuk header gambar yang bisa 'stretch'
        return CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 250.0,
              floating: false,
              pinned: true,
              stretch: true,
              backgroundColor: AppColors.primary,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(project.title, style: TextStyle(fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis),
                background: Container(
                  color: AppColors.greyLight,
                  // TODO: Ganti dengan Image.network(project.projectImageUrl)
                  child: Center(child: FaIcon(FontAwesomeIcons.image, size: 80, color: Colors.grey.shade400)),
                ),
              ),
            ),
            
            // Konten Detail
            SliverList(
              delegate: SliverChildListDelegate([
                _buildFarmerProfileCard(project), // Kartu Profil Petani (Trust)
                _buildFundingProgressCard(project), // Kartu Progres Dana
                _buildProjectStatsCard(project), // Kartu ROI & Durasi
                _buildDescriptionCard(project), // Kartu Deskripsi
                _buildRabCard(project.rabItems), // Kartu RAB (Transparansi)
                const SizedBox(height: 24), // Spasi aman
              ]),
            ),
          ],
        );
      }),
    );
  }

  /// Tombol "Danai Sekarang" (Langkah I6)
  Widget _buildInvestButtonSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: Obx(() => FilledButton(
            onPressed: (controller.project.value?.status == ProjectStatus.PUBLISHED)
                ? controller.goToInvestForm
                : null, // Nonaktifkan jika sudah 'FUNDED'
            child: Text(
              (controller.project.value?.status == ProjectStatus.PUBLISHED)
                ? "Danai Sekarang"
                : "Pendanaan Ditutup"
            ),
          )),
    );
  }

  /// Kartu #1: Profil Petani (Trust Factor)
  Widget _buildFarmerProfileCard(ProjectModel project) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Card(
        elevation: 1,
        child: ListTile(
          leading: const CircleAvatar(
            backgroundColor: AppColors.greyLight,
            // TODO: Ganti dengan Image.network(project.farmerProfile.profilePictureUrl)
            child: FaIcon(FontAwesomeIcons.solidUser),
          ),
          title: Text(project.farmerProfile.fullName, style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text("Total ${project.farmerProfile.totalProjects} proyek diajukan"),
          trailing: const FaIcon(FontAwesomeIcons.chevronRight, size: 16),
          onTap: () { /* TODO: Navigasi ke profil publik petani */ },
        ),
      ),
    );
  }

  /// Kartu #2: Progres Pendanaan
  Widget _buildFundingProgressCard(ProjectModel project) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Card(
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                style: Get.textTheme.titleLarge?.copyWith(color: AppColors.primary, fontSize: 24),
              ),
              Text(
                "dari target ${rupiahFormatter.format(project.targetFund)}",
                style: Get.textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
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
      ),
    );
  }
  
  /// Kartu #3: Statistik Proyek
  Widget _buildProjectStatsCard(ProjectModel project) {
     return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: Card(elevation: 1, child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(children: [
                  Text("Estimasi ROI", style: Get.textTheme.bodyMedium),
                  SizedBox(height: 8),
                  Text("${project.roiPercentage}%", style: Get.textTheme.titleLarge?.copyWith(color: Colors.green.shade700)),
                ]),
              )),
            ),
            Expanded(
              child: Card(elevation: 1, child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(children: [
                  Text("Durasi Proyek", style: Get.textTheme.bodyMedium),
                  SizedBox(height: 8),
                  Text("${project.durationDays} Hari", style: Get.textTheme.titleLarge),
                ]),
              )),
            ),
          ],
        ),
      ),
    );
  }
  
  /// Kartu #4: Deskripsi
  Widget _buildDescriptionCard(ProjectModel project) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Card(
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Tentang Proyek Ini", style: Get.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const Divider(height: 24),
              Text(
                project.description,
                style: Get.textTheme.bodyMedium?.copyWith(fontSize: 15, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  /// Kartu #5: Rencana Anggaran Biaya (RAB)
  Widget _buildRabCard(List<RabItemModel> rabItems) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Card(
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Rencana Anggaran Biaya (RAB)", style: Get.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const Divider(height: 24),
              // Render list RAB
              ...rabItems.map((item) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    leading: const FaIcon(FontAwesomeIcons.check, size: 16, color: AppColors.primary),
                    title: Text(item.itemName),
                    trailing: Text(
                      rupiahFormatter.format(item.cost),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  )).toList(),
            ],
          ),
        ),
      ),
    );
  }
}