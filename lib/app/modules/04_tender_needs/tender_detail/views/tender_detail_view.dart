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
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
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
              const SizedBox(height: 24),
              _buildDescription(tender),
              const SizedBox(height: 24),
              _buildOfferList(tender.offers ?? []),
              const SizedBox(height: 24), // Padding akhir
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
      leading: BackButton(onPressed: () => Get.back(), color: AppColors.textDark),
      title: Text(
        "Detail Tender",
        style: Get.textTheme.headlineSmall?.copyWith(
          color: AppColors.textDark,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: false,
    );
  }

  /// 1. Info Tender Utama (Didesain Ulang)
  Widget _buildHeader(tender) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Kategori
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(tender.category, style: Get.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary)),
          ),
          const SizedBox(height: 16),
          // Judul
          Text(
            tender.title,
            style: Get.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: AppColors.textDark),
          ),
          const SizedBox(height: 12),
          Text(
            "Oleh: ${tender.requestorName}",
            style: Get.textTheme.titleMedium?.copyWith(color: AppColors.textLight),
          ),
          const SizedBox(height: 24),
          // Info Budget & Deadline
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: _buildInfoBox(
                    "Estimasi \nBudget",
                    tender.targetBudget != null ? controller.rupiahFormatter.format(tender.targetBudget!) : "Terbuka",
                    FontAwesomeIcons.sackDollar,
                    AppColors.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInfoBox(
                    "Batas \nWaktu",
                    tender.formattedDeadline,
                    FontAwesomeIcons.calendarXmark,
                    Colors.red.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Helper untuk Info Box (Didesain Ulang)
  Widget _buildInfoBox(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.greyLight),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FaIcon(icon, size: 18, color: color),
              const SizedBox(width: 8),
              Text(label, style: Get.textTheme.bodySmall?.copyWith(color: AppColors.textLight)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDark),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  /// 2. Deskripsi Tender (Didesain Ulang)
  Widget _buildDescription(tender) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        padding: const EdgeInsets.all(20),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Deskripsi Kebutuhan", style: Get.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(
              tender.fullDescription ?? "Tidak ada deskripsi rinci.",
              style: Get.textTheme.bodyLarge?.copyWith(height: 1.5, color: AppColors.textDark),
            ),
          ],
        ),
      ),
    );
  }

  /// 3. Daftar Penawaran Masuk (Didesain Ulang)
  Widget _buildOfferList(List<TenderOfferModel> offers) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Penawaran Masuk (${offers.length})",
            style: Get.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 16),
          if (offers.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
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
  
  /// Kartu untuk satu penawaran (Didesain Ulang)
  Widget _buildOfferCard(TenderOfferModel offer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            backgroundColor: AppColors.greyLight,
            child: FaIcon(FontAwesomeIcons.store, color: Colors.grey),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(offer.supplierName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(offer.notes, maxLines: 2, overflow: TextOverflow.ellipsis, style: Get.textTheme.bodySmall?.copyWith(color: AppColors.textLight)),
                const SizedBox(height: 8),
                Text(
                  controller.rupiahFormatter.format(offer.offerPrice),
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  /// Tombol CTA di Bawah (Didesain Ulang)
  Widget _buildBottomCtaBar() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: FilledButton(
        onPressed: controller.goToSubmitOffer,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
        ),
        child: const Text("Ajukan Penawaran Anda", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}