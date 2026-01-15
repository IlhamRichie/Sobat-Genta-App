import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Buat atur status bar
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../data/models/product_model.dart';
import '../../../../data/models/product_review_model.dart';
import '../../../../routes/app_pages.dart';
import '../../../../theme/app_colors.dart'; // Pastikan import ini benar
import '../controllers/product_detail_controller.dart';

class ProductDetailView extends GetView<ProductDetailController> {
  const ProductDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Bikin status bar transparan biar gambarnya full ke atas
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8), // AppColors.background
      body: Obx(() {
        if (controller.isLoadingPage.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.product.value == null) {
          return const Center(child: Text("Opps, Produk tidak ditemukan"));
        }
        
        return _buildProductDetailBody(controller.product.value!);
      }),
      bottomNavigationBar: Obx(() {
        // Sembunyikan bottom bar kalau masih loading
        if (controller.isLoadingPage.value || controller.product.value == null) {
          return const SizedBox.shrink();
        }
        return _buildBottomActionBar();
      }),
    );
  }

  /// Body utama dengan AppBar yang bisa collapse (Sliver)
  Widget _buildProductDetailBody(ProductModel product) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // 1. AppBar dengan Galeri Gambar + Tombol Back Custom
        SliverAppBar(
          expandedHeight: 350.0,
          pinned: true,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Get.back(),
            ),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const FaIcon(FontAwesomeIcons.cartShopping, size: 18, color: AppColors.textDark),
                onPressed: () => Get.toNamed(Routes.CART),
              ),
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: _buildImageGallery(product.galleryImageUrls ?? []),
          ),
        ),
        
        // 2. Konten Detail Produk
        SliverList(
          delegate: SliverChildListDelegate([
            // Container utama dengan border radius di atas biar kayak "Sheet"
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF5F6F8), // Background abu sangat muda
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  // Section 1: Header Info
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         _buildHeader(product),
                         const SizedBox(height: 16),
                         _buildRatingAndStock(product),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Section 2: Deskripsi
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    color: Colors.white,
                    child: _buildDescription(product),
                  ),

                  const SizedBox(height: 12),

                  // Section 3: Ulasan
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    color: Colors.white,
                    margin: const EdgeInsets.only(bottom: 100), // Space buat bottom bar
                    child: _buildReviews(product),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ],
    );
  }

  /// 1a. Galeri Gambar dengan PageView
  Widget _buildImageGallery(List<String> images) {
    if (images.isEmpty) {
      return Container(
        color: Colors.grey.shade200,
        child: const Center(child: FaIcon(FontAwesomeIcons.image, size: 80, color: Colors.grey)),
      );
    }
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        PageView.builder(
          itemCount: images.length,
          itemBuilder: (context, index) {
            return Image.network(
              images[index],
              fit: BoxFit.cover,
              errorBuilder: (ctx, err, stack) => const Center(child: Icon(Icons.broken_image)),
            );
          },
        ),
        // Indikator slide (Optional, kalau mau nambahin dot indicator disini)
        Container(
          height: 30,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.black.withOpacity(0.1), Colors.transparent],
            ),
          ),
        ),
      ],
    );
  }

  /// 2a. Header (Harga & Nama)
  Widget _buildHeader(ProductModel product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.formattedPrice,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: AppColors.primary, // Hijau Genta
            fontFamily: 'Popins', // Sesuaikan font
          ),
        ),
        const SizedBox(height: 8),
        Text(
          product.name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3436), // Text Dark
            height: 1.3,
          ),
        ),
      ],
    );
  }
  
  /// 2b. Rating & Stok (Dalam satu row rapi)
  Widget _buildRatingAndStock(ProductModel product) {
    return Row(
      children: [
        // Rating Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.amber.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.amber.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              const FaIcon(FontAwesomeIcons.solidStar, color: Colors.amber, size: 12),
              const SizedBox(width: 6),
              Text(
                "${product.rating} (${product.reviewCount})",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber.shade900, fontSize: 12),
              ),
            ],
          ),
        ),
        const Spacer(),
        // Stock Badge
        Text(
          "Stok: ${product.stockQuantity ?? 0} Unit",
          style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 13),
        ),
      ],
    );
  }

  /// 2c. Deskripsi Produk
  Widget _buildDescription(ProductModel product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Deskripsi Produk",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Text(
          product.fullDescription ?? "Tidak ada deskripsi detail untuk produk ini.",
          style: const TextStyle(height: 1.6, color: Color(0xFF636E72), fontSize: 14), // Text Grey
        ),
      ],
    );
  }
  
  /// 2d. Ulasan Terbaru
  Widget _buildReviews(ProductModel product) {
    final reviews = product.recentReviews ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Ulasan (${product.reviewCount})",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            if (product.reviewCount > 0)
              GestureDetector(
                onTap: controller.goToAllReviews,
                child: const Text("Lihat Semua", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
              ),
          ],
        ),
        const SizedBox(height: 16),
        if (reviews.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text("Belum ada ulasan.", style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
          ),
        
        ...reviews.map((review) => _buildReviewTile(review)).toList(),
      ],
    );
  }
  
  Widget _buildReviewTile(ProductReviewModel review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: Colors.grey.shade300,
                child: const FaIcon(FontAwesomeIcons.solidUser, size: 12, color: Colors.grey),
              ),
              const SizedBox(width: 10),
              Text(review.userName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const Spacer(),
              FaIcon(FontAwesomeIcons.solidStar, size: 10, color: Colors.amber.shade600),
              const SizedBox(width: 4),
              Text(review.rating.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            review.comment,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Color(0xFF636E72), fontSize: 13),
          ),
        ],
      ),
    );
  }

  /// 3. Bottom CTA Bar (Sticky di bawah)
  Widget _buildBottomActionBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Kontrol Kuantitas
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F6F8),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Obx(() => Row(
                children: [
                  IconButton(
                    onPressed: controller.quantity.value > 1 ? controller.decrementQuantity : null,
                    icon: Icon(Icons.remove, size: 18, color: controller.quantity.value > 1 ? Colors.black : Colors.grey),
                  ),
                  Text(
                    controller.quantity.value.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  IconButton(
                    onPressed: controller.incrementQuantity,
                    icon: const Icon(Icons.add, size: 18, color: AppColors.primary),
                  ),
                ],
              )),
            ),
            const SizedBox(width: 16),
            
            // Tombol Add to Cart
            Expanded(
              child: SizedBox(
                height: 50,
                child: Obx(() => ElevatedButton(
                  onPressed: controller.isAddingToCart.value ? null : controller.addToCart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: controller.isAddingToCart.value
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FaIcon(FontAwesomeIcons.bagShopping, size: 18),
                            SizedBox(width: 10),
                            Text("Tambah Keranjang", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          ],
                        ),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}