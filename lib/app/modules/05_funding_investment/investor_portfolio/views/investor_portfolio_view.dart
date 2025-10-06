// lib/app/modules/investor_portfolio/views/investor_portfolio_view.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../data/models/investment_model.dart';
import '../../../../data/models/project_model.dart';
import '../../../../theme/app_colors.dart';
import '../controllers/investor_portfolio_controller.dart';

class InvestorPortfolioView extends GetView<InvestorPortfolioController> {
  InvestorPortfolioView({Key? key}) : super(key: key);
  
  final rupiahFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Obx(() {
        if (controller.isLoading.value && controller.investmentList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        
        return RefreshIndicator(
          onRefresh: controller.fetchMyPortfolio,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildPortfolioHeader(),
              const SizedBox(height: 24),
              _buildSectionTitle("Investasi Saya"),
              const SizedBox(height: 12),
              ..._buildInvestmentList(),
            ],
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
        "Portofolio Saya",
        style: Get.textTheme.headlineSmall?.copyWith(
          color: AppColors.textDark,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: false,
    );
  }

  /// Widget Header: Ringkasan Total Portofolio (Didesain Ulang)
  Widget _buildPortfolioHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Obx(() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Total Nilai Investasi",
            style: Get.textTheme.titleMedium?.copyWith(
              color: Colors.white.withOpacity(0.8),
              fontSize: 16,
            ),
          ),
          Text(
            rupiahFormatter.format(controller.totalInvestment.value),
            style: Get.textTheme.headlineLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Proyek Aktif",
                      style: Get.textTheme.bodyMedium?.copyWith(color: Colors.white.withOpacity(0.8)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${controller.activeProjectsCount.value} Proyek",
                      style: Get.textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Estimasi Return",
                      style: Get.textTheme.bodyMedium?.copyWith(color: Colors.white.withOpacity(0.8)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      rupiahFormatter.format(controller.estimatedReturn.value),
                      style: Get.textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      )),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      child: Text(
        title,
        style: Get.textTheme.titleLarge?.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Daftar Kartu Investasi (Didesain Ulang)
  List<Widget> _buildInvestmentList() {
    if (controller.investmentList.isEmpty) {
      return [
        _buildEmptyState(),
      ];
    }
    
    return controller.investmentList.map((investment) {
      return _buildInvestmentCard(investment);
    }).toList();
  }

  /// Empty State yang Didesain Ulang
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FaIcon(FontAwesomeIcons.sackDollar, size: 96, color: AppColors.greyLight),
            const SizedBox(height: 32),
            Text(
              "Anda Belum Memiliki Investasi",
              style: Get.textTheme.titleLarge?.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              "Jelajahi marketplace kami untuk menemukan proyek menarik.",
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

  /// Kartu untuk menampilkan SATU investasi (Didesain Ulang)
  Widget _buildInvestmentCard(InvestmentModel investment) {
    final project = investment.project;
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
        onTap: () => controller.goToPortfolioDetail(investment),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 60, height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.greyLight,
                      borderRadius: BorderRadius.circular(12),
                      image: project.projectImageUrl != null && project.projectImageUrl!.isNotEmpty
                          ? DecorationImage(image: NetworkImage(project.projectImageUrl!), fit: BoxFit.cover)
                          : null,
                    ),
                    child: project.projectImageUrl == null || project.projectImageUrl!.isEmpty
                        ? const Center(child: FaIcon(FontAwesomeIcons.image, color: Colors.grey))
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project.title,
                          style: Get.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        _buildProjectStatusBadge(project.status),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                "Investasi Anda:",
                style: Get.textTheme.bodyMedium?.copyWith(color: AppColors.textLight),
              ),
              Text(
                rupiahFormatter.format(investment.amountInvested),
                style: Get.textTheme.titleLarge?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Badge untuk status proyek (Didesain Ulang)
  Widget _buildProjectStatusBadge(ProjectStatus status) {
    Color color; String text; IconData icon;
    switch (status) {
      case ProjectStatus.PUBLISHED: color = AppColors.primary; text = "Galang Dana"; icon = FontAwesomeIcons.bullhorn; break;
      case ProjectStatus.FUNDED: color = Colors.green; text = "Berjalan"; icon = FontAwesomeIcons.personRunning; break;
      case ProjectStatus.COMPLETED: color = AppColors.textDark; text = "Selesai"; icon = FontAwesomeIcons.flagCheckered; break;
      default: color = Colors.orange; text = "Pending"; icon = FontAwesomeIcons.clock; break;
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