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
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSectionTitle("Jenis Aset"),
              const SizedBox(height: 12),
              _buildAssetTypeSelector(),
              const SizedBox(height: 32),
              
              _buildSectionTitle("Informasi Utama"),
              const SizedBox(height: 16),
              _buildCommonFields(),
              const SizedBox(height: 16),
              
              Obx(() => _buildDynamicField()),
              const SizedBox(height: 32),
              
              _buildSectionTitle("Dokumen & Foto"),
              const SizedBox(height: 16),
              _buildImageUploaders(),
              
              const SizedBox(height: 48),
              _buildSubmitButton(),
              const SizedBox(height: 24),
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
        "Daftarkan Aset",
        style: Get.textTheme.headlineSmall?.copyWith(
          color: AppColors.textDark,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: false,
    );
  }

  /// Pilihan Tipe Aset (Pertanian / Peternakan)
  Widget _buildAssetTypeSelector() {
    return Obx(() => Container(
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
      child: SegmentedButton<String>(
        style: SegmentedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          selectedBackgroundColor: AppColors.primary.withOpacity(0.1),
          selectedForegroundColor: AppColors.primary,
          // Hapus border luar
          side: const BorderSide(style: BorderStyle.none),
          // Hapus efek shadow
          elevation: 0,
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
      ),
    ));
  }

  /// Field yang selalu ada
  Widget _buildCommonFields() {
    return Column(
      children: [
        _buildTextFormField(
          controller: controller.nameC,
          label: 'Nama Aset (Lahan/Kandang)',
          icon: FontAwesomeIcons.signature,
          validator: (v) => (v == null || v.isEmpty) ? "Wajib diisi" : null,
        ),
        const SizedBox(height: 16),
        _buildTextFormField(
          controller: controller.locationC,
          label: 'Lokasi (Kabupaten/Kota)',
          icon: FontAwesomeIcons.mapLocationDot,
          validator: (v) => (v == null || v.isEmpty) ? "Wajib diisi" : null,
        ),
        const SizedBox(height: 16),
        _buildTextFormField(
          controller: controller.areaC,
          label: 'Luas (Hektar / m²)',
          icon: FontAwesomeIcons.rulerCombined,
          keyboardType: TextInputType.number,
          validator: (v) => (v == null || v.isEmpty) ? "Wajib diisi" : null,
        ),
      ],
    );
  }

  /// Field yang berubah berdasarkan Tipe Aset
  Widget _buildDynamicField() {
    if (controller.selectedAssetType.value == 'PERTANIAN') {
      return _buildTextFormField(
        controller: controller.cropTypeC,
        label: 'Jenis Tanaman (cth: Bawang Merah)',
        icon: FontAwesomeIcons.seedling,
        validator: (v) => (v == null || v.isEmpty) ? "Wajib diisi" : null,
      );
    } else {
      return _buildTextFormField(
        controller: controller.livestockTypeC,
        label: 'Jenis Ternak (cth: Sapi Perah)',
        icon: FontAwesomeIcons.hippo,
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
              : const Text(
                  'Simpan Aset',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
        ));
  }

  // --- HELPER WIDGETS (Didesain Ulang) ---
  
  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: Get.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.textLight.withOpacity(0.8),
          letterSpacing: 0.5,
        ),
      ),
    );
  }
  
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: FaIcon(icon, size: 20, color: AppColors.textLight),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.greyLight)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.greyLight)),
      ),
      validator: validator,
    );
  }
  
  Widget _buildImagePickerBox({
    required String label,
    required File? file,
    required VoidCallback onTap,
  }) {
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

  void _showImagePickerModal(Rx<File?> targetFile) {
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
              onTap: () {
                controller.pickImage(ImageSource.camera, targetFile);
                Get.back();
              },
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.solidImage, color: AppColors.primary),
              title: const Text('Galeri'),
              onTap: () {
                controller.pickImage(ImageSource.gallery, targetFile);
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }
}