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
      appBar: AppBar(
        title: const Text("Keranjang Saya"),
      ),
      bottomNavigationBar: _buildCheckoutBar(),
      body: Obx(() {
        if (controller.items.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(FontAwesomeIcons.cartArrowDown, size: 80, color: AppColors.greyLight),
                SizedBox(height: 16),
                Text("Keranjang Anda kosong."),
              ],
            ),
          );
        }
        
        // Render List Item
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.items.length,
          itemBuilder: (context, index) {
            final item = controller.items[index];
            return _buildCartItemCard(item);
          },
        );
      }),
    );
  }

  /// Kartu untuk satu item di keranjang
  Widget _buildCartItemCard(CartItemModel item) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Gambar
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                color: AppColors.greyLight,
                borderRadius: BorderRadius.circular(8),
                // TODO: Image.network(item.product.imageUrl)
              ),
              child: const Center(child: FaIcon(FontAwesomeIcons.image, color: Colors.grey)),
            ),
            const SizedBox(width: 12),
            // Info & Kuantitas
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    controller.rupiahFormatter.format(item.product.price),
                    style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  // Kontrol Kuantitas
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Tombol +/-
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              onPressed: () => controller.decrementQuantity(item),
                              icon: FaIcon(FontAwesomeIcons.minus, size: 14, color: item.quantity > 1 ? AppColors.textDark : Colors.grey),
                            ),
                            Text(item.quantity.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              onPressed: () => controller.incrementQuantity(item),
                              icon: const FaIcon(FontAwesomeIcons.plus, size: 14, color: AppColors.primary),
                            ),
                          ],
                        ),
                      ),
                      // Tombol Hapus
                      IconButton(
                        icon: FaIcon(FontAwesomeIcons.trashCan, color: Colors.red.shade700, size: 20),
                        onPressed: () => controller.removeItem(item),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  /// Bar Checkout di bagian bawah
  Widget _buildCheckoutBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
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
                  style: Get.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                )),
              ],
            ),
            // Tombol Checkout
            FilledButton(
              onPressed: controller.goToCheckout,
              child: const Text("Checkout"),
            ),
          ],
        ),
      ),
    );
  }
}