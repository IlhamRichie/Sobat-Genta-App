// lib/app/modules/store_home/views/store_home_view.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';import '../../../../theme/app_colors.dart';
import '../../../../widgets/cards/product_card.dart';
import '../controllers/store_home_controller.dart';

class StoreHomeView extends GetView<StoreHomeController> {
  const StoreHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Toko"),
        actions: [
          IconButton(
            onPressed: controller.goToFullSearch,
            icon: const FaIcon(FontAwesomeIcons.magnifyingGlass),
          ),
          IconButton(
            onPressed: controller.goToCart,
            icon: const FaIcon(FontAwesomeIcons.cartShopping),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        return RefreshIndicator(
          onRefresh: controller.fetchStoreDashboard,
          child: ListView( // Gunakan ListView, bukan SingleChildScrollView
            children: [
              _buildPromoBanner(),
              const SizedBox(height: 16),
              _buildCategoriesSection(),
              const SizedBox(height: 16),
              _buildFeaturedProductsSection(),
            ],
          ),
        );
      }),
    );
  }

  /// 1. Placeholder Banner Promo
  Widget _buildPromoBanner() {
    return Container(
      height: 160,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(child: Text("Banner Promo")), // TODO: Implement PageView
    );
  }

  /// 2. Daftar Kategori Horizontal
  Widget _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text("Kategori", style: Get.textTheme.titleLarge?.copyWith(fontSize: 18)),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: controller.categoryList.length,
            itemBuilder: (context, index) {
              final category = controller.categoryList[index];
              return _buildCategoryChip(category);
            },
          ),
        ),
      ],
    );
  }
  
  Widget _buildCategoryChip(category) {
    // Map string ikon ke IconData (ini harusnya dari API)
    Map<String, IconData> iconMap = {
      "leaf": FontAwesomeIcons.leaf,
      "seedling": FontAwesomeIcons.seedling,
      "syringe": FontAwesomeIcons.syringe,
      "spider": FontAwesomeIcons.spider,
      "tractor": FontAwesomeIcons.tractor,
    };

    return SizedBox(
      width: 90,
      child: InkWell(
        onTap: () => controller.goToCategoryPage(category),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: FaIcon(iconMap[category.iconUrl] ?? FontAwesomeIcons.tag, color: AppColors.primary),
            ),
            const SizedBox(height: 8),
            Text(category.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: Get.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }

  /// 3. Daftar Produk Unggulan
  Widget _buildFeaturedProductsSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Produk Terlaris", style: Get.textTheme.titleLarge?.copyWith(fontSize: 18)),
          const SizedBox(height: 12),
          // Gunakan GridView, tapi dalam ListView dia harus di-wrap
          GridView.builder(
            shrinkWrap: true, // Wajib di dalam ListView
            physics: const NeverScrollableScrollPhysics(), // Wajib di dalam ListView
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7, // Sesuaikan rasio kartu produk
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: controller.featuredProductList.length,
            itemBuilder: (context, index) {
              final product = controller.featuredProductList[index];
              // Panggil widget REUSABLE kita
              return ProductCard(
                product: product,
                onTap: () => controller.goToProductDetail(product),
              );
            },
          ),
        ],
      ),
    );
  }
}