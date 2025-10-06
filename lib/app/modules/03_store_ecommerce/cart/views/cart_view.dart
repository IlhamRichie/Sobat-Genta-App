// lib/app/modules/cart/views/cart_view.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../data/models/cart_item_model.dart';
import '../../../../theme/app_colors.dart';
import '../controllers/cart_controller.dart';

class CartView extends GetView<CartController> {
  const CartView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      bottomNavigationBar: _buildCheckoutBar(),
      body: Obx(() {
        if (controller.items.isEmpty) {
          return _buildEmptyState();
        }
        
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          itemCount: controller.items.length,
          itemBuilder: (context, index) {
            final item = controller.items[index];
            return _buildCartItemCard(item);
          },
        );
      }),
    );
  }

  /// AppBar Kustom
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      title: Text(
        "Keranjang Saya",
        style: Get.textTheme.headlineSmall?.copyWith(
          color: AppColors.textDark,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: false,
    );
  }

  /// Empty State yang Didesain Ulang
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FaIcon(FontAwesomeIcons.cartArrowDown, size: 96, color: AppColors.greyLight),
            const SizedBox(height: 32),
            Text(
              "Keranjang Anda Kosong",
              style: Get.textTheme.titleLarge?.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              "Yuk, jelajahi toko kami dan temukan produk menarik!",
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

  /// Kartu untuk satu item di keranjang (Didesain Ulang)
  Widget _buildCartItemCard(CartItemModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // Gambar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.greyLight,
              borderRadius: BorderRadius.circular(16),
              image: item.product.imageUrl != null && item.product.imageUrl!.isNotEmpty
                  ? DecorationImage(image: NetworkImage(item.product.imageUrl!), fit: BoxFit.cover)
                  : null,
            ),
            child: item.product.imageUrl == null || item.product.imageUrl!.isEmpty
                ? const Center(child: FaIcon(FontAwesomeIcons.image, color: Colors.grey))
                : null,
          ),
          const SizedBox(width: 16),
          // Info & Kuantitas
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  controller.rupiahFormatter.format(item.product.price),
                  style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 12),
                // Kontrol Kuantitas & Hapus
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.greyLight,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () => controller.decrementQuantity(item),
                            icon: FaIcon(FontAwesomeIcons.minus, size: 16, color: item.quantity > 1 ? AppColors.textDark : Colors.grey),
                          ),
                          Text(item.quantity.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          IconButton(
                            onPressed: () => controller.incrementQuantity(item),
                            icon: const FaIcon(FontAwesomeIcons.plus, size: 16, color: AppColors.primary),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: FaIcon(FontAwesomeIcons.trashCan, color: Colors.red.shade700, size: 20),
                      onPressed: () => controller.removeItem(item),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  /// Bar Checkout di bagian bawah (Didesain Ulang)
  Widget _buildCheckoutBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Total Harga
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Total Harga:", style: TextStyle(color: AppColors.textLight)),
                Obx(() => Text(
                      controller.rupiahFormatter.format(controller.totalPrice.value),
                      style: Get.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: 20),
                    )),
              ],
            ),
            // Tombol Checkout
            Obx(() => FilledButton(
                  onPressed: controller.items.isEmpty ? null : controller.goToCheckout,
                  style: FilledButton.styleFrom(
                    backgroundColor: controller.items.isEmpty ? AppColors.greyLight : AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text(
                    "Checkout",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}