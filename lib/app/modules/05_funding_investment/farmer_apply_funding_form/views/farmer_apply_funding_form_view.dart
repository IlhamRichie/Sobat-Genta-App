// lib/app/modules/farmer_apply_funding_form/views/farmer_apply_funding_form_view.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../theme/app_colors.dart';
import '../controllers/farmer_apply_funding_form_controller.dart';

class FarmerApplyFundingFormView extends GetView<FarmerApplyFundingFormController> {
  const FarmerApplyFundingFormView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Formulir Pengajuan Dana"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAssetHeader(),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildSectionTitle("Detail Proyek"),
                    _buildProjectFields(),
                    const SizedBox(height: 24),
                    _buildSectionTitle("Foto Utama Proyek"),
                    Obx(() => _buildImagePickerBox(
                      label: "Upload Foto Proyek",
                      file: controller.projectImageFile.value,
                      onTap: () => _showImagePickerModal(),
                    )),
                    const SizedBox(height: 24),
                    
                    // --- BAGIAN DINAMIS RAB ---
                    _buildRabSection(),
                    
                    const SizedBox(height: 32),
                    _buildSubmitButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Menampilkan aset mana yang sedang diajukan
  Widget _buildAssetHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.primary.withOpacity(0.05),
      child: ListTile(
        leading: const FaIcon(FontAwesomeIcons.mapLocationDot, color: AppColors.primary),
        title: const Text("Mengajukan untuk Aset:", style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          "${controller.asset.name} (${controller.asset.location})",
          style: const TextStyle(fontSize: 16),
        ),
        dense: true,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: Get.textTheme.titleLarge?.copyWith(fontSize: 18));
  }

  /// Field formulir standar
  Widget _buildProjectFields() {
    return Column(
      children: [
        const SizedBox(height: 16),
        TextFormField(
          controller: controller.titleC,
          decoration: _inputDecoration('Judul Proyek (cth: Tanam Bawang Merah Siklus 1)', FontAwesomeIcons.penToSquare),
          validator: (v) => (v == null || v.isEmpty) ? "Wajib diisi" : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: controller.targetFundC,
          keyboardType: TextInputType.number,
          decoration: _inputDecoration('Target Dana (Rp)', FontAwesomeIcons.sackDollar),
          validator: (v) => (v == null || v.isEmpty) ? "Wajib diisi" : null,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller.durationC,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration('Durasi (Hari)', FontAwesomeIcons.calendarDays),
                validator: (v) => (v == null || v.isEmpty) ? "Wajib diisi" : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: controller.roiC,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration('Estimasi ROI (%)', FontAwesomeIcons.percent),
                validator: (v) => (v == null || v.isEmpty) ? "Wajib diisi" : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: controller.descriptionC,
          decoration: _inputDecoration('Deskripsi Singkat Proyek', FontAwesomeIcons.alignLeft, alignTop: true),
          maxLines: 4,
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
        const SizedBox(height: 8),
        // Gunakan Obx untuk me-render list dinamisnya
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
          icon: const FaIcon(FontAwesomeIcons.plus, size: 16),
          label: const Text("Tambah Rincian RAB"),
        ),
      ],
    );
  }

  /// Satu baris item RAB
  Widget _buildRabItemRow(int index) {
    final itemControllers = controller.rabItemsList[index];
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: TextFormField(
              controller: itemControllers['name'],
              decoration: _inputDecoration('Nama Item', null, dense: true),
              validator: (v) => (v == null || v.isEmpty) ? "Wajib" : null,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: TextFormField(
              controller: itemControllers['cost'],
              keyboardType: TextInputType.number,
              decoration: _inputDecoration('Biaya (Rp)', null, dense: true),
              validator: (v) => (v == null || v.isEmpty) ? "Wajib" : null,
            ),
          ),
          // Hanya tampilkan tombol hapus jika item > 1
          if (controller.rabItemsList.length > 1)
            IconButton(
              icon: Icon(Icons.remove_circle_outline, color: Colors.red.shade700),
              onPressed: () => controller.removeRabItem(index),
            )
          else
            const SizedBox(width: 48), // Placeholder
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Obx(() => FilledButton(
          onPressed: controller.isLoading.value ? null : controller.submitProposal,
          child: controller.isLoading.value
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                )
              : const Text('Kirim Proposal'),
        ));
  }
  
  // --- HELPER UNTUK GAMBAR & INPUT ---
  
  void _showImagePickerModal() {
    Get.bottomSheet(
      Container(
        color: AppColors.background,
        child: Wrap(children: <Widget>[
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.camera),
            title: const Text('Kamera'),
            onTap: () { controller.pickImage(ImageSource.camera); Get.back(); },
          ),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.solidImage),
            title: const Text('Galeri'),
            onTap: () { controller.pickImage(ImageSource.gallery); Get.back(); },
          ),
        ],),
      ),
    );
  }

  Widget _buildImagePickerBox({required String label, File? file, required VoidCallback onTap}) {
    // (Bisa copy-paste widget _buildImagePickerBox dari FarmerAddAssetFormView/KycFormView)
     return InkWell(
      onTap: onTap,
      child: Container(
        height: 150, width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.greyLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade400),
          image: file != null ? DecorationImage(image: FileImage(file), fit: BoxFit.cover) : null,
        ),
        child: file == null
            ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                const FaIcon(FontAwesomeIcons.camera, color: AppColors.textLight),
                const SizedBox(height: 8),
                Text(label, style: TextStyle(color: AppColors.textLight), textAlign: TextAlign.center),
              ],))
            : Align(alignment: Alignment.topRight, child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), shape: BoxShape.circle),
                child: const Icon(Icons.check_circle, color: Colors.white),
              )),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData? icon, {bool dense = false, bool alignTop = false}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: icon != null ? FaIcon(icon, size: 20) : null,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      isDense: dense,
      contentPadding: dense ? const EdgeInsets.symmetric(horizontal: 12, vertical: 14) : null,
      alignLabelWithHint: alignTop,
    );
  }
}