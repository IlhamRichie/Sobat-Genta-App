// lib/app/modules/farmer_add_asset_form/controllers/farmer_add_asset_form_controller.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../data/repositories/abstract/asset_repository.dart';

class FarmerAddAssetFormController extends GetxController {
  
  // --- DEPENDENCIES ---
  final IAssetRepository _assetRepo = Get.find<IAssetRepository>();
  final ImagePicker _picker = ImagePicker();

  // --- FORM KEY & STATE ---
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final RxBool isLoading = false.obs;

  // --- DYNAMIC FORM STATE ---
  // Ini adalah state kunci untuk form dinamis kita
  final RxString selectedAssetType = 'PERTANIAN'.obs; // Default

  // --- TEXT CONTROLLERS ---
  final TextEditingController nameC = TextEditingController();
  final TextEditingController locationC = TextEditingController();
  final TextEditingController areaC = TextEditingController();
  final TextEditingController cropTypeC = TextEditingController(); // Untuk Pertanian
  final TextEditingController livestockTypeC = TextEditingController(); // Untuk Peternakan

  // --- FILE STATES ---
  final Rx<File?> certificateFile = Rx<File?>(null);
  final Rx<File?> landPhotoFile = Rx<File?>(null);

  @override
  void onClose() {
    nameC.dispose();
    locationC.dispose();
    areaC.dispose();
    cropTypeC.dispose();
    livestockTypeC.dispose();
    super.onClose();
  }

  /// Mengubah tipe aset
  void setAssetType(String type) {
    selectedAssetType.value = type;
  }
  
  /// Helper untuk mengambil gambar (sama seperti KYC)
  Future<void> pickImage(ImageSource source, Rx<File?> targetFile) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source, imageQuality: 80);
      if (pickedFile != null) {
        targetFile.value = File(pickedFile.path);
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal mengambil gambar: $e");
    }
  }

  /// Aksi utama submit aset
  Future<void> submitAsset() async {
    // 1. Validasi form
    if (!formKey.currentState!.validate()) {
      return;
    }
    
    // 2. Validasi file
    if (certificateFile.value == null || landPhotoFile.value == null) {
      Get.snackbar("Gagal", "Foto Lahan dan Foto Sertifikat wajib diisi.");
      return;
    }

    isLoading.value = true;
    
    try {
      // 3. Siapkan data
      // Kita gunakan 'details_json' untuk menyimpan data dinamis
      String details = selectedAssetType.value == 'PERTANIAN' 
          ? cropTypeC.text 
          : livestockTypeC.text;
          
      final Map<String, dynamic> textData = {
        'name': nameC.text,
        'location': locationC.text,
        'area_size': areaC.text,
        'asset_type': selectedAssetType.value,
        'details_json': {
          'jenis': details,
          // kita bisa tambahkan field dinamis lain di sini
        },
      };
      
      final List<File> files = [
        landPhotoFile.value!,
        certificateFile.value!,
      ];

      // 4. Kirim ke repository
      await _assetRepo.addAsset(textData, files);
      
      showTopSnackBar(
        Overlay.of(Get.context!),
        CustomSnackBar.success(
          message: "Aset berhasil ditambahkan dan sedang menunggu verifikasi.",
          backgroundColor: Colors.green.shade700,
        ),
      );

      // 5. Kembali ke halaman list, kirim 'result'
      Get.back(result: 'success');

    } catch (e) {
      Get.snackbar("Error", "Gagal menambahkan aset: $e");
    } finally {
      isLoading.value = false;
    }
  }
}