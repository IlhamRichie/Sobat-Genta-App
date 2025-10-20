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
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      bottomNavigationBar: _buildBottomSubmitButton(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Buat permintaan tender untuk mendapatkan penawaran terbaik dari pemasok.",
                style: Get.textTheme.bodyLarge?.copyWith(color: AppColors.textLight),
              ),
              const SizedBox(height: 24),
              
              // --- Form Fields ---
              _buildTextFormField(
                controller: controller.titleC,
                label: "Judul Kebutuhan",
                icon: FontAwesomeIcons.penToSquare,
                validator: (v) => (v == null || v.isEmpty) ? "Judul wajib diisi" : null,
              ),
              const SizedBox(height: 16),
              _buildTextFormField(
                controller: controller.categoryC,
                label: "Kategori (cth: Jasa, Pakan)",
                icon: FontAwesomeIcons.tags,
                validator: (v) => (v == null || v.isEmpty) ? "Kategori wajib diisi" : null,
              ),
              const SizedBox(height: 16),
              _buildTextFormField(
                controller: controller.budgetC,
                label: "Estimasi Budget (Rp) (Opsional)",
                icon: FontAwesomeIcons.sackDollar,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 16),
              
              // --- Pilihan Tanggal Deadline ---
              _buildDeadlinePicker(context),
              
              const SizedBox(height: 16),
              _buildTextFormField(
                controller: controller.descriptionC,
                label: "Deskripsi Rinci Kebutuhan",
                icon: FontAwesomeIcons.fileLines,
                maxLines: 6,
                alignTop: true,
                validator: (v) => (v == null || v.isEmpty) ? "Deskripsi wajib diisi" : null,
              ),
            ],
          ),
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
        "Buat Tender",
        style: Get.textTheme.headlineSmall?.copyWith(
          color: AppColors.textDark,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: false,
    );
  }

  /// Helper untuk Input Form
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    int? maxLines = 1,
    bool alignTop = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: FaIcon(icon, size: 20, color: AppColors.textLight),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.greyLight)),
        alignLabelWithHint: alignTop,
      ),
      validator: validator,
    );
  }

  /// Pilihan Tanggal Deadline (Didesain Ulang)
  Widget _buildDeadlinePicker(BuildContext context) {
    return Obx(() => InkWell(
      onTap: () => controller.pickDeadlineDate(context),
      borderRadius: BorderRadius.circular(16),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: "Batas Waktu Penawaran",
          prefixIcon: const FaIcon(FontAwesomeIcons.calendarCheck, size: 20, color: AppColors.textLight),
          suffixIcon: const FaIcon(FontAwesomeIcons.chevronDown, size: 16, color: AppColors.textLight),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.greyLight)),
        ),
        child: Text(
          controller.formattedDeadline,
          style: Get.textTheme.bodyLarge?.copyWith(
            color: controller.selectedDeadline.value == null 
                ? AppColors.textLight.withOpacity(0.8)
                : AppColors.textDark,
          ),
        ),
      ),
    ));
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
        onPressed: controller.isLoading.value ? null : controller.submitRequest,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
        ),
        child: controller.isLoading.value
            ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : const Text("Publikasikan Permintaan", style: TextStyle(fontWeight: FontWeight.bold)),
      )),
    );
  }
}