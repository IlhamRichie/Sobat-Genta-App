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
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Center(
        child: Obx(() {
          // Cek state secara berurutan
          if (controller.isAnalyzing.value) {
            return _buildAnalyzingState();
          }
          if (controller.diagnosisResult.value != null) {
            return _buildResultState(controller.diagnosisResult.value!);
          }
          // Default: Tampilkan _buildEmptyState
          return _buildEmptyState();
        }),
      ),
    );
  }

  /// AppBar Kustom
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      title: Text(
        "AI Scan Diagnosis",
        style: Get.textTheme.headlineSmall?.copyWith(
          color: AppColors.textDark,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: false,
      actions: [
        Obx(() => controller.imageToAnalyze.value != null
            ? IconButton(
                icon: const FaIcon(FontAwesomeIcons.arrowRotateRight),
                onPressed: controller.clearAnalysis,
              )
            : const SizedBox.shrink()),
        const SizedBox(width: 8),
      ],
    );
  }

  /// State 1: Halaman Awal (Pilih Sumber Gambar)
  Widget _buildEmptyState() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(), // Agar RefreshIndicator tetap berfungsi
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const FaIcon(FontAwesomeIcons.robot, size: 96, color: AppColors.primary),
            const SizedBox(height: 32),
            Text(
              "Diagnosa Penyakit Tanaman/Ternak",
              style: Get.textTheme.titleLarge?.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              "Ambil foto bagian yang sakit untuk mendapatkan diagnosa awal dari AI kami.",
              style: Get.textTheme.bodyMedium?.copyWith(
                fontSize: 16,
                color: AppColors.textLight,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            FilledButton.icon(
              onPressed: () => controller.pickImage(ImageSource.camera),
              icon: const FaIcon(FontAwesomeIcons.camera),
              label: const Text("Ambil dari Kamera"),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () => controller.pickImage(ImageSource.gallery),
              icon: const FaIcon(FontAwesomeIcons.image),
              label: const Text("Pilih dari Galeri"),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textDark,
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: AppColors.greyLight),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// State 2: Tampilan Saat Loading Analisis (Didesain Ulang)
  Widget _buildAnalyzingState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: Get.width,
          height: Get.width,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.file(
                  controller.imageToAnalyze.value!,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      "AI sedang menganalisis...",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// State 3: Tampilan Hasil Diagnosis (Didesain Ulang)
  Widget _buildResultState(AiDiagnosisModel result) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Gambar yang dianalisis
          Container(
            height: 250,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: FileImage(controller.imageToAnalyze.value!),
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          // Hasil
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bagian Utama Hasil
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Hasil Diagnosa AI:",
                        style: TextStyle(color: AppColors.textLight, fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        result.diseaseName,
                        style: Get.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "Tingkat Keyakinan: ${(result.confidenceScore * 100).toStringAsFixed(0)}%",
                          style: Get.textTheme.bodySmall?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Bagian Deskripsi
                _buildInfoSection(
                  title: "Deskripsi",
                  content: result.description,
                ),
                
                const SizedBox(height: 24),
                
                // Bagian Rekomendasi
                _buildInfoSection(
                  title: "Rekomendasi Solusi (P3K)",
                  content: result.firstAidSolution,
                ),
                
                const SizedBox(height: 24),

                // Upsell Section (Didesain Ulang)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const FaIcon(FontAwesomeIcons.userDoctor, size: 40, color: Colors.white),
                      const SizedBox(height: 12),
                      Text(
                        "Hasil diagnosa AI hanya bersifat awal. Untuk penanganan yang tepat dan resep obat, konsultasikan dengan Pakar.",
                        textAlign: TextAlign.center,
                        style: Get.textTheme.bodyLarge?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: controller.contactExpert,
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Text("Hubungi Pakar ${result.suggestedPakarCategory.capitalizeFirst}"),
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

  // Helper untuk section info (Deskripsi/Rekomendasi)
  Widget _buildInfoSection({required String title, required String content}) {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Get.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: Get.textTheme.bodyLarge?.copyWith(height: 1.5, color: AppColors.textDark),
          ),
        ],
      ),
    );
  }
}