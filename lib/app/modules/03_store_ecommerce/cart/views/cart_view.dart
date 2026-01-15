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
      backgroundColor: const Color(0xFFF5F6F8), // Background abu sangat muda
      appBar: _buildAppBar(),
      bottomNavigationBar: _buildCheckoutBar(),
      body: Obx(() {
        if (controller.items.isEmpty) {
          return _buildEmptyState();
        }
        
        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          itemCount: controller.items.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final item = controller.items[index];
            return _buildCartItemCard(item);
          },
        );
      }),
    );
  }

  /// AppBar Minimalis & Clean
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.black),
        onPressed: () => Get.back(),
      ),
      title: Text(
        "Keranjang Saya",
        style: Get.textTheme.titleLarge?.copyWith(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      actions: [
        // Indikator jumlah items
        Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Obx(() => Text(
              "${controller.items.length} Item",
              style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
            )),
          ),
        )
      ],
    );
  }

  /// Empty State yang Lebih Menarik Visualnya
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const FaIcon(FontAwesomeIcons.basketShopping, size: 60, color: AppColors.primary),
            ),
            const SizedBox(height: 24),
            Text(
              "Keranjang Masih Kosong",
              style: Get.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Sepertinya kamu belum menambahkan produk apapun. Yuk mulai belanja kebutuhan tanimu!",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, height: 1.5),
            ),
            const SizedBox(height: 32),
            OutlinedButton(
              onPressed: () => Get.back(), // Asumsi back ke Store
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: const Text("Mulai Belanja", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
            )
          ],
        ),
      ),
    );
  }

  /// Kartu Item Keranjang - Versi Josjis
  Widget _buildCartItemCard(CartItemModel item) {
    return Dismissible(
      key: Key(item.cartItemId.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: FaIcon(FontAwesomeIcons.trashCan, color: Colors.red.shade700),
      ),
      confirmDismiss: (direction) async {
        controller.removeItem(item); // Panggil fungsi hapus
        return false; // Return false biar UI direfresh via Obx controller aja
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Gambar Produk dengan ClipRRect
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 90,
                height: 90,
                color: Colors.grey.shade100,
                child: (item.product.imageUrl != null && item.product.imageUrl!.isNotEmpty)
                    ? Image.network(
                        item.product.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, err, stack) => const Center(child: FaIcon(FontAwesomeIcons.image, size: 30, color: Colors.grey)),
                      )
                    : const Center(child: FaIcon(FontAwesomeIcons.image, size: 30, color: Colors.grey)),
              ),
            ),
            const SizedBox(width: 16),
            
            // 2. Detail Produk
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      // Tombol Hapus Kecil
                      InkWell(
                        onTap: () => controller.removeItem(item),
                        child: Icon(Icons.close, size: 18, color: Colors.grey.shade400),
                      )
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Kategori atau Info tambahan (Opsional)
                  Text(
                    "Stok Tersedia: ${item.product.stockQuantity}",
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  
                  // 3. Harga & Kontrol Kuantitas
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        controller.rupiahFormatter.format(item.product.price),
                        style: const TextStyle(
                          color: AppColors.primary, 
                          fontWeight: FontWeight.w800, 
                          fontSize: 15
                        ),
                      ),
                      
                      // Widget Plus Minus
                      Container(
                        height: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F6F8),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          children: [
                            _buildQtyBtn(
                              icon: Icons.remove, 
                              onTap: () => controller.decrementQuantity(item),
                              isActive: item.quantity > 1
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                "${item.quantity}",
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            _buildQtyBtn(
                              icon: Icons.add, 
                              onTap: () => controller.incrementQuantity(item),
                              isActive: true,
                              isPlus: true
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQtyBtn({required IconData icon, required VoidCallback onTap, required bool isActive, bool isPlus = false}) {
    return InkWell(
      onTap: isActive ? onTap : null,
      child: Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isPlus ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.horizontal(
            left: isPlus ? Radius.zero : const Radius.circular(7),
            right: isPlus ? const Radius.circular(7) : Radius.zero,
          ),
        ),
        child: Icon(
          icon, 
          size: 14, 
          color: isPlus ? Colors.white : (isActive ? Colors.black87 : Colors.grey)
        ),
      ),
    );
  }

  /// Checkout Bar Melayang
  Widget _buildCheckoutBar() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Row Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total Pembayaran", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
                Obx(() => Text(
                  controller.rupiahFormatter.format(controller.totalPrice.value),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                )),
              ],
            ),
            const SizedBox(height: 16),
            
            // Tombol Checkout Lebar
            SizedBox(
              width: double.infinity,
              height: 52,
              child: Obx(() => ElevatedButton(
                onPressed: controller.items.isEmpty ? null : controller.goToCheckout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey.shade300,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text(
                  "Checkout Sekarang",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }
}