// lib/app/modules/investor_portfolio_detail/views/investor_portfolio_detail_view.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../data/models/project_update_model.dart';
import '../../../../theme/app_colors.dart';
import '../controllers/investor_portfolio_detail_controller.dart';

class InvestorPortfolioDetailView extends GetView<InvestorPortfolioDetailController> {
  InvestorPortfolioDetailView({Key? key}) : super(key: key);
  
  final rupiahFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.investment.project.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInvestmentSummaryCard(),
            _buildSectionTitle("Progres Proyek (Timeline)"),
            _buildUpdatesTimeline(),
          ],
        ),
      ),
    );
  }

  /// Kartu Ringkasan Investasi (Data Statis)
  Widget _buildInvestmentSummaryCard() {
    final project = controller.investment.project;
    
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.2))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Ringkasan Investasi Anda", style: Get.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const Divider(height: 24),
          _buildSummaryRow(
            "Jumlah Investasi",
            rupiahFormatter.format(controller.investment.amountInvested),
            true
          ),
          _buildSummaryRow(
            "Estimasi Return (${project.roiEstimate}%)",
            rupiahFormatter.format(controller.estimatedReturnAmount),
            true
          ),
          _buildSummaryRow(
            "Status Proyek",
            project.status.toString().split('.').last, // Cth: "PUBLISHED"
            false
          ),
          _buildSummaryRow(
            "Durasi Proyek",
            "${project.durationDays} Hari",
            false
          ),
        ],
      ),
    );
  }
  
  Widget _buildSummaryRow(String label, String value, bool isCurrency) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Get.textTheme.bodyMedium?.copyWith(color: AppColors.textLight)),
          Text(
            value,
            style: Get.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: isCurrency ? AppColors.primary : AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Text(
        title,
        style: Get.textTheme.titleLarge?.copyWith(fontSize: 18),
      ),
    );
  }

  /// Widget Timeline Progres (Data Dinamis)
  Widget _buildUpdatesTimeline() {
    return Obx(() {
      if (controller.isLoadingUpdates.value) {
        return const Center(child: Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(),
        ));
      }
      
      if (controller.updateList.isEmpty) {
        return const Center(child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text("Petani belum memberikan update progres."),
        ));
      }
      
      // Tampilkan sebagai ListView (tapi tidak scrollable, karena parent sudah scrollable)
      return ListView.builder(
        itemCount: controller.updateList.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final update = controller.updateList[index];
          // Gunakan custom widget untuk tampilan timeline
          return TimelineTile(update: update, isFirst: index == 0, isLast: index == controller.updateList.length - 1);
        },
      );
    });
  }
}

/// WIDGET REUSABLE: Untuk satu item di timeline
class TimelineTile extends StatelessWidget {
  final ProjectUpdateModel update;
  final bool isFirst;
  final bool isLast;

  const TimelineTile({
    Key? key,
    required this.update,
    required this.isFirst,
    required this.isLast,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Bagian Garis Timeline
          _buildTimelineConnector(),
          
          // 2. Bagian Konten
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(update.formattedDate, style: Get.textTheme.bodySmall?.copyWith(color: AppColors.textLight)),
                  const SizedBox(height: 4),
                  Text(update.title, style: Get.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(update.description, style: Get.textTheme.bodyMedium?.copyWith(height: 1.4)),
                  // Tampilkan gambar jika ada
                  if (update.imageUrl != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.greyLight,
                          borderRadius: BorderRadius.circular(8),
                          // TODO: Ganti dengan Image.network(update.imageUrl!)
                        ),
                        child: const Center(child: FaIcon(FontAwesomeIcons.image)),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Widget untuk garis & titik timeline
  Widget _buildTimelineConnector() {
    return SizedBox(
      width: 40,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          // Garis atas (sembunyikan jika item pertama)
          Expanded(
            child: Container(
              width: 2,
              color: isFirst ? Colors.transparent : Colors.grey.shade300,
            ),
          ),
          // Titik Tengah (Circle)
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isFirst ? AppColors.primary : Colors.grey.shade300,
            ),
            child: isFirst ? const Icon(Icons.check_circle, size: 16, color: Colors.white) : null,
          ),
          // Garis bawah (sembunyikan jika item terakhir)
          Expanded(
            child: Container(
              width: 2,
              color: isLast ? Colors.transparent : Colors.grey.shade300,
            ),
          ),
        ],
      ),
    );
  }
}