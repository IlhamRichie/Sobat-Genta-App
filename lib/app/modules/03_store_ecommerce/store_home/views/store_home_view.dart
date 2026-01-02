// lib/app/modules/store_home/views/store_home_view.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../theme/app_colors.dart';
import '../../../../widgets/cards/product_card.dart'; 
import '../controllers/store_home_controller.dart';

class StoreHomeView extends GetView<StoreHomeController> {
  const StoreHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // 1. BACKGROUND DECORATION (Consistent Theme)
          Positioned(
            top: -100,
            right: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.05), // Nuansa oranye untuk Toko
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 150,
            left: -80,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // 2. MAIN CONTENT
          SafeArea(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              return RefreshIndicator(
                onRefresh: controller.fetchStoreDashboard,
                color: AppColors.primary,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCustomAppBar(),
                      const SizedBox(height: 24),
                      
                      _buildPromoBanner(),
                      const SizedBox(height: 32),
                      
                      _buildCategoriesSection(),
                      const SizedBox(height: 32),
                      
                      _buildFeaturedProductsSection(),
                      const SizedBox(height: 100), // Bottom padding
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
  
  /// Custom AppBar
  Widget _buildCustomAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Toko Tani",
              style: Get.textTheme.headlineSmall?.copyWith(
                color: AppColors.textDark,
                fontWeight: FontWeight.w800,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Belanja kebutuhan pertanian",
              style: Get.textTheme.bodyMedium?.copyWith(
                color: AppColors.textLight,
                fontSize: 14,
              ),
            ),
          ],
        ),
        Row(
          children: [
            _buildIconBtn(
              FontAwesomeIcons.magnifyingGlass, 
              controller.goToFullSearch
            ),
            const SizedBox(width: 12),
            _buildIconBtn(
              FontAwesomeIcons.cartShopping, 
              controller.goToCart
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildIconBtn(IconData icon, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onTap,
        icon: FaIcon(icon, size: 18, color: AppColors.textDark),
        splashRadius: 24,
      ),
    );
  }

  /// 1. Promo Banner (Modern Gradient)
  Widget _buildPromoBanner() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF9800), Color(0xFFF57C00)], // Orange Gradient
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Pattern
          Positioned(
            right: -30,
            bottom: -30,
            child: Icon(
              FontAwesomeIcons.bagShopping,
              size: 150,
              color: Colors.white.withOpacity(0.15),
            ),
          ),
          Positioned(
            left: 20,
            top: -20,
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white.withOpacity(0.1),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "PROMO SPESIAL",
                    style: TextStyle(
                      color: Colors.white, 
                      fontWeight: FontWeight.w800, 
                      fontSize: 11,
                      letterSpacing: 0.5
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Diskon Pupuk\nHingga 50%!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Tingkatkan hasil panen dengan biaya lebih hemat hari ini.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () { /* TODO: Go to promo */ },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.orange.shade800,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text(
                    "Belanja Sekarang", 
                    style: TextStyle(fontWeight: FontWeight.bold)
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 2. Categories (Clean Horizontal List)
  Widget _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Kategori Pilihan",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 110, 
          child: ListView.separated(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: controller.categoryList.length,
            separatorBuilder: (ctx, i) => const SizedBox(width: 12),
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
    Map<String, IconData> iconMap = {
      "leaf": FontAwesomeIcons.leaf,
      "seedling": FontAwesomeIcons.seedling,
      "syringe": FontAwesomeIcons.syringe,
      "spider": FontAwesomeIcons.spider,
      "tractor": FontAwesomeIcons.tractor,
    };

    return InkWell(
      onTap: () => controller.goToCategoryPage(category),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 85,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.greyLight),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: FaIcon(
                iconMap[category.iconUrl] ?? FontAwesomeIcons.tag, 
                color: AppColors.primary, 
                size: 20
              ),
            ),
            const SizedBox(height: 10),
            Text(
              category.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: AppColors.textDark,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// 3. Featured Products (Grid Layout)
  Widget _buildFeaturedProductsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Produk Terlaris",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            TextButton(
              onPressed: () { /* TODO: View All Products */ },
              child: const Text(
                "Lihat Semua",
                style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.65, // Rasio kartu produk (Tinggi vs Lebar)
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: controller.featuredProductList.length,
          itemBuilder: (context, index) {
            final product = controller.featuredProductList[index];
            return ProductCard(
              product: product,
              onTap: () => controller.goToProductDetail(product),
            );
          },
        ),
      ],
    );
  }
}