// lib/app/modules/tender_create_request/views/tender_create_request_view.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../theme/app_colors.dart';
import '../controllers/tender_create_request_controller.dart';

class TenderCreateRequestView extends GetView<TenderCreateRequestController> {
  const TenderCreateRequestView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Buat Permintaan Tender"),
      ),
      bottomNavigationBar: _buildBottomSubmitButton(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Jelaskan kebutuhan barang atau jasa yang Anda cari.",
                style: Get.textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              
              // --- Form Fields ---
              TextFormField(
                controller: controller.titleC,
                decoration: _inputDecoration("Judul Kebutuhan", FontAwesomeIcons.pen),
                validator: (v) => (v == null || v.isEmpty) ? "Judul wajib diisi" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: controller.categoryC,
                decoration: _inputDecoration("Kategori (cth: Jasa, Pakan)", FontAwesomeIcons.tags),
                validator: (v) => (v == null || v.isEmpty) ? "Kategori wajib diisi" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: controller.budgetC,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: _inputDecoration("Estimasi Budget (Rp) (Opsional)", FontAwesomeIcons.sackDollar),
                // Tidak ada validator karena opsional
              ),
              const SizedBox(height: 16),
              
              // --- Pilihan Tanggal Deadline ---
              Obx(() => InkWell(
                onTap: () => controller.pickDeadlineDate(context),
                child: InputDecorator(
                  decoration: _inputDecoration("Batas Waktu Penawaran", FontAwesomeIcons.calendarCheck),
                  child: Text(
                    controller.formattedDeadline,
                    style: Get.textTheme.bodyLarge?.copyWith(
                      color: controller.selectedDeadline.value == null 
                          ? AppColors.textLight
                          : AppColors.textDark,
                    ),
                  ),
                ),
              )),
              
              const SizedBox(height: 16),
              TextFormField(
                controller: controller.descriptionC,
                decoration: _inputDecoration("Deskripsi Rinci Kebutuhan", null, alignTop: true),
                maxLines: 6,
                validator: (v) => (v == null || v.isEmpty) ? "Deskripsi wajib diisi" : null,
              ),
            ],
          ),
        ),
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

  Widget _buildBottomSubmitButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Obx(() => FilledButton(
        onPressed: controller.isLoading.value ? null : controller.submitRequest,
        child: controller.isLoading.value
            ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white))
            : const Text("Publikasikan Permintaan"),
      )),
    );
  }
}