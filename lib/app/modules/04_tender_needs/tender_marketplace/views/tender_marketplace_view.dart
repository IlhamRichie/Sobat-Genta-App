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
      appBar: AppBar(
        title: const Text("Marketplace Kebutuhan (Tender)"),
        actions: [
          IconButton(onPressed: () { /* TODO: Filter */ }, icon: const FaIcon(FontAwesomeIcons.filter)),
        ],
      ),
      // Tombol Aksi (Hanya Petani yg boleh?)
      floatingActionButton: FloatingActionButton.extended(
        onPressed: controller.goToCreateTender,
        icon: const FaIcon(FontAwesomeIcons.plus),
        label: const Text("Buat Permintaan"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (controller.tenderList.isEmpty) {
          return const Center(child: Text("Belum ada tender dibuka."));
        }

        return RefreshIndicator(
          onRefresh: controller.fetchInitialTenders,
          child: ListView.builder(
            controller: controller.scrollController,
            padding: const EdgeInsets.all(16),
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

  /// Kartu untuk satu item tender
  Widget _buildTenderCard(TenderRequestModel tender) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => controller.goToTenderDetail(tender),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Kategori & Penawar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Chip(
                    label: Text(tender.category, style: const TextStyle(fontWeight: FontWeight.bold)),
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    visualDensity: VisualDensity.compact,
                  ),
                  Text(
                    "${tender.totalOffers} Penawaran",
                    style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Judul
              Text(
                tender.title,
                style: Get.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 8),
              // Requestor
              Text("Oleh: ${tender.requestorName}", style: Get.textTheme.bodySmall),
              const Divider(height: 24),
              // Budget & Deadline
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Budget:", style: TextStyle(color: AppColors.textLight)),
                      Text(
                        tender.targetBudget != null ? rupiahFormatter.format(tender.targetBudget!) : "Terbuka",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text("Batas Waktu:", style: TextStyle(color: AppColors.textLight)),
                      Text(
                        tender.formattedDeadline,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  /// Loader Pagination (Identik dengan modul lain)
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