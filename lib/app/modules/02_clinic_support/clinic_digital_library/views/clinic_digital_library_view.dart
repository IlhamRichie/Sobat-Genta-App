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
      backgroundColor: const Color(0xFFF5F6F8), // Background light grey
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Pustaka Tani",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          _buildSearchAndFilter(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return _buildLoadingGrid();
              }
              if (controller.documentList.isEmpty) {
                return _buildEmptyState();
              }
              return RefreshIndicator(
                onRefresh: controller.fetchInitialDocs,
                color: AppColors.primary,
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  controller: controller.scrollController,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 Kolom
                    childAspectRatio: 0.75, // Tinggi > Lebar (Portrait Card)
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  // Tambah 1 item untuk loader bawah
                  itemCount: controller.documentList.length + (controller.hasMoreData.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == controller.documentList.length) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final doc = controller.documentList[index];
                    return _buildDocumentGridItem(doc);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  /// Bagian Atas: Search Bar + Kategori Chips
  Widget _buildSearchAndFilter() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: controller.searchC,
              onChanged: controller.onSearchChanged,
              decoration: InputDecoration(
                hintText: "Cari panduan, video, artikel...",
                hintStyle: TextStyle(color: Colors.grey.shade400),
                prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
                filled: true,
                fillColor: const Color(0xFFF5F6F8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          
          // Kategori Chips (Scrollable Horizontal)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Obx(() => Row(
              children: [
                _buildFilterChip('SEMUA', "Semua"),
                const SizedBox(width: 8),
                _buildFilterChip('PERTANIAN', "Pertanian"),
                const SizedBox(width: 8),
                _buildFilterChip('PETERNAKAN', "Peternakan"),
                const SizedBox(width: 8),
                _buildFilterChip('TEKNOLOGI', "Teknologi"), // Tambahan kategori dummy
              ],
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String filterKey, String label) {
    bool isSelected = controller.categoryFilter.value == filterKey;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (bool selected) {
        if (selected) controller.setCategoryFilter(filterKey);
      },
      selectedColor: AppColors.primary,
      backgroundColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.grey.shade600,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      side: isSelected ? BorderSide.none : BorderSide(color: Colors.grey.shade300),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }

  /// Kartu Grid Item Modern
  Widget _buildDocumentGridItem(DigitalDocumentModel doc) {
    // Mapping Icon berdasarkan tipe
    IconData typeIcon;
    Color typeColor;
    
    switch (doc.type) {
      case DocumentType.VIDEO:
        typeIcon = FontAwesomeIcons.play;
        typeColor = Colors.red;
        break;
      case DocumentType.PDF:
        typeIcon = FontAwesomeIcons.filePdf;
        typeColor = Colors.orange;
        break;
      default:
        typeIcon = FontAwesomeIcons.bookOpen;
        typeColor = AppColors.primary;
    }

    return GestureDetector(
      onTap: () => controller.goToReader(doc),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Thumbnail Image (Placeholder Pattern)
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  color: typeColor.withOpacity(0.1), // Warna background sesuai tipe
                  image: const DecorationImage(
                    image: NetworkImage("https://source.unsplash.com/random/300x200/?farming"), // Dummy Image
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    // Overlay gradient biar teks kebaca (kalau ada teks di gambar)
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black.withOpacity(0.3)],
                        ),
                      ),
                    ),
                    // Icon Type di pojok kanan atas
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: FaIcon(typeIcon, size: 12, color: typeColor),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // 2. Info Konten
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      doc.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        height: 1.3,
                      ),
                    ),
                    Row(
                      children: [
                        FaIcon(FontAwesomeIcons.clock, size: 10, color: Colors.grey.shade400),
                        const SizedBox(width: 4),
                        Text(
                          "5 min baca", // Dummy duration
                          style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                        ),
                        const Spacer(),
                        FaIcon(FontAwesomeIcons.arrowRight, size: 12, color: AppColors.primary),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(child: CircularProgressIndicator(color: Colors.grey.shade200)),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(FontAwesomeIcons.folderOpen, size: 60, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text("Belum ada dokumen.", style: TextStyle(color: Colors.grey.shade500)),
        ],
      ),
    );
  }
}