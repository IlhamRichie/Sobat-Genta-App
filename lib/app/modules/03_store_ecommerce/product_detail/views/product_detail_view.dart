// lib/app/modules/product_detail/views/product_detail_view.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../data/models/product_model.dart';
import '../../../../data/models/product_review_model.dart';
import '../../../../routes/app_pages.dart';
import '../../../../theme/app_colors.dart';
import '../controllers/product_detail_controller.dart';

class ProductDetailView extends GetView<ProductDetailController> {
  const ProductDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoadingPage.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.product.value == null) {
          return const Center(child: Text("Produk tidak ditemukan"));
        }
        
        // Data siap
        return _buildProductDetailBody(controller.product.value!);
      }),
      // CTA Bar di bawah
      bottomNavigationBar: _buildBottomActionBar(),
    );
  }

  /// Body utama dengan AppBar yang bisa collapse
  Widget _buildProductDetailBody(ProductModel product) {
    return CustomScrollView(
      slivers: [
        // 1. AppBar dengan Galeri Gambar
        SliverAppBar(
          expandedHeight: 300.0,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: _buildImageGallery(product.galleryImageUrls ?? []),
          ),
          actions: [
             IconButton(
              icon: const FaIcon(FontAwesomeIcons.cartShopping),
              onPressed: () => Get.toNamed(Routes.CART),
            ),
          ],
        ),
        
        // 2. Konten Detail Produk
        SliverList(
          delegate: SliverChildListDelegate([
            _buildHeader(product),
            _buildRating(product),
            _buildDescription(product),
            _buildReviews(product), // Menampilkan 2 review terakhir
          ]),
        ),
      ],
    );
  }

  /// 1a. Placeholder Galeri Gambar
  Widget _buildImageGallery(List<String> images) {
    // TODO: Implement PageView.builder untuk galeri swipe
    return Container(
      color: AppColors.greyLight,
      child: const Center(child: FaIcon(FontAwesomeIcons.image, size: 100, color: Colors.grey)),
    );
  }

  /// 2a. Header (Harga & Nama)
  Widget _buildHeader(ProductModel product) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.formattedPrice,
            style: Get.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold, 
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            product.name,
            style: Get.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: 22),
          ),
        ],
      ),
    );
  }
  
  /// 2b. Rating & Stok
  Widget _buildRating(ProductModel product) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const FaIcon(FontAwesomeIcons.solidStar, color: Colors.amber, size: 18),
              const SizedBox(width: 8),
              Text("${product.rating}", style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(" (${product.reviewCount} ulasan)", style: const TextStyle(color: AppColors.textLight)),
            ],
          ),
          Text(
            "Stok: ${product.stockQuantity ?? 0}",
            style: const TextStyle(color: AppColors.textLight, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  /// 2c. Deskripsi Produk
  Widget _buildDescription(ProductModel product) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Deskripsi Produk", style: Get.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const Divider(height: 24),
          Text(
            product.fullDescription ?? "Tidak ada deskripsi.",
            style: Get.textTheme.bodyLarge?.copyWith(height: 1.5, color: AppColors.textLight),
          ),
        ],
      ),
    );
  }
  
  /// 2d. Ulasan Terbaru
  Widget _buildReviews(ProductModel product) {
    final reviews = product.recentReviews ?? [];
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Ulasan Pembeli (${product.reviewCount})", style: Get.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
               if (product.reviewCount > 2)
                TextButton(
                  onPressed: controller.goToAllReviews,
                  child: const Text("Lihat Semua"),
                ),
            ],
          ),
          const Divider(height: 24),
          if (reviews.isEmpty)
            const Text("Belum ada ulasan untuk produk ini."),
          
          ...reviews.map((review) => _buildReviewTile(review)).toList(),
        ],
      ),
    );
  }
  
  Widget _buildReviewTile(ProductReviewModel review) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const CircleAvatar(child: FaIcon(FontAwesomeIcons.solidUser)),
      title: Text(review.userName, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(review.comment, maxLines: 2, overflow: TextOverflow.ellipsis),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(review.rating.toString()),
          const FaIcon(FontAwesomeIcons.solidStar, color: Colors.amber, size: 14),
        ],
      ),
    );
  }

  /// 3. Bottom CTA Bar (Kuantitas & Keranjang)
  Widget _buildBottomActionBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: Row(
        children: [
          // Kuantitas
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Obx(() => Row(
              children: [
                IconButton(
                  onPressed: controller.decrementQuantity,
                  icon: const FaIcon(FontAwesomeIcons.minus, size: 16),
                  color: controller.quantity.value > 1 ? AppColors.textDark : Colors.grey,
                ),
                Text(controller.quantity.value.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                IconButton(
                  onPressed: controller.incrementQuantity,
                  icon: const FaIcon(FontAwesomeIcons.plus, size: 16, color: AppColors.primary),
                ),
              ],
            )),
          ),
          const SizedBox(width: 16),
          // Tombol Keranjang
          Expanded(
            child: Obx(() => FilledButton.icon(
              onPressed: controller.isAddingToCart.value ? null : controller.addToCart,
              icon: controller.isAddingToCart.value
                  ? const SizedBox.shrink()
                  : const FaIcon(FontAwesomeIcons.cartPlus, size: 16),
              label: controller.isAddingToCart.value
                  ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                  : const Text("Ke Keranjang"),
            )),
          ),
        ],
      ),
    );
  }
}