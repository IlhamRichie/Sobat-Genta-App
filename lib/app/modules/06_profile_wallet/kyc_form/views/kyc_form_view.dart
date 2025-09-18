// lib/app/modules/kyc_form/views/kyc_form_view.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../data/models/user_model.dart';
import '../../../../theme/app_colors.dart';
import '../controllers/kyc_form_controller.dart';

class KycFormView extends GetView<KycFormController> {
  const KycFormView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verifikasi Akun (KYC)"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              
              // --- Bagian 1: Field Umum (Semua Role) ---
              _buildSectionTitle("1. Data Diri (Wajib)"),
              _buildCommonFields(),
              const SizedBox(height: 24),

              // --- Bagian 2: Field Spesifik Peran ---
              // Gunakan switch untuk me-render UI dinamis
              ..._buildRoleSpecificFields(),

              const SizedBox(height: 32),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }
  
  // ... (Widget helper lainnya di bawah) ...
  
  List<Widget> _buildRoleSpecificFields() {
    switch (controller.userRole) {
      case UserRole.INVESTOR:
        return [
          _buildSectionTitle("2. Data Finansial (Wajib Investor)"),
          _buildInvestorFields(),
        ];
      case UserRole.EXPERT:
        return [
          _buildSectionTitle("2. Data Profesional (Wajib Pakar)"),
          _buildExpertFields(),
        ];
      case UserRole.FARMER:
      default:
        // Petani tidak punya field tambahan
        return [const SizedBox.shrink()];
    }
  }

  // --- WIDGET BUILDER ---

  Widget _buildHeader() {
    return Text(
      "Harap isi data berikut dengan benar untuk memverifikasi akun Anda.",
      style: Get.textTheme.bodyMedium?.copyWith(fontSize: 16),
      textAlign: TextAlign.center,
    );
  }
  
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: Get.textTheme.titleLarge?.copyWith(fontSize: 18, color: AppColors.primary),
      ),
    );
  }

  /// Field yang wajib diisi semua role
  Widget _buildCommonFields() {
    return Column(
      children: [
        TextFormField(
          controller: controller.ktpNumberC,
          keyboardType: TextInputType.number,
          decoration: _inputDecoration('Nomor KTP (NIK)', FontAwesomeIcons.idCard),
          validator: (v) => (v == null || v.isEmpty) ? "Wajib diisi" : null,
        ),
        const SizedBox(height: 16),
        Obx(() => _buildImagePickerBox(
              label: "Foto KTP",
              file: controller.ktpFile.value,
              onTap: () => _showImagePickerModal(controller.ktpFile),
            )),
        const SizedBox(height: 16),
        Obx(() => _buildImagePickerBox(
              label: "Swafoto (Selfie) dengan KTP",
              file: controller.selfieFile.value,
              onTap: () => _showImagePickerModal(controller.selfieFile),
            )),
      ],
    );
  }

  /// Field khusus Investor
  Widget _buildInvestorFields() {
    return Column(
      children: [
        TextFormField(
          controller: controller.npwpC,
          keyboardType: TextInputType.number,
          decoration: _inputDecoration('Nomor NPWP', FontAwesomeIcons.fileLines),
          validator: (v) => (v == null || v.isEmpty) ? "Wajib diisi" : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: controller.bankNameC,
          keyboardType: TextInputType.text,
          decoration: _inputDecoration('Nama Bank', FontAwesomeIcons.buildingColumns),
          validator: (v) => (v == null || v.isEmpty) ? "Wajib diisi" : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: controller.bankAccountC,
          keyboardType: TextInputType.number,
          decoration: _inputDecoration('Nomor Rekening', FontAwesomeIcons.hashtag),
          validator: (v) => (v == null || v.isEmpty) ? "Wajib diisi" : null,
        ),
      ],
    );
  }

  /// Field khusus Pakar
  Widget _buildExpertFields() {
    return Column(
      children: [
        TextFormField(
          controller: controller.specializationC,
          decoration: _inputDecoration('Spesialisasi (cth: Dokter Hewan)', FontAwesomeIcons.userDoctor),
          validator: (v) => (v == null || v.isEmpty) ? "Wajib diisi" : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: controller.sipNumberC,
          decoration: _inputDecoration('Nomor SIP (Surat Izin Praktik)', FontAwesomeIcons.idBadge),
          validator: (v) => (v == null || v.isEmpty) ? "Wajib diisi" : null,
        ),
        const SizedBox(height: 16),
        Obx(() => _buildImagePickerBox(
              label: "Upload Ijazah",
              file: controller.ijazahFile.value,
              onTap: () => _showImagePickerModal(controller.ijazahFile),
            )),
        const SizedBox(height: 16),
        Obx(() => _buildImagePickerBox(
              label: "Upload SIP",
              file: controller.sipFile.value,
              onTap: () => _showImagePickerModal(controller.sipFile),
            )),
      ],
    );
  }

  /// Widget reusable untuk box upload gambar
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
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const FaIcon(FontAwesomeIcons.camera, color: AppColors.textLight),
                    const SizedBox(height: 8),
                    Text(label, style: TextStyle(color: AppColors.textLight)),
                  ],
                ),
              )
            : Align(
                alignment: Alignment.topRight,
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_circle, color: Colors.white),
                ),
              ),
      ),
    );
  }

  /// Modal untuk memilih sumber gambar
  void _showImagePickerModal(Rx<File?> targetFile) {
    Get.bottomSheet(
      Container(
        color: AppColors.background,
        child: Wrap(
          children: <Widget>[
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.camera),
              title: const Text('Kamera'),
              onTap: () {
                controller.pickImage(ImageSource.camera, targetFile);
                Get.back();
              },
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.solidImage),
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
  
  /// Helper untuk dekorasi input
  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: FaIcon(icon, size: 20),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  /// Tombol Submit
  Widget _buildSubmitButton() {
    return Obx(() => FilledButton(
          onPressed: controller.isLoading.value ? null : controller.submitKyc,
          child: controller.isLoading.value
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                )
              : const Text('Kirim Data Verifikasi'),
        ));
  }
}