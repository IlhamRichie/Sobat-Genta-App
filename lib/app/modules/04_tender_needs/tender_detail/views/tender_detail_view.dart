// lib/app/modules/tender_detail/views/tender_detail_view.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../data/models/tender_offer_model.dart';
import '../../../../theme/app_colors.dart';
import '../controllers/tender_detail_controller.dart';

class TenderDetailView extends GetView<TenderDetailController> {
  const TenderDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Tender"),
      ),
      // Tombol CTA untuk mengajukan penawaran
      bottomNavigationBar: _buildBottomCtaBar(),
      
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.tender.value == null) {
          return const Center(child: Text("Tender tidak ditemukan."));
        }

        final tender = controller.tender.value!;
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(tender),
              _buildDescription(tender),
              _buildOfferList(tender.offers ?? []),
            ],
          ),
        );
      }),
    );
  }

  /// 1. Info Tender Utama
  Widget _buildHeader(tender) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Chip(
            label: Text(tender.category, style: const TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: AppColors.primary.withOpacity(0.1),
          ),
          const SizedBox(height: 12),
          Text(tender.title, style: Get.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text("Oleh: ${tender.requestorName}", style: Get.textTheme.titleMedium),
          const Divider(height: 32),
          // Info Budget & Deadline
          Row(
            children: [
              Expanded(
                child: _buildInfoBox(
                  "Estimasi Budget",
                  tender.targetBudget != null ? controller.rupiahFormatter.format(tender.targetBudget!) : "Terbuka",
                  FontAwesomeIcons.sackDollar,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInfoBox(
                  "Batas Waktu",
                  tender.formattedDeadline,
                  FontAwesomeIcons.calendarXmark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 2. Deskripsi Tender
  Widget _buildDescription(tender) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Deskripsi Kebutuhan", style: Get.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            tender.fullDescription ?? "Tidak ada deskripsi rinci.",
            style: Get.textTheme.bodyLarge?.copyWith(height: 1.5, color: AppColors.textLight),
          ),
        ],
      ),
    );
  }

  /// 3. Daftar Penawaran Masuk
  Widget _buildOfferList(List<TenderOfferModel> offers) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(height: 32),
          Text(
            "Penawaran Masuk (${offers.length})",
            style: Get.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          if (offers.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("Jadilah yang pertama mengajukan penawaran!", style: TextStyle(color: AppColors.textLight)),
              ),
            ),
          
          // Render list penawaran
          ListView.builder(
            itemCount: offers.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (ctx, index) {
              final offer = offers[index];
              return _buildOfferCard(offer);
            },
          ),
        ],
      ),
    );
  }
  
  /// Kartu untuk satu penawaran
  Widget _buildOfferCard(TenderOfferModel offer) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300)
      ),
      child: ListTile(
        leading: const CircleAvatar(child: FaIcon(FontAwesomeIcons.store)),
        title: Text(offer.supplierName, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(offer.notes, maxLines: 2),
        trailing: Text(
          controller.rupiahFormatter.format(offer.offerPrice),
          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildInfoBox(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          FaIcon(icon, size: 14, color: AppColors.textLight),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: AppColors.textLight)),
        ]),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }
  
  /// Tombol CTA di Bawah
  Widget _buildBottomCtaBar() {
     return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: FilledButton(
        onPressed: controller.goToSubmitOffer, // Navigasi ke form (permintaan Anda)
        child: const Text("Ajukan Penawaran Anda"),
      ),
    );
  }
}