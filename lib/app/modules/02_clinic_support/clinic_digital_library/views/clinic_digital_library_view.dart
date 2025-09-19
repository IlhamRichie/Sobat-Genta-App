// lib/app/modules/clinic_digital_library/views/clinic_digital_library_view.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../data/models/digital_document_model.dart';
import '../../../../theme/app_colors.dart';
import '../controllers/clinic_digital_library_controller.dart';

class ClinicDigitalLibraryView extends GetView<ClinicDigitalLibraryController> {
  const ClinicDigitalLibraryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Perpustakaan Digital"),
      ),
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.documentList.isEmpty) {
                return const Center(child: Text("Tidak ada dokumen ditemukan."));
              }
              return RefreshIndicator(
                onRefresh: controller.fetchInitialDocs,
                child: ListView.builder(
                  controller: controller.scrollController,
                  itemCount: controller.documentList.length + 1,
                  itemBuilder: (context, index) {
                    if (index == controller.documentList.length) {
                      return _buildLoader(); // Pagination loader
                    }
                    final doc = controller.documentList[index];
                    return _buildDocumentCard(doc);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  /// Filter Bar (Search & Category Chips)
  Widget _buildFilterBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: controller.searchC,
            onChanged: controller.onSearchChanged,
            decoration: InputDecoration(
              hintText: "Cari judul artikel...",
              prefixIcon: const FaIcon(FontAwesomeIcons.magnifyingGlass, size: 16),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 12),
          // Category Toggle Chips
          Obx(() => ToggleButtons(
            isSelected: [
              controller.categoryFilter.value == 'SEMUA',
              controller.categoryFilter.value == 'PERTANIAN',
              controller.categoryFilter.value == 'PETERNAKAN',
            ],
            onPressed: (index) {
              if (index == 0) controller.setCategoryFilter('SEMUA');
              if (index == 1) controller.setCategoryFilter('PERTANIAN');
              if (index == 2) controller.setCategoryFilter('PETERNAKAN');
            },
            borderRadius: BorderRadius.circular(8),
            children: const [
              Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text("Semua")),
              Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text("Pertanian")),
              Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text("Peternakan")),
            ],
          )),
        ],
      ),
    );
  }

  /// Kartu untuk satu artikel/dokumen
  Widget _buildDocumentCard(DigitalDocumentModel doc) {
     Map<DocumentType, IconData> iconMap = {
      DocumentType.ARTICLE: FontAwesomeIcons.fileLines,
      DocumentType.VIDEO: FontAwesomeIcons.circlePlay,
      DocumentType.PDF: FontAwesomeIcons.filePdf,
     };
     
     return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => controller.goToReader(doc),
        borderRadius: BorderRadius.circular(12),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: AppColors.primary.withOpacity(0.1),
            child: FaIcon(iconMap[doc.type], color: AppColors.primary, size: 20),
          ),
          title: Text(doc.title, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 2),
          subtitle: Text(doc.snippet, maxLines: 2, overflow: TextOverflow.ellipsis),
          trailing: const FaIcon(FontAwesomeIcons.chevronRight, size: 14),
        ),
      ),
    );
  }

  /// Loader Pagination
  Widget _buildLoader() {
    return Obx(() {
      if (controller.isLoadingMore.value) {
        return const Center(child: Padding(padding: EdgeInsets.all(24.0), child: CircularProgressIndicator()));
      }
      if (!controller.hasMoreData.value) {
         return const Center(child: Padding(padding: EdgeInsets.all(24.0), child: Text("Akhir dari daftar.")));
      }
      return const SizedBox.shrink();
    });
  }
}