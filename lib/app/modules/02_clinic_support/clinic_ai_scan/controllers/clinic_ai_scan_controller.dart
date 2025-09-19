// lib/app/modules/clinic_ai_scan/controllers/clinic_ai_scan_controller.dart

import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:flutter/material.dart';

import '../../../../data/models/ai_diagnosis_model.dart';
import '../../../../data/repositories/abstract/ai_diagnosis_repository.dart';
import '../../../../routes/app_pages.dart'; // Untuk Overlay

class ClinicAiScanController extends GetxController {

  // --- DEPENDENCIES ---
  final IAiDiagnosisRepository _aiRepo = Get.find<IAiDiagnosisRepository>();
  final ImagePicker _picker = ImagePicker();

  // --- STATE MANAGEMENT ---
  final Rx<File?> imageToAnalyze = Rxn<File>();
  final RxBool isAnalyzing = false.obs;
  final Rx<AiDiagnosisModel?> diagnosisResult = Rxn<AiDiagnosisModel>();

  /// 1. Aksi untuk mengambil gambar (Kamera/Galeri)
  Future<void> pickImage(ImageSource source) async {
    // Reset state sebelumnya jika ada
    clearAnalysis(); 
    
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source, imageQuality: 85);
      if (pickedFile != null) {
        imageToAnalyze.value = File(pickedFile.path);
        // Langsung panggil analisis setelah gambar dipilih
        analyzeImage();
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal mengambil gambar: $e");
    }
  }

  /// 2. Aksi untuk menganalisis gambar (dipicu oleh pickImage)
  Future<void> analyzeImage() async {
    if (imageToAnalyze.value == null) return;

    isAnalyzing.value = true;
    diagnosisResult.value = null; // Hapus hasil lama
    
    try {
      // Panggil Repo (Fake Repo akan delay 3 detik)
      final result = await _aiRepo.analyzeImage(imageToAnalyze.value!, 'TANAMAN');
      diagnosisResult.value = result; // Simpan hasil
      
    } catch (e) {
      showTopSnackBar(
        Overlay.of(Get.context!),
        CustomSnackBar.error(message: "AI gagal menganalisis gambar: $e"),
      );
    } finally {
      isAnalyzing.value = false;
    }
  }

  /// 3. Aksi untuk reset/scan ulang
  void clearAnalysis() {
    imageToAnalyze.value = null;
    diagnosisResult.value = null;
    isAnalyzing.value = false;
  }
  
  /// 4. AKSI UPSELL (Kritis): Navigasi ke Pakar yang relevan
  void contactExpert() {
    if (diagnosisResult.value == null) return;
    
    String category = diagnosisResult.value!.suggestedPakarCategory;
    
    Get.toNamed(
      Routes.CLINIC_EXPERT_LIST,
      arguments: {'category': category}, // Lempar kategori 'PERTANIAN'
    );
  }
}