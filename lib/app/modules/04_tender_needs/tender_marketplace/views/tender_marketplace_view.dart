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
      appBar: _buildAppBar(),
      floatingActionButton: _buildFloatingActionButton(),
      
      body: Obx(() {
        if (controller.isLoading.value && controller.tenderList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (controller.tenderList.isEmpty) {
          return const Center(
            child: Text(
              "Belum ada tender dibuka.",
              style: TextStyle(color: AppColors.textLight),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchInitialTenders,
          child: ListView.builder(
            controller: controller.scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
    );
  }

  /// AppBar Kustom (Diperbarui)
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      title: Text(
        "Tender",
        style: Get.textTheme.headlineSmall?.copyWith(
          color: AppColors.textDark,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: false,
      actions: [
        IconButton(
          onPressed: () { /* TODO: Filter */ },
          icon: const FaIcon(FontAwesomeIcons.filter, color: AppColors.textDark),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
  
  /// FAB (Diperbarui)
  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: controller.goToCreateTender,
      icon: const FaIcon(FontAwesomeIcons.plus),
      label: const Text("Buat Permintaan"),
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8, // Tambah shadow
    );
  }

  /// Kartu untuk satu item tender (Diperbarui)
  Widget _buildTenderCard(TenderRequestModel tender) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20), // Sudut lebih rounded
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => controller.goToTenderDetail(tender),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(20), // Padding lebih lega
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Kategori & Penawar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      tender.category,
                      style: Get.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.solidCommentDots,
                        size: 14,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "${tender.totalOffers} Penawaran",
                        style: Get.textTheme.bodyMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Judul & Deskripsi Singkat
              Text(
                tender.title,
                style: Get.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                "Oleh: ${tender.requestorName}",
                style: Get.textTheme.bodySmall?.copyWith(color: AppColors.textLight),
              ),
              const SizedBox(height: 16),
              // Budget & Deadline
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Budget", style: TextStyle(color: AppColors.textLight)),
                        const SizedBox(height: 4),
                        Text(
                          tender.targetBudget != null
                              ? rupiahFormatter.format(tender.targetBudget!)
                              : "Terbuka",
                          style: Get.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text("Batas Waktu", style: TextStyle(color: AppColors.textLight)),
                        const SizedBox(height: 4),
                        Text(
                          tender.formattedDeadline,
                          style: Get.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
    );
  }
  
  /// Loader Pagination (Tidak ada perubahan signifikan)
  Widget _buildLoader() {
    return Obx(() {
      if (controller.isLoadingMore.value) {
        return const Center(child: Padding(padding: EdgeInsets.all(24.0), child: CircularProgressIndicator()));
      }
      if (!controller.hasMoreData.value) {
        return const Center(child: Padding(padding: EdgeInsets.all(24.0), child: Text("Akhir dari daftar tender.")));
      }
      return const SizedBox.shrink();
    });
  }
}