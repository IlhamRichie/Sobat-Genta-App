// lib/app/modules/farmer_apply_funding_form/views/farmer_apply_funding_form_view.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../theme/app_colors.dart';
import '../controllers/farmer_apply_funding_form_controller.dart';
import 'package:intl/intl.dart';

class FarmerApplyFundingFormView extends GetView<FarmerApplyFundingFormController> {
  const FarmerApplyFundingFormView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAssetHeader(),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildSectionTitle("Detail Proyek"),
                    const SizedBox(height: 16),
                    _buildProjectFields(),
                    const SizedBox(height: 32),
                    
                    _buildSectionTitle("Foto Utama Proyek"),
                    const SizedBox(height: 16),
                    Obx(() => _buildImagePickerBox(
                          label: "Upload Foto Proyek",
                          file: controller.projectImageFile.value,
                          onTap: () => _showImagePickerModal(),
                        )),
                    const SizedBox(height: 32),
                    
                    _buildRabSection(),
                    
                    const SizedBox(height: 48),
                    _buildSubmitButton(),
                    const SizedBox(height: 24),
                  ],
                ),
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
      title: Text(
        "Ajukan Pendanaan",
        style: Get.textTheme.headlineSmall?.copyWith(
          color: AppColors.textDark,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: false,
    );
  }

  /// Menampilkan aset mana yang sedang diajukan
  Widget _buildAssetHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Ajukan Dana untuk Aset:",
            style: Get.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const FaIcon(FontAwesomeIcons.mapLocationDot, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "${controller.asset.name} (${controller.asset.location})",
                  style: Get.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Get.textTheme.titleLarge?.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  /// Field formulir standar
  Widget _buildProjectFields() {
    return Column(
      children: [
        _buildTextFormField(
          controller: controller.titleC,
          label: 'Judul Proyek (cth: Tanam Bawang Merah Siklus 1)',
          icon: FontAwesomeIcons.penToSquare,
          validator: (v) => (v == null || v.isEmpty) ? "Wajib diisi" : null,
        ),
        const SizedBox(height: 16),
        _buildTextFormField(
          controller: controller.targetFundC,
          label: 'Target Dana (Rp)',
          icon: FontAwesomeIcons.sackDollar,
          keyboardType: TextInputType.number,
          validator: (v) => (v == null || v.isEmpty) ? "Wajib diisi" : null,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildTextFormField(
                controller: controller.durationC,
                label: 'Durasi (Hari)',
                icon: FontAwesomeIcons.calendarDays,
                keyboardType: TextInputType.number,
                validator: (v) => (v == null || v.isEmpty) ? "Wajib diisi" : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextFormField(
                controller: controller.roiC,
                label: 'Estimasi ROI (%)',
                icon: FontAwesomeIcons.percent,
                keyboardType: TextInputType.number,
                validator: (v) => (v == null || v.isEmpty) ? "Wajib diisi" : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildTextFormField(
          controller: controller.descriptionC,
          label: 'Deskripsi Singkat Proyek',
          icon: FontAwesomeIcons.alignLeft,
          maxLines: 4,
          alignTop: true,
          validator: (v) => (v == null || v.isEmpty) ? "Wajib diisi" : null,
        ),
      ],
    );
  }

  /// Bagian untuk Form RAB Dinamis
  Widget _buildRabSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Rencana Anggaran Biaya (RAB)"),
        const SizedBox(height: 16),
        Container(
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
            children: [
              Obx(() => Column(
                    children: [
                      ...List.generate(
                        controller.rabItemsList.length,
                        (index) => _buildRabItemRow(index),
                      ),
                    ],
                  )),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: controller.addRabItem,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                icon: const FaIcon(FontAwesomeIcons.plus, size: 16),
                label: const Text("Tambah Rincian RAB"),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Obx(() {
          double totalCost = controller.calculateTotalRab();
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Biaya RAB",
                  style: Get.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(totalCost),
                  style: Get.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  /// Satu baris item RAB
  Widget _buildRabItemRow(int index) {
    final itemControllers = controller.rabItemsList[index];
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: _buildTextFormField(
              controller: itemControllers['name']!,
              label: 'Nama Item',
              icon: null,
              validator: (v) => (v == null || v.isEmpty) ? "Wajib" : null,
              dense: true,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: _buildTextFormField(
              controller: itemControllers['cost']!,
              label: 'Biaya (Rp)',
              icon: null,
              keyboardType: TextInputType.number,
              validator: (v) => (v == null || v.isEmpty) ? "Wajib" : null,
              dense: true,
            ),
          ),
          if (controller.rabItemsList.length > 1)
            IconButton(
              icon: Icon(Icons.remove_circle_outline, color: Colors.red.shade700),
              onPressed: () => controller.removeRabItem(index),
            )
          else
            const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Obx(() => FilledButton(
          onPressed: controller.isLoading.value ? null : controller.submitProposal,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: controller.isLoading.value
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
              : const Text('Kirim Proposal', style: TextStyle(fontWeight: FontWeight.bold)),
        ));
  }

  // --- HELPER WIDGETS ---
  
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData? icon,
    required String? Function(String?) validator,
    int? maxLines = 1,
    TextInputType? keyboardType,
    bool dense = false,
    bool alignTop = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? FaIcon(icon, size: 20, color: AppColors.textLight) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.greyLight)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.greyLight)),
        isDense: dense,
        contentPadding: dense ? const EdgeInsets.symmetric(horizontal: 16, vertical: 14) : null,
        alignLabelWithHint: alignTop,
      ),
      validator: validator,
    );
  }
  
  Widget _buildImagePickerBox({required String label, File? file, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 180,
        width: double.infinity,
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
          image: file != null
              ? DecorationImage(image: FileImage(file), fit: BoxFit.cover)
              : null,
        ),
        child: file == null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const FaIcon(FontAwesomeIcons.camera, color: AppColors.textLight, size: 36),
                    const SizedBox(height: 12),
                    Text(
                      label,
                      style: Get.textTheme.bodyMedium?.copyWith(color: AppColors.textLight),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            : Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                  ),
                  child: Text(
                    "Gambar terpilih",
                    style: Get.textTheme.bodyMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
      ),
    );
  }

  void _showImagePickerModal() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Pilih Sumber Gambar",
              style: Get.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.camera, color: AppColors.primary),
              title: const Text('Kamera'),
              onTap: () { controller.pickImage(ImageSource.camera); Get.back(); },
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.solidImage, color: AppColors.primary),
              title: const Text('Galeri'),
              onTap: () { controller.pickImage(ImageSource.gallery); Get.back(); },
            ),
          ],
        ),
      ),
    );
  }
}