// lib/app/modules/store_home/views/store_home_view.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../theme/app_colors.dart';
import '../../../../widgets/cards/product_card.dart'; // Pastikan ProductCard sudah di-import
import '../controllers/store_home_controller.dart';

class StoreHomeView extends GetView<StoreHomeController> {
  const StoreHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // Latar belakang abu-abu terang
      appBar: _buildAppBar(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: controller.fetchStoreDashboard,
          child: SingleChildScrollView( // Kembali ke SingleChildScrollView
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20), // Padding atas untuk kesan lapang
                _buildPromoBanner(),
                const SizedBox(height: 24),
                _buildCategoriesSection(),
                const SizedBox(height: 24),
                _buildFeaturedProductsSection(),
                const SizedBox(height: 24), // Padding bawah
              ],
            ),
          ),
        );
      }),
    );
  }
  
  /// AppBar Modern
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      title: Text(
        "Toko",
        style: Get.textTheme.headlineSmall?.copyWith(
          color: AppColors.textDark,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: false,
      actions: [
        IconButton(
          onPressed: controller.goToFullSearch,
          icon: const FaIcon(FontAwesomeIcons.magnifyingGlass, color: AppColors.textLight),
        ),
        IconButton(
          onPressed: controller.goToCart,
          icon: const FaIcon(FontAwesomeIcons.cartShopping, color: AppColors.textLight),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  /// 1. Promo Banner (Diperbarui)
  Widget _buildPromoBanner() {
    return Container(
      height: 215, // Tinggi lebih proporsional
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Gambar atau pola (contoh)
          Positioned(
            bottom: 0,
            right: 0,
            child: Opacity(
              opacity: 0.2,
              child: Image.asset('assets/onboarding/onboarding_market.png', width: 250), // Ganti dengan aset lokal
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Diskon Spesial!",
                  style: Get.textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Dapatkan penawaran terbaik untuk pupuk dan bibit pilihan.",
                  style: Get.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () { /* TODO: Go to promo page */ },
                  child: const Text("Lihat Sekarang"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white, width: 2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 2. Daftar Kategori Horizontal (Diperbarui)
  Widget _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Text(
            "Kategori",
            style: Get.textTheme.titleLarge?.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 100, // Tetap gunakan SizedBox agar ListView bisa di-scroll horizontal
          child: ListView.builder(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.horizontal,
            itemCount: controller.categoryList.length,
            itemBuilder: (context, index) {
              final category = controller.categoryList[index];
              return Padding(
                padding: EdgeInsets.only(right: index == controller.categoryList.length - 1 ? 0 : 16),
                child: _buildCategoryChip(category),
              );
            },
          ),
        ),
      ],
    );
  }
  
  /// Helper untuk Category Chip (Diperbarui)
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
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 90,
        padding: const EdgeInsets.symmetric(vertical: 12),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(iconMap[category.iconUrl] ?? FontAwesomeIcons.tag, color: AppColors.primary, size: 28),
            const SizedBox(height: 8),
            Text(
              category.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Get.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// 3. Daftar Produk Unggulan (Diperbarui)
  Widget _buildFeaturedProductsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Produk Terlaris",
          style: Get.textTheme.titleLarge?.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.65, // Rasio disesuaikan
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