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
      body: Stack(
        children: [
          // 1. BACKGROUND DECORATION
          Positioned(
            top: -100,
            right: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 150,
            left: -80,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.05),
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
                    onRefresh: controller.fetchMyPortfolio,
                    color: AppColors.primary,
                    child: Obx(() {
                      if (controller.isLoading.value && controller.investmentList.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      
                      return ListView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        children: [
                          _buildPortfolioHeader(),
                          const SizedBox(height: 24),
                          
                          _buildSectionTitle("Aset Investasi"),
                          const SizedBox(height: 16),
                          
                          ..._buildInvestmentList(),
                          const SizedBox(height: 20),
                        ],
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
                "Portofolio Saya",
                style: Get.textTheme.headlineSmall?.copyWith(
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w800,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Pantau pertumbuhan aset Anda",
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
              onPressed: () { /* TODO: History/Log */ },
              icon: const FaIcon(FontAwesomeIcons.chartPie, size: 20, color: AppColors.primary),
              splashRadius: 24,
            ),
          ),
        ],
      ),
    );
  }

  /// 1. Header Ringkasan Portofolio (Gradient)
  Widget _buildPortfolioHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, Color(0xFF1B5E20)], // Hijau ke Hijau Tua
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Dekorasi
          Positioned(
            right: -20,
            top: -20,
            child: Icon(
              FontAwesomeIcons.seedling,
              size: 120,
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          Positioned(
            bottom: -30,
            left: 20,
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white.withOpacity(0.1),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        "TOTAL INVESTASI",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  rupiahFormatter.format(controller.totalInvestment.value),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    _buildHeaderStatItem(
                      "Proyek Aktif", 
                      "${controller.activeProjectsCount.value} Unit",
                      FontAwesomeIcons.layerGroup
                    ),
                    const SizedBox(width: 24),
                    _buildHeaderStatItem(
                      "Estimasi Return", 
                      rupiahFormatter.format(controller.estimatedReturn.value),
                      FontAwesomeIcons.arrowTrendUp
                    ),
                  ],
                ),
              ],
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderStatItem(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            FaIcon(icon, size: 12, color: Colors.white70),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.textDark,
      ),
    );
  }

  /// 2. Daftar Investasi
  List<Widget> _buildInvestmentList() {
    if (controller.investmentList.isEmpty) {
      return [_buildEmptyState()];
    }
    
    return controller.investmentList.map((investment) {
      return _buildInvestmentCard(investment);
    }).toList();
  }

  /// Empty State Modern
  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.greyLight.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: const FaIcon(FontAwesomeIcons.sackDollar, size: 48, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          const Text(
            "Belum Ada Investasi",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Mulai mendanai proyek pertanian dan dapatkan imbal hasil.",
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textLight),
          ),
          const SizedBox(height: 24),
          OutlinedButton(
            onPressed: () { 
              // Navigasi ke marketplace (bisa pakai controller atau Get.find)
              // Get.find<MainNavigationController>().changeTab(1); // Contoh
            }, 
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Cari Proyek"),
          ),
        ],
      ),
    );
  }

  /// 3. Kartu Item Investasi
  Widget _buildInvestmentCard(InvestmentModel investment) {
    final project = investment.project;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () => controller.goToPortfolioDetail(investment),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gambar Proyek
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: 80, height: 80,
                    color: AppColors.greyLight,
                    child: (project.projectImageUrl != null && project.projectImageUrl!.isNotEmpty)
                        ? Image.network(
                            project.projectImageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, s) => const Center(child: Icon(Icons.image, color: Colors.grey)),
                          )
                        : const Center(child: FaIcon(FontAwesomeIcons.image, color: Colors.grey, size: 24)),
                  ),
                ),
                const SizedBox(width: 16),
                
                // Detail
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Judul & Status
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              project.title,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDark),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          _buildStatusBadge(project.status),
                        ],
                      ),
                      const SizedBox(height: 12),
                      
                      // Nilai Investasi
                      const Text(
                        "Nilai Investasi",
                        style: TextStyle(fontSize: 11, color: AppColors.textLight),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        rupiahFormatter.format(investment.amountInvested),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Badge Status Kecil
  Widget _buildStatusBadge(ProjectStatus status) {
    Color color;
    IconData icon;
    
    switch (status) {
      case ProjectStatus.PUBLISHED: color = AppColors.primary; icon = FontAwesomeIcons.bullhorn; break;
      case ProjectStatus.FUNDED: color = Colors.blue; icon = FontAwesomeIcons.personRunning; break; // Berjalan
      case ProjectStatus.COMPLETED: color = Colors.green; icon = FontAwesomeIcons.check; break;
      default: color = Colors.orange; icon = FontAwesomeIcons.clock; break;
    }

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: FaIcon(icon, size: 10, color: color),
    );
  }
}