// lib/app/modules/clinic_ai_scan/views/clinic_ai_scan_view.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../data/models/ai_diagnosis_model.dart';
import '../../../../theme/app_colors.dart';
import '../controllers/clinic_ai_scan_controller.dart';

class ClinicAiScanView extends GetView<ClinicAiScanController> {
  const ClinicAiScanView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan AI Diagnosis"),
        actions: [
          // Tombol Reset/Scan Ulang (hanya tampil jika ada gambar)
          Obx(() => controller.imageToAnalyze.value != null
              ? IconButton(
                  icon: const FaIcon(FontAwesomeIcons.arrowRotateRight),
                  onPressed: controller.clearAnalysis,
                )
              : const SizedBox.shrink()),
        ],
      ),
      body: Center(
        child: Obx(() {
          // Cek state secara berurutan
          
          // State 3: Sedang Menganalisis
          if (controller.isAnalyzing.value) {
            return _buildAnalyzingState();
          }
          
          // State 4: Hasil Sudah Ada
          if (controller.diagnosisResult.value != null) {
            return _buildResultState(controller.diagnosisResult.value!);
          }
          
          // State 2: Gambar Sudah Dipilih (tapi belum/gagal dianalisis)
          if (controller.imageToAnalyze.value != null) {
            return _buildImagePickedState();
          }

          // State 1: Default (Belum ada gambar)
          return _buildEmptyState();
        }),
      ),
    );
  }

  /// State 1: Halaman Awal (Pilih Sumber Gambar)
  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const FaIcon(FontAwesomeIcons.robot, size: 80, color: AppColors.primary),
          const SizedBox(height: 16),
          Text(
            "Diagnosa Cepat Penyakit",
            style: Get.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Text(
            "Ambil foto daun tanaman atau kulit ternak Anda yang sakit untuk mendapatkan diagnosa awal dari AI.",
            style: Get.textTheme.bodyLarge?.copyWith(color: AppColors.textLight),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: () => controller.pickImage(ImageSource.camera),
            icon: const FaIcon(FontAwesomeIcons.camera),
            label: const Text("Ambil dari Kamera"),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => controller.pickImage(ImageSource.gallery),
            icon: const FaIcon(FontAwesomeIcons.image),
            label: const Text("Pilih dari Galeri"),
          ),
        ],
      ),
    );
  }

  /// State 2: Tampilkan Gambar yang Dipilih (Jika Gagal Analisis)
  Widget _buildImagePickedState() {
     return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.file(controller.imageToAnalyze.value!),
        const Text("Gagal menganalisis. Coba lagi."),
      ],
    );
  }

  /// State 3: Tampilan Saat Loading Analisis
  Widget _buildAnalyzingState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.file(controller.imageToAnalyze.value!, height: Get.height * 0.4),
        const SizedBox(height: 32),
        const CircularProgressIndicator(),
        const SizedBox(height: 16),
        const Text("AI sedang menganalisis gambar...", style: TextStyle(fontSize: 16)),
      ],
    );
  }

  /// State 4: Tampilan Hasil Diagnosis
  Widget _buildResultState(AiDiagnosisModel result) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Gambar yang dianalisis
          Image.file(controller.imageToAnalyze.value!),
          
          // Hasil
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hasil Diagnosa AI:",
                  style: Get.textTheme.bodySmall
                ),
                Text(
                  result.diseaseName,
                  style: Get.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                Chip(
                  label: Text("Tingkat Keyakinan: ${(result.confidenceScore * 100).toStringAsFixed(0)}%"),
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                ),
                const Divider(height: 24),
                Text("Deskripsi", style: Get.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                Text(result.description, style: Get.textTheme.bodyLarge?.copyWith(height: 1.5)),
                const SizedBox(height: 20),
                Text("Rekomendasi Solusi (P3K)", style: Get.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                Text(result.firstAidSolution, style: Get.textTheme.bodyLarge?.copyWith(height: 1.5)),
                const SizedBox(height: 24),
                
                // --- AKSI UPSELL (Kritis) ---
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.primary.withOpacity(0.3))
                  ),
                  child: Column(
                    children: [
                      Text(
                        "AI hanya diagnosa awal. Untuk hasil akurat dan resep obat, konsultasikan dengan Pakar.",
                        textAlign: TextAlign.center, style: Get.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: controller.contactExpert, 
                        child: Text("Hubungi Pakar ${result.suggestedPakarCategory.capitalizeFirst}")
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}