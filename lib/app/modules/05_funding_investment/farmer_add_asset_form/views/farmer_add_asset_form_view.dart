// lib/app/modules/farmer_add_asset_form/views/farmer_add_asset_form_view.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../theme/app_colors.dart';
import '../controllers/farmer_add_asset_form_controller.dart';

class FarmerAddAssetFormView extends GetView<FarmerAddAssetFormController> {
  const FarmerAddAssetFormView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftarkan Aset Baru"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildAssetTypeSelector(),
              const SizedBox(height: 24),
              _buildCommonFields(),
              const SizedBox(height: 16),
              
              // --- FORM DINAMIS ---
              Obx(() => _buildDynamicField()),
              
              const SizedBox(height: 24),
              _buildImageUploaders(),
              const SizedBox(height: 32),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  /// Pilihan Tipe Aset (Pertanian / Peternakan)
  Widget _buildAssetTypeSelector() {
    return Obx(() => SegmentedButton<String>(
          style: SegmentedButton.styleFrom(
            padding: const EdgeInsets.all(12),
            selectedBackgroundColor: AppColors.primary.withOpacity(0.1),
            selectedForegroundColor: AppColors.primary,
          ),
          segments: const [
            ButtonSegment(
              value: 'PERTANIAN',
              label: Text("Pertanian"),
              icon: FaIcon(FontAwesomeIcons.leaf),
            ),
            ButtonSegment(
              value: 'PETERNAKAN',
              label: Text("Peternakan"),
              icon: FaIcon(FontAwesomeIcons.cow),
            ),
          ],
          selected: {controller.selectedAssetType.value},
          onSelectionChanged: (Set<String> newSelection) {
            controller.setAssetType(newSelection.first);
          },
        ));
  }

  /// Field yang selalu ada
  Widget _buildCommonFields() {
    return Column(
      children: [
        TextFormField(
          controller: controller.nameC,
          decoration: _inputDecoration('Nama Aset (Lahan/Kandang)', FontAwesomeIcons.signature),
          validator: (v) => (v == null || v.isEmpty) ? "Wajib diisi" : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: controller.locationC,
          decoration: _inputDecoration('Lokasi (Kabupaten/Kota)', FontAwesomeIcons.mapLocationDot),
          validator: (v) => (v == null || v.isEmpty) ? "Wajib diisi" : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: controller.areaC,
          keyboardType: TextInputType.number,
          decoration: _inputDecoration('Luas (Hektar / m²)', FontAwesomeIcons.rulerCombined),
          validator: (v) => (v == null || v.isEmpty) ? "Wajib diisi" : null,
        ),
      ],
    );
  }

  /// Field yang berubah berdasarkan Tipe Aset
  Widget _buildDynamicField() {
    if (controller.selectedAssetType.value == 'PERTANIAN') {
      return TextFormField(
        controller: controller.cropTypeC,
        decoration: _inputDecoration('Jenis Tanaman (cth: Bawang Merah)', FontAwesomeIcons.seedling),
        validator: (v) => (v == null || v.isEmpty) ? "Wajib diisi" : null,
      );
    } else {
      return TextFormField(
        controller: controller.livestockTypeC,
        decoration: _inputDecoration('Jenis Ternak (cth: Sapi Perah)', FontAwesomeIcons.hippo),
        validator: (v) => (v == null || v.isEmpty) ? "Wajib diisi" : null,
      );
    }
  }

  /// Bagian Upload Foto
  Widget _buildImageUploaders() {
    return Column(
      children: [
        Obx(() => _buildImagePickerBox(
              label: "Foto Lahan / Kandang",
              file: controller.landPhotoFile.value,
              onTap: () => _showImagePickerModal(controller.landPhotoFile),
            )),
        const SizedBox(height: 16),
        Obx(() => _buildImagePickerBox(
              label: "Foto Sertifikat / Surat Garapan",
              file: controller.certificateFile.value,
              onTap: () => _showImagePickerModal(controller.certificateFile),
            )),
      ],
    );
  }

  /// Tombol Submit
  Widget _buildSubmitButton() {
    return Obx(() => FilledButton(
          onPressed: controller.isLoading.value ? null : controller.submitAsset,
          child: controller.isLoading.value
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                )
              : const Text('Simpan Aset'),
        ));
  }
  
  // --- HELPER WIDGETS (Sama seperti KYC) ---
  
  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: FaIcon(icon, size: 20),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  Widget _buildImagePickerBox({
    required String label,
    required File? file,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.greyLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade400, style: BorderStyle.solid),
          image: file != null
              ? DecorationImage(image: FileImage(file), fit: BoxFit.cover)
              : null,
        ),
        child: file == null
            ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                const FaIcon(FontAwesomeIcons.camera, color: AppColors.textLight),
                const SizedBox(height: 8),
                Text(label, style: TextStyle(color: AppColors.textLight), textAlign: TextAlign.center),
              ],))
            : Align(
                alignment: Alignment.topRight,
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), shape: BoxShape.circle),
                  child: const Icon(Icons.check_circle, color: Colors.white),
                ),
              ),
      ),
    );
  }

  void _showImagePickerModal(Rx<File?> targetFile) {
    Get.bottomSheet(
      Container(
        color: AppColors.background,
        child: Wrap(children: <Widget>[
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.camera),
            title: const Text('Kamera'),
            onTap: () { controller.pickImage(ImageSource.camera, targetFile); Get.back(); },
          ),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.solidImage),
            title: const Text('Galeri'),
            onTap: () { controller.pickImage(ImageSource.gallery, targetFile); Get.back(); },
          ),
        ],),
      ),
    );
  }
}