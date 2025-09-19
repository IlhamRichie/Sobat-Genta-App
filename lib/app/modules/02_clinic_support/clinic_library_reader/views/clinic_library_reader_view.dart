// lib/app/modules/clinic_library_reader/views/clinic_library_reader_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/models/digital_document_model.dart';
import '../../../../theme/app_colors.dart';
import '../controllers/clinic_library_reader_controller.dart';

class ClinicLibraryReaderView extends GetView<ClinicLibraryReaderController> {
  const ClinicLibraryReaderView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.document.category),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        // Render berdasarkan tipe konten
        if (controller.document.type == DocumentType.ARTICLE) {
          return _buildArticleView();
        } else {
          return _buildWebViewPlaceholder(); // Simulasi PDF/Video
        }
      }),
    );
  }

  /// 1. Tampilan untuk ARTIKEL (teks biasa)
  Widget _buildArticleView() {
    final doc = controller.document;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(doc.title, style: Get.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text("Dipublikasikan: ${doc.formattedDate}", style: Get.textTheme.bodyMedium?.copyWith(color: AppColors.textLight)),
          const Divider(height: 32),
          Text(
            doc.contentBody ?? "Isi artikel tidak tersedia.",
            style: Get.textTheme.bodyLarge?.copyWith(fontSize: 17, height: 1.6),
          ),
        ],
      ),
    );
  }

  /// 2. Tampilan placeholder untuk PDF / VIDEO
  /// (Di produksi, widget ini akan diganti dengan WebView atau PDFViewer)
  Widget _buildWebViewPlaceholder() {
     final doc = controller.document;
     return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.link, size: 60, color: AppColors.greyLight),
            Text(
              "Simulasi Membuka Konten",
              style: Get.textTheme.titleLarge,
            ),
            Text(
              "Konten (tipe: ${doc.type}) akan dimuat dari:\n${doc.contentUrl}",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}