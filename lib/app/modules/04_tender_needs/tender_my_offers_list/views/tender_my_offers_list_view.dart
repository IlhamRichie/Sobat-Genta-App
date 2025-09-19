// lib/app/modules/tender_my_offers_list/views/tender_my_offers_list_view.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../data/models/tender_offer_model.dart';
import '../../../../theme/app_colors.dart';
import '../controllers/tender_my_offers_list_controller.dart';

class TenderMyOffersListView extends GetView<TenderMyOffersListController> {
TenderMyOffersListView({Key? key}) : super(key: key);
  
  final rupiahFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Penawaran Terkirim Saya"),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (controller.offerList.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(FontAwesomeIcons.fileSignature, size: 80, color: AppColors.greyLight),
                SizedBox(height: 16),
                Text("Anda belum pernah mengajukan penawaran."),
              ],
            ),
          );
        }

        // Render ListView Pagination
        return RefreshIndicator(
          onRefresh: controller.fetchInitialOffers,
          child: ListView.builder(
            controller: controller.scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: controller.offerList.length + 1, // +1 loader
            itemBuilder: (context, index) {
              if (index == controller.offerList.length) {
                return _buildLoader(); // Loader di akhir
              }
              final offer = controller.offerList[index];
              return _buildMyOfferCard(offer);
            },
          ),
        );
      }),
    );
  }

  /// Kartu untuk satu riwayat penawaran
  Widget _buildMyOfferCard(TenderOfferModel offer) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => controller.goToTenderDetail(offer),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Info Tender (Induk)
              Text("Tender untuk:", style: Get.textTheme.bodySmall),
              Text(
                offer.tenderRequest.title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                maxLines: 2,
              ),
              const Divider(height: 20),
              
              // 2. Info Penawaran (Saya)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Harga Penawaran Saya:"),
                      Text(
                        rupiahFormatter.format(offer.offerPrice),
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 18),
                      ),
                    ],
                  ),
                  _buildStatusBadge(offer.status),
                ],
              ),
              const SizedBox(height: 4),
              Text("Dikirim: ${offer.formattedDate}", style: Get.textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }

  /// Badge Status Penawaran
  Widget _buildStatusBadge(OfferStatus status) {
    Color color; String text; IconData icon;
    switch (status) {
      case OfferStatus.ACCEPTED:
        color = Colors.green; text = "Diterima"; icon = FontAwesomeIcons.check; break;
      case OfferStatus.REJECTED:
        color = Colors.red; text = "Ditolak"; icon = FontAwesomeIcons.xmark; break;
      default:
        color = Colors.orange; text = "Pending"; icon = FontAwesomeIcons.clock;
    }
    return Chip(
      label: Text(text, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
      avatar: FaIcon(icon, size: 14, color: color),
      backgroundColor: color.withOpacity(0.1),
      visualDensity: VisualDensity.compact,
    );
  }

  /// Loader Pagination (Identik dengan modul lain)
  Widget _buildLoader() {
    return Obx(() {
      if (controller.isLoadingMore.value) {
        return const Center(child: Padding(padding: EdgeInsets.all(24.0), child: CircularProgressIndicator()));
      }
      if (!controller.hasMoreData.value) {
         return const Center(child: Padding(padding: EdgeInsets.all(24.0), child: Text("Akhir dari daftar.")));
      }
      return const SizedBox.shrink();
    });
  }
}