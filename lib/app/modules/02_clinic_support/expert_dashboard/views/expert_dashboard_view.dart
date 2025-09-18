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
      appBar: AppBar(
        title: const Text("Dashboard Pakar"),
        actions: [
          // --- FITUR KUNCI: TOGGLE ONLINE/OFFLINE ---
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Obx(() => Row(
              children: [
                Text(
                  controller.isAvailable.value ? "ONLINE" : "OFFLINE",
                  style: Get.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: controller.isAvailable.value ? Colors.green.shade700 : AppColors.textLight,
                  ),
                ),
                // Tampilkan loading kecil jika toggle sedang proses
                if (controller.isToggleLoading.value)
                  const Padding(
                    padding: EdgeInsets.all(14.0),
                    child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                  )
                else
                  Switch(
                    value: controller.isAvailable.value,
                    onChanged: controller.toggleAvailability,
                    activeColor: Colors.green.shade700,
                  ),
              ],
            )),
          )
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        return RefreshIndicator(
          onRefresh: controller.fetchDashboardData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildWelcomeHeader(),
                const SizedBox(height: 16),
                _buildSummaryCards(),
                const SizedBox(height: 24),
                _buildConsultationQueue(), // Placeholder antrian
              ],
            ),
          ),
        );
      }),
    );
  }

  /// Header Selamat Datang
  Widget _buildWelcomeHeader() {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: AppColors.greyLight,
          // TODO: Ganti dengan foto profil Pakar
          child: FaIcon(FontAwesomeIcons.userDoctor, size: 40, color: Colors.grey.shade400),
        ),
        const SizedBox(height: 12),
        Text(
          "Selamat Datang,",
          style: Get.textTheme.bodyLarge,
        ),
        Text(
          controller.profile.value?.user.fullName ?? "Pakar Genta",
          style: Get.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          controller.profile.value?.specialization ?? "Spesialisasi",
          style: Get.textTheme.bodyLarge?.copyWith(color: AppColors.primary),
        ),
      ],
    );
  }

  /// Kartu Ringkasan (Penghasilan & Antrian)
  Widget _buildSummaryCards() {
    return IntrinsicHeight(
      child: Row(
        children: [
          // Kartu Penghasilan (Data Mock Lokal)
          Expanded(
            child: Card(
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Total Penghasilan", style: Get.textTheme.bodyMedium),
                    const SizedBox(height: 8),
                    Text(
                      rupiahFormatter.format(controller.currentEarnings.value),
                      style: Get.textTheme.titleLarge?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: () { Get.toNamed(Routes.EXPERT_PAYOUT); },
                      child: const Text("Tarik Dana"),
                    ),
                  ],
                )),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Kartu Antrian (Data Mock Lokal)
          Expanded(
            child: Card(
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Antrian Konsultasi", style: Get.textTheme.bodyMedium),
                    const SizedBox(height: 8),
                    Text(
                      "${controller.pendingConsultations.value} Sesi",
                      style: Get.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: () { /* TODO: Go to Consultation List */ },
                      child: const Text("Lihat Antrian"),
                    ),
                  ],
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Placeholder untuk daftar antrian
  Widget _buildConsultationQueue() {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Antrian Anda (1)", style: Get.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const Divider(height: 24),
            // Ini adalah data mock UI
            ListTile(
              leading: const CircleAvatar(child: FaIcon(FontAwesomeIcons.user)),
              title: const Text("Budi (Petani)", style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text("Menunggu konfirmasi Anda..."),
              trailing: FilledButton(
                onPressed: () { /* TODO: Go to Chat Room */ },
                child: const Text("Mulai"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}