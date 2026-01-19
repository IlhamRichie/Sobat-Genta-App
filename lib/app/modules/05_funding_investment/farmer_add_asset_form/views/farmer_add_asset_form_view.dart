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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Tambah Aset Baru",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      bottomNavigationBar: _buildBottomSubmitBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader("Kategori Aset"),
              const SizedBox(height: 16),
              _buildAssetTypeSelector(),
              
              const SizedBox(height: 32),
              _buildSectionHeader("Detail Aset"),
              const SizedBox(height: 16),
              
              _buildInputLabel("Nama Aset"),
              _buildTextField(
                controller: controller.nameC,
                hint: "Contoh: Lahan Cabai Magelang",
                icon: FontAwesomeIcons.penToSquare,
                validator: (v) => (v == null || v.isEmpty) ? "Nama aset wajib diisi" : null,
              ),
              const SizedBox(height: 20),
              
              _buildInputLabel("Lokasi"),
              _buildTextField(
                controller: controller.locationC,
                hint: "Kabupaten/Kota",
                icon: FontAwesomeIcons.locationDot,
                validator: (v) => (v == null || v.isEmpty) ? "Lokasi wajib diisi" : null,
              ),
              const SizedBox(height: 20),
              
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInputLabel("Luas (m²/Ekor)"),
                        _buildTextField(
                          controller: controller.areaC,
                          hint: "0",
                          icon: FontAwesomeIcons.rulerCombined,
                          keyboardType: TextInputType.number,
                          validator: (v) => (v == null || v.isEmpty) ? "Wajib diisi" : null,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() => _buildInputLabel(
                          controller.selectedAssetType.value == 'PERTANIAN' ? "Komoditas" : "Jenis Ternak"
                        )),
                        Obx(() => _buildTextField(
                          controller: controller.selectedAssetType.value == 'PERTANIAN' 
                              ? controller.cropTypeC 
                              : controller.livestockTypeC,
                          hint: controller.selectedAssetType.value == 'PERTANIAN' ? "Padi/Jagung" : "Sapi/Kambing",
                          icon: controller.selectedAssetType.value == 'PERTANIAN' 
                              ? FontAwesomeIcons.seedling 
                              : FontAwesomeIcons.cow,
                          validator: (v) => (v == null || v.isEmpty) ? "Wajib diisi" : null,
                        )),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              _buildSectionHeader("Dokumen Pendukung"),
              const SizedBox(height: 16),
              
              Obx(() => _buildPhotoUploadCard(
                title: "Foto Aset/Lahan",
                file: controller.landPhotoFile.value,
                onTap: () => _showImagePicker(controller.landPhotoFile),
              )),
              const SizedBox(height: 16),
              Obx(() => _buildPhotoUploadCard(
                title: "Foto Sertifikat/Surat",
                file: controller.certificateFile.value,
                onTap: () => _showImagePicker(controller.certificateFile),
              )),
              
              // Spacer
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  /// Header Section (Judul Kecil)
  Widget _buildSectionHeader(String title) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        color: Colors.grey.shade500,
        fontWeight: FontWeight.bold,
        fontSize: 12,
        letterSpacing: 1.0,
      ),
    );
  }

  /// Label Input
  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF2D3436), fontSize: 14),
      ),
    );
  }

  /// Custom Text Field Modern
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.normal),
        filled: true,
        fillColor: const Color(0xFFF9F9F9),
        prefixIcon: Padding(
          padding: const EdgeInsets.all(12),
          child: FaIcon(icon, size: 18, color: Colors.grey.shade400),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14), 
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5)
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14), 
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5)
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
      validator: validator,
    );
  }

  /// Toggle Button untuk Tipe Aset
  Widget _buildAssetTypeSelector() {
    return Obx(() {
      bool isFarming = controller.selectedAssetType.value == 'PERTANIAN';
      return Container(
        height: 55,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(child: _buildToggleItem("Pertanian", FontAwesomeIcons.wheatAwn, isFarming, () => controller.setAssetType('PERTANIAN'))),
            Expanded(child: _buildToggleItem("Peternakan", FontAwesomeIcons.cow, !isFarming, () => controller.setAssetType('PETERNAKAN'))),
          ],
        ),
      );
    });
  }

  Widget _buildToggleItem(String label, IconData icon, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isActive ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))] : [],
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(icon, size: 16, color: isActive ? AppColors.primary : Colors.grey),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isActive ? Colors.black87 : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Upload Card (Dashed Border)
  Widget _buildPhotoUploadCard({required String title, required File? file, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 160,
        width: double.infinity,
        decoration: BoxDecoration(
          color: file != null ? Colors.white : const Color(0xFFF9F9F9),
          borderRadius: BorderRadius.circular(16),
          border: file != null 
              ? Border.all(color: Colors.grey.shade300)
              : Border.all(color: Colors.grey.shade300, style: BorderStyle.solid), // Harusnya dashed, tapi solid fine
          image: file != null 
              ? DecorationImage(image: FileImage(file), fit: BoxFit.cover)
              : null,
        ),
        child: file == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.grey.shade200, shape: BoxShape.circle),
                    child: Icon(Icons.camera_alt_rounded, color: Colors.grey.shade500),
                  ),
                  const SizedBox(height: 12),
                  Text(title, style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.w600)),
                ],
              )
            : Align(
                alignment: Alignment.topRight,
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: const Icon(Icons.edit, size: 16, color: Colors.black87),
                ),
              ),
      ),
    );
  }

  /// Sticky Bottom Bar
  Widget _buildBottomSubmitBar() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: Obx(() => ElevatedButton(
            onPressed: controller.isLoading.value ? null : controller.submitAsset,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
            child: controller.isLoading.value
                ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                : const Text("Simpan & Daftarkan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          )),
        ),
      ),
    );
  }

  void _showImagePicker(Rx<File?> target) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppColors.primary),
              title: const Text("Ambil Foto"),
              onTap: () {
                controller.pickImage(ImageSource.camera, target);
                Get.back();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: AppColors.primary),
              title: const Text("Pilih dari Galeri"),
              onTap: () {
                controller.pickImage(ImageSource.gallery, target);
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }
}