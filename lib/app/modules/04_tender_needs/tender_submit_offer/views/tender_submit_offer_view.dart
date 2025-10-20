// lib/app/modules/tender_submit_offer/views/tender_submit_offer_view.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../theme/app_colors.dart';
import '../controllers/tender_submit_offer_controller.dart';

class TenderSubmitOfferView extends GetView<TenderSubmitOfferController> {
  const TenderSubmitOfferView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      bottomNavigationBar: _buildBottomSubmitButton(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildTenderHeader(),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Penawaran Anda",
                      style: Get.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    _buildTextFormField(
                      controller: controller.priceC,
                      label: "Harga yang Anda Tawarkan",
                      icon: FontAwesomeIcons.sackDollar,
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v == null || v.isEmpty) return "Harga wajib diisi";
                        if ((double.tryParse(v) ?? 0) <= 0) return "Harga tidak valid";
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextFormField(
                      controller: controller.notesC,
                      label: "Catatan (Opsional)",
                      icon: FontAwesomeIcons.solidCommentDots,
                      maxLines: 5,
                      alignTop: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// AppBar Kustom
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: BackButton(onPressed: () => Get.back(), color: AppColors.textDark),
      title: Text(
        "Ajukan Penawaran",
        style: Get.textTheme.headlineSmall?.copyWith(
          color: AppColors.textDark,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: false,
    );
  }

  /// Header yang menampilkan info tender (Read-only) (Didesain Ulang)
  Widget _buildTenderHeader() {
    final tender = controller.tenderRequest;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Anda mengajukan penawaran untuk:",
            style: Get.textTheme.bodyMedium?.copyWith(color: Colors.white.withOpacity(0.8)),
          ),
          const SizedBox(height: 8),
          Text(
            tender.title,
            style: Get.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(
            "Diminta oleh: ${tender.requestorName}",
            style: Get.textTheme.bodyMedium?.copyWith(color: Colors.white.withOpacity(0.8)),
          ),
        ],
      ),
    );
  }

  /// Helper untuk TextFormField (Baru)
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData? icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int? maxLines = 1,
    bool alignTop = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? FaIcon(icon, size: 20, color: AppColors.textLight) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.greyLight)),
        alignLabelWithHint: alignTop,
      ),
      validator: validator,
    );
  }

  /// Tombol CTA Bawah (Didesain Ulang)
  Widget _buildBottomSubmitButton() {
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
      child: Obx(() => FilledButton(
        onPressed: controller.isLoading.value ? null : controller.submitOffer,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
        ),
        child: controller.isLoading.value
            ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : const Text("Kirim Penawaran", style: TextStyle(fontWeight: FontWeight.bold)),
      )),
    );
  }
}