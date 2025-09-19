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
      appBar: AppBar(
        title: const Text("Ajukan Penawaran"),
      ),
      bottomNavigationBar: _buildBottomSubmitButton(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Tampilkan ringkasan tender yang ditawar
            _buildTenderHeader(),
            
            // 2. Formulir Penawaran
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Penawaran Anda",
                      style: Get.textTheme.titleLarge?.copyWith(fontSize: 18),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: controller.priceC,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: _inputDecoration("Harga yang Anda Tawarkan (Rp)", FontAwesomeIcons.sackDollar),
                      validator: (v) {
                        if (v == null || v.isEmpty) return "Harga wajib diisi";
                        if ((double.tryParse(v) ?? 0) <= 0) return "Harga tidak valid";
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: controller.notesC,
                      decoration: _inputDecoration("Catatan (Opsional)", FontAwesomeIcons.solidCommentDots, alignTop: true),
                      maxLines: 5,
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

  /// Header yang menampilkan info tender (Read-only)
  Widget _buildTenderHeader() {
    final tender = controller.tenderRequest;
    return Container(
      width: double.infinity,
      color: AppColors.primary.withOpacity(0.05),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Anda mengajukan penawaran untuk:", style: Get.textTheme.bodyMedium),
          Text(
            tender.title,
            style: Get.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary),
          ),
          Text("Diminta oleh: ${tender.requestorName}"),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData? icon, {bool alignTop = false}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: icon != null ? FaIcon(icon, size: 20) : null,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      alignLabelWithHint: alignTop,
    );
  }

  /// Tombol CTA Bawah
  Widget _buildBottomSubmitButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Obx(() => FilledButton(
        onPressed: controller.isLoading.value ? null : controller.submitOffer,
        child: controller.isLoading.value
            ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white))
            : const Text("Kirim Penawaran"),
      )),
    );
  }
}