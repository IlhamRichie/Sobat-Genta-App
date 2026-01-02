// lib/app/modules/tender_marketplace/views/tender_marketplace_view.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../data/models/tender_request_model.dart';
import '../../../../theme/app_colors.dart';
import '../controllers/tender_marketplace_controller.dart';

class TenderMarketplaceView extends GetView<TenderMarketplaceController> {
  TenderMarketplaceView({Key? key}) : super(key: key);

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
                color: Colors.purple.withOpacity(0.05), // Nuansa ungu untuk Tender/Bisnis
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 100,
            left: -80,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // 2. MAIN CONTENT
          SafeArea(
            child: Column(
              children: [
                _buildCustomAppBar(),
                
                // Content List
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value && controller.tenderList.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    
                    if (controller.tenderList.isEmpty) {
                      return _buildEmptyState();
                    }

                    return RefreshIndicator(
                      onRefresh: controller.fetchInitialTenders,
                      color: AppColors.primary,
                      child: ListView.builder(
                        controller: controller.scrollController,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 80), // Bottom padding for FAB
                        itemCount: controller.tenderList.length + 1, // +1 loader
                        itemBuilder: (context, index) {
                          if (index == controller.tenderList.length) {
                            return _buildLoader(); // Loader di akhir
                          }
                          final tender = controller.tenderList[index];
                          return _buildTenderCard(tender);
                        },
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  /// Custom AppBar & Header
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
                "Bursa Tender",
                style: Get.textTheme.headlineSmall?.copyWith(
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w800,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Temukan peluang proyek pertanian",
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
              onPressed: () { /* TODO: Filter BottomSheet */ },
              icon: const FaIcon(FontAwesomeIcons.sliders, size: 18, color: AppColors.textDark),
              splashRadius: 24,
            ),
          ),
        ],
      ),
    );
  }

  /// Empty State Modern
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.greyLight.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: const FaIcon(FontAwesomeIcons.boxOpen, size: 48, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          const Text(
            "Belum ada tender dibuka.",
            style: TextStyle(
              color: AppColors.textDark, 
              fontWeight: FontWeight.bold, 
              fontSize: 16
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Jadilah yang pertama membuat permintaan!",
            style: TextStyle(color: AppColors.textLight),
          ),
        ],
      ),
    );
  }

  /// Tender Card (Josjis Design)
  Widget _buildTenderCard(TenderRequestModel tender) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () => controller.goToTenderDetail(tender),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Header Card: Kategori & Offer Count
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withOpacity(0.15), // Background kuning transparan
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        tender.category.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFF57C00), // Warna teks oranye tua
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        const FaIcon(FontAwesomeIcons.userGroup, size: 12, color: AppColors.textLight),
                        const SizedBox(width: 6),
                        Text(
                          "${tender.totalOffers} Penawaran",
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textLight,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // 2. Title & User
                Text(
                  tender.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 10,
                      backgroundColor: AppColors.greyLight,
                      child: FaIcon(FontAwesomeIcons.user, size: 10, color: Colors.grey),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        tender.requestorName,
                        style: const TextStyle(fontSize: 13, color: AppColors.textLight),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                const Divider(height: 1, color: AppColors.greyLight),
                const SizedBox(height: 16),

                // 3. Footer: Budget & Deadline
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Estimasi Budget",
                            style: TextStyle(fontSize: 11, color: AppColors.textLight),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            tender.targetBudget != null
                                ? rupiahFormatter.format(tender.targetBudget!)
                                : "Open Budget",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.greyLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const FaIcon(FontAwesomeIcons.clock, size: 12, color: AppColors.textDark),
                          const SizedBox(width: 6),
                          Text(
                            tender.formattedDeadline, // Pastikan formatnya singkat (e.g. 12 Des)
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Modern FAB
  Widget _buildFloatingActionButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: FloatingActionButton.extended(
        onPressed: controller.goToCreateTender,
        backgroundColor: AppColors.primary,
        elevation: 0, // Shadow handled by container
        highlightElevation: 0,
        label: const Text(
          "Buat Tender",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
        ),
        icon: const FaIcon(FontAwesomeIcons.plus, size: 16),
      ),
    );
  }

  /// Loader Widget
  Widget _buildLoader() {
    return Obx(() {
      if (controller.isLoadingMore.value) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: SizedBox(
              width: 24, height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        );
      }
      if (!controller.hasMoreData.value && controller.tenderList.isNotEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Text(
              "Semua tender telah ditampilkan",
              style: TextStyle(color: AppColors.textLight, fontSize: 12),
            ),
          ),
        );
      }
      return const SizedBox.shrink();
    });
  }
}