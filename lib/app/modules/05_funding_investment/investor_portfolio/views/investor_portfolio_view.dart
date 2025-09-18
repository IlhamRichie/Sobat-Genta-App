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
      appBar: AppBar(
        title: const Text("Portofolio Saya"),
        // Halaman ini adalah root tab, idealnya tidak ada back button
        // jika diakses dari MainNav, tapi akan ada jika diakses dari 
        // form investasi. GetX akan menanganinya secara otomatis.
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.investmentList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        
        // Gunakan NestedScrollView agar header bisa 'fixed'
        return RefreshIndicator(
          onRefresh: controller.fetchMyPortfolio,
          child: ListView(
            children: [
              _buildPortfolioHeader(),
              _buildSectionTitle("Investasi Saya"),
              ..._buildInvestmentList(),
            ],
          ),
        );
      }),
    );
  }

  /// Widget Header: Ringkasan Total Portofolio
  Widget _buildPortfolioHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Obx(() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Total Nilai Investasi",
            style: Get.textTheme.titleMedium?.copyWith(color: Colors.white70),
          ),
          Text(
            rupiahFormatter.format(controller.totalInvestment.value),
            style: Get.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(color: Colors.white24, height: 32),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Proyek Aktif", style: Get.textTheme.bodyMedium?.copyWith(color: Colors.white70)),
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
                    Text("Estimasi Return", style: Get.textTheme.bodyMedium?.copyWith(color: Colors.white70)),
                    Text(
                      rupiahFormatter.format(controller.estimatedReturn.value),
                      style: Get.textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      )),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Text(
        title,
        style: Get.textTheme.titleLarge?.copyWith(fontSize: 18),
      ),
    );
  }

  /// Daftar Kartu Investasi
  List<Widget> _buildInvestmentList() {
    if (controller.investmentList.isEmpty) {
      return [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Text("Anda belum memiliki investasi aktif."),
          ),
        )
      ];
    }
    
    return controller.investmentList.map((investment) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: _buildInvestmentCard(investment),
      );
    }).toList();
  }

  /// Kartu untuk menampilkan SATU investasi
  Widget _buildInvestmentCard(InvestmentModel investment) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => controller.goToPortfolioDetail(investment),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // TODO: Placeholder gambar
                  Container(
                    width: 60, height: 60,
                    decoration: BoxDecoration(color: AppColors.greyLight, borderRadius: BorderRadius.circular(8)),
                    child: const FaIcon(FontAwesomeIcons.image, color: Colors.grey),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          investment.project.title,
                          style: Get.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        _buildProjectStatusBadge(investment.project.status),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              Text("Investasi Anda:", style: Get.textTheme.bodyMedium),
              Text(
                rupiahFormatter.format(investment.amountInvested),
                style: Get.textTheme.titleMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Badge untuk status proyek (Copy-paste dari view sebelumnya)
  Widget _buildProjectStatusBadge(ProjectStatus status) {
    Color color; String text; IconData icon;
    switch (status) {
      case ProjectStatus.PUBLISHED: color = Colors.blue.shade700; text = "Galang Dana"; icon = FontAwesomeIcons.bullhorn; break;
      case ProjectStatus.FUNDED: color = Colors.green.shade700; text = "Berjalan"; icon = FontAwesomeIcons.personRunning; break;
      case ProjectStatus.COMPLETED: color = Colors.grey.shade700; text = "Selesai"; icon = FontAwesomeIcons.flagCheckered; break;
      default: color = Colors.orange.shade700; text = "Pending"; icon = FontAwesomeIcons.clock; break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        FaIcon(icon, size: 12, color: color), const SizedBox(width: 6),
        Text(text, style: Get.textTheme.bodySmall?.copyWith(color: color, fontWeight: FontWeight.w700)),
      ],),
    );
  }
}