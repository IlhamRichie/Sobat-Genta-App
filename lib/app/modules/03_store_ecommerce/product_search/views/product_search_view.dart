// lib/app/modules/product_search/views/product_search_view.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../theme/app_colors.dart';
import '../../../../widgets/cards/product_card.dart';
import '../controllers/product_search_controller.dart';

class ProductSearchView extends GetView<ProductSearchController> {
  const ProductSearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildAppBarTitle(),
      ),
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.productList.isEmpty) {
                return _buildEmptyState();
              }
              
              // Tampilkan hasil di GridView
              return GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7, // Rasio dari ProductCard
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: controller.productList.length,
                itemBuilder: (context, index) {
                  final product = controller.productList[index];
                  return ProductCard(
                    product: product,
                    onTap: () => controller.goToProductDetail(product),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  /// AppBar dinamis (menampilkan kategori atau "Cari Produk")
  Widget _buildAppBarTitle() {
    return Obx(() => Text(
      controller.selectedCategory.value?.name ?? "Cari Produk",
    ));
  }

  /// Baris Filter (Search & Sort)
  Widget _buildFilterBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        children: [
          // 1. Search Bar
          TextField(
            controller: controller.searchC,
            onChanged: controller.onSearchChanged,
            decoration: InputDecoration(
              hintText: "Cari pupuk, bibit, obat...",
              prefixIcon: const FaIcon(FontAwesomeIcons.magnifyingGlass, size: 16),
              suffixIcon: Obx(() => controller.searchTerm.value.isNotEmpty
                  ? IconButton(
                      icon: const FaIcon(FontAwesomeIcons.circleXmark, size: 16),
                      onPressed: controller.onClearSearch,
                    )
                  : const SizedBox.shrink()),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
          const SizedBox(height: 8),
          // 2. Baris Filter Aktif & Tombol Urutkan
          Row(
            children: [
              // Chip kategori (jika ada)
              Obx(() {
                if (controller.selectedCategory.value == null) return const SizedBox.shrink();
                return Chip(
                  label: Text(controller.selectedCategory.value!.name),
                  onDeleted: controller.clearCategoryFilter,
                );
              }),
              const Spacer(),
              // Tombol Urutkan
              TextButton.icon(
                onPressed: _showSortBottomSheet,
                icon: const FaIcon(FontAwesomeIcons.arrowDownWideShort, size: 16),
                label: Obx(() => Text(_getSortLabel(controller.sortBy.value))),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  String _getSortLabel(String sortBy) {
    if (sortBy == 'price_asc') return "Harga Termurah";
    if (sortBy == 'price_desc') return "Harga Termahal";
    return "Terpopuler";
  }

  /// Bottom Sheet untuk Opsi Sorting
  void _showSortBottomSheet() {
    Get.bottomSheet(
      Container(
        color: AppColors.background,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Urutkan Berdasarkan", style: Get.textTheme.titleLarge?.copyWith(fontSize: 18)),
            const SizedBox(height: 16),
            RadioListTile<String>(
              title: const Text("Terpopuler (Rating)"),
              value: 'rating',
              groupValue: controller.sortBy.value,
              onChanged: (v) => controller.setSortBy(v!),
            ),
            RadioListTile<String>(
              title: const Text("Harga Termurah"),
              value: 'price_asc',
              groupValue: controller.sortBy.value,
              onChanged: (v) => controller.setSortBy(v!),
            ),
             RadioListTile<String>(
              title: const Text("Harga Termahal"),
              value: 'price_desc',
              groupValue: controller.sortBy.value,
              onChanged: (v) => controller.setSortBy(v!),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
     return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(FontAwesomeIcons.boxOpen, size: 80, color: AppColors.greyLight),
            const SizedBox(height: 24),
            Text(
              "Produk Tidak Ditemukan",
              style: Get.textTheme.titleLarge?.copyWith(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "Coba gunakan kata kunci lain atau hapus filter kategori Anda.",
              style: Get.textTheme.bodyMedium?.copyWith(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}