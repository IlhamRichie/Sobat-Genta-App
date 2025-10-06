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
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  // Rasio aspek diubah agar kartu lebih tinggi
                  childAspectRatio: 0.65, 
                  crossAxisSpacing: 16, 
                  mainAxisSpacing: 16, 
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

  /// AppBar kustom
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: BackButton(color: AppColors.textDark),
      title: Obx(() => Text(
        controller.selectedCategory.value?.name ?? "Cari Produk",
        style: Get.textTheme.headlineSmall?.copyWith(
          color: AppColors.textDark,
          fontWeight: FontWeight.bold,
        ),
      )),
      centerTitle: false,
    );
  }

  /// Baris Filter (Search & Sort)
  Widget _buildFilterBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          // 1. Search Bar (Didesain Ulang)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: TextField(
              controller: controller.searchC,
              onChanged: controller.onSearchChanged,
              decoration: InputDecoration(
                hintText: "Cari pupuk, bibit, obat...",
                hintStyle: Get.textTheme.bodyMedium?.copyWith(color: AppColors.textLight),
                prefixIcon: const FaIcon(FontAwesomeIcons.magnifyingGlass, size: 16, color: AppColors.textLight),
                suffixIcon: Obx(() => controller.searchTerm.value.isNotEmpty
                    ? IconButton(
                        icon: const FaIcon(FontAwesomeIcons.circleXmark, size: 16, color: AppColors.textLight),
                        onPressed: controller.onClearSearch,
                      )
                    : const SizedBox.shrink()),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // 2. Baris Filter Aktif & Tombol Urutkan
          Row(
            children: [
              Obx(() {
                if (controller.selectedCategory.value == null) return const SizedBox.shrink();
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Text(
                        controller.selectedCategory.value!.name,
                        style: Get.textTheme.bodyMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: controller.clearCategoryFilter,
                        child: const FaIcon(FontAwesomeIcons.circleXmark, size: 16, color: AppColors.primary),
                      ),
                    ],
                  ),
                );
              }),
              const Spacer(),
              // Tombol Urutkan
              TextButton.icon(
                onPressed: _showSortBottomSheet,
                icon: const FaIcon(FontAwesomeIcons.arrowDownWideShort, size: 16),
                label: Obx(() => Text(_getSortLabel(controller.sortBy.value))),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.textDark,
                ),
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

  /// Bottom Sheet untuk Opsi Sorting (Didesain Ulang)
  void _showSortBottomSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Urutkan Berdasarkan",
              style: Get.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildRadioListTile('Terpopuler (Rating)', 'rating'),
            _buildRadioListTile('Harga Termurah', 'price_asc'),
            _buildRadioListTile('Harga Termahal', 'price_desc'),
          ],
        ),
      ),
    );
  }
  
  // Helper untuk RadioListTile
  Widget _buildRadioListTile(String title, String value) {
    return Obx(() => ListTile(
      title: Text(title, style: TextStyle(fontWeight: controller.sortBy.value == value ? FontWeight.bold : FontWeight.normal)),
      leading: Radio<String>(
        value: value,
        groupValue: controller.sortBy.value,
        onChanged: (v) => controller.setSortBy(v!),
        activeColor: AppColors.primary,
      ),
      onTap: () => controller.setSortBy(value),
    ));
  }

  /// Empty State yang Didesain Ulang
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FaIcon(FontAwesomeIcons.boxOpen, size: 96, color: AppColors.greyLight),
            const SizedBox(height: 32),
            Text(
              "Produk Tidak Ditemukan",
              style: Get.textTheme.titleLarge?.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              "Coba gunakan kata kunci lain atau hapus filter kategori Anda.",
              style: Get.textTheme.bodyMedium?.copyWith(
                fontSize: 16,
                color: AppColors.textLight,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}