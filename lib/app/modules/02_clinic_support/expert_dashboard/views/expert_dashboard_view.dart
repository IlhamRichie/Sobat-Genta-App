// lib/app/modules/expert_dashboard/views/expert_dashboard_view.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../routes/app_pages.dart';
import '../../../../theme/app_colors.dart';
import '../controllers/expert_dashboard_controller.dart';

class ExpertDashboardView extends GetView<ExpertDashboardController> {
  ExpertDashboardView({Key? key}) : super(key: key);
  
  final rupiahFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        return RefreshIndicator(
          onRefresh: controller.fetchDashboardData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              children: [
                _buildWelcomeHeader(),
                const SizedBox(height: 24),
                _buildSummaryCards(),
                const SizedBox(height: 24),
                _buildConsultationQueue(),
              ],
            ),
          ),
        );
      }),
    );
  }

  /// AppBar Kustom
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      title: Text(
        "Dashboard",
        style: Get.textTheme.headlineSmall?.copyWith(
          color: AppColors.textDark,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: false,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Obx(() => Row(
            children: [
              Text(
                controller.isAvailable.value ? "Online" : "Offline",
                style: Get.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: controller.isAvailable.value ? Colors.green.shade700 : AppColors.textLight,
                ),
              ),
              if (controller.isToggleLoading.value)
                const Padding(
                  padding: EdgeInsets.all(14.0),
                  child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                )
              else
                Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    value: controller.isAvailable.value,
                    onChanged: controller.toggleAvailability,
                    activeColor: Colors.green,
                  ),
                ),
            ],
          )),
        )
      ],
    );
  }

  /// Header Selamat Datang (Didesain Ulang)
  Widget _buildWelcomeHeader() {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: AppColors.greyLight,
          backgroundImage: controller.profile.value?.user.profilePictureUrl != null && controller.profile.value!.user.profilePictureUrl!.isNotEmpty
              ? NetworkImage(controller.profile.value!.user.profilePictureUrl!)
              : null,
          child: controller.profile.value?.user.profilePictureUrl == null || controller.profile.value!.user.profilePictureUrl!.isEmpty
              ? const FaIcon(FontAwesomeIcons.userDoctor, size: 50, color: Colors.grey)
              : null,
        ),
        const SizedBox(height: 16),
        Text(
          "Selamat Datang,",
          style: Get.textTheme.bodyLarge?.copyWith(color: AppColors.textLight),
        ),
        Text(
          controller.profile.value?.user.fullName ?? "Pakar Genta",
          style: Get.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          controller.profile.value?.specialization ?? "Spesialisasi",
          style: Get.textTheme.titleMedium?.copyWith(color: AppColors.primary),
        ),
      ],
    );
  }

  /// Kartu Ringkasan (Penghasilan & Antrian) (Didesain Ulang)
  Widget _buildSummaryCards() {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
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
              child: Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Total Penghasilan", style: Get.textTheme.bodyMedium?.copyWith(color: AppColors.textLight)),
                  const SizedBox(height: 8),
                  Text(
                    rupiahFormatter.format(controller.currentEarnings.value),
                    style: Get.textTheme.titleLarge?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: () { Get.toNamed(Routes.EXPERT_PAYOUT); },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    child: const Text("Tarik Dana"),
                  ),
                ],
              )),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
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
              child: Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Antrian Konsultasi", style: Get.textTheme.bodyMedium?.copyWith(color: AppColors.textLight)),
                  const SizedBox(height: 8),
                  Text(
                    "${controller.pendingConsultations.value} Sesi",
                    style: Get.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: () { /* TODO: Go to Consultation List */ },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textDark,
                      side: const BorderSide(color: AppColors.greyLight),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    child: const Text("Lihat Antrian"),
                  ),
                ],
              )),
            ),
          ),
        ],
      ),
    );
  }

  /// Placeholder untuk daftar antrian (Didesain Ulang)
  Widget _buildConsultationQueue() {
    return Container(
      width: double.infinity,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Antrian Anda (1)", style: Get.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          // Ini adalah data mock UI
          _buildQueueItem(
            name: "Budi (Petani)",
            status: "Menunggu konfirmasi Anda...",
            onTap: () { /* TODO: Go to Chat Room */ },
          ),
        ],
      ),
    );
  }

  /// Helper untuk satu item antrian
  Widget _buildQueueItem({
    required String name,
    required String status,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            const CircleAvatar(
              backgroundColor: AppColors.greyLight,
              child: FaIcon(FontAwesomeIcons.solidUser, color: Colors.grey),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(status, style: Get.textTheme.bodySmall?.copyWith(color: AppColors.textLight)),
                ],
              ),
            ),
            FilledButton(
              onPressed: onTap,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text("Mulai"),
            ),
          ],
        ),
      ),
    );
  }
}