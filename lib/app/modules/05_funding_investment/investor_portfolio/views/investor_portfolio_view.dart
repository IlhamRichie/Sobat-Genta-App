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
      backgroundColor: const Color(0xFFF5F6F8), // Background abu soft
      body: Stack(
        children: [
          // 1. Header Background Hijau
          Container(
            height: 280,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1B5E20), AppColors.primary], // Hijau Tua ke Muda
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
            ),
          ),
          
          // 2. Dekorasi Background (Lingkaran)
          Positioned(
            top: -50,
            right: -50,
            child: CircleAvatar(radius: 100, backgroundColor: Colors.white.withOpacity(0.05)),
          ),
          
          // 3. Konten Utama
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(),
                const SizedBox(height: 20),
                
                // Ringkasan Aset (Card Melayang)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _buildPortfolioSummaryCard(),
                ),
                
                const SizedBox(height: 24),
                
                // List Investasi
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: controller.fetchMyPortfolio,
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      
                      if (controller.investmentList.isEmpty) {
                        return _buildEmptyState();
                      }
                      
                      return ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                        itemCount: controller.investmentList.length,
                        separatorBuilder: (c, i) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final item = controller.investmentList[index];
                          return _buildInvestmentItem(item);
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

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Portofolio Saya",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Pantau aset masa depanmu",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: () { /* History Log */ },
              icon: const FaIcon(FontAwesomeIcons.clockRotateLeft, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  /// Card Ringkasan Aset (Total & ROI)
  Widget _buildPortfolioSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Obx(() => Column(
        children: [
          const Text("Total Nilai Investasi", style: TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 8),
          Text(
            rupiahFormatter.format(controller.totalInvestment.value),
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w900,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _buildSummaryStat("Proyek Aktif", "${controller.activeProjectsCount.value}", FontAwesomeIcons.layerGroup, Colors.blue),
              Container(width: 1, height: 40, color: Colors.grey.shade200),
              _buildSummaryStat("Estimasi Cuan", rupiahFormatter.format(controller.estimatedReturn.value), FontAwesomeIcons.arrowTrendUp, Colors.green),
            ],
          ),
        ],
      )),
    );
  }

  Widget _buildSummaryStat(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Column(
        children: [
          FaIcon(icon, size: 20, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }

  /// Item List Investasi
  Widget _buildInvestmentItem(InvestmentModel investment) {
    final project = investment.project;
    return GestureDetector(
      onTap: () => controller.goToPortfolioDetail(investment),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Thumbnail Proyek
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Container(
                width: 60, height: 60,
                color: Colors.grey.shade100,
                child: (project.projectImageUrl != null)
                    ? Image.network(
                        project.projectImageUrl!, 
                        fit: BoxFit.cover,
                        errorBuilder: (c,e,s) => const Icon(Icons.image, color: Colors.grey),
                      )
                    : const Icon(Icons.image, color: Colors.grey),
              ),
            ),
            const SizedBox(width: 16),
            
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Text("Investasi: ", style: TextStyle(fontSize: 12, color: Colors.grey)),
                      Text(
                        rupiahFormatter.format(investment.amountInvested),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Status Badge
            _buildStatusBadge(project.status),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(ProjectStatus status) {
    String text;
    Color color;
    
    switch (status) {
      case ProjectStatus.PUBLISHED:
      case ProjectStatus.FUNDED:
        text = "Berjalan";
        color = Colors.blue;
        break;
      case ProjectStatus.COMPLETED:
        text = "Selesai";
        color = Colors.green;
        break;
      default:
        text = "Pending";
        color = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 11),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(FontAwesomeIcons.folderOpen, size: 60, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text("Belum ada portofolio investasi.", style: TextStyle(color: Colors.grey.shade500)),
        ],
      ),
    );
  }
}