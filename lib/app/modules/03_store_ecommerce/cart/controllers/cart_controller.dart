// lib/app/modules/cart/controllers/cart_controller.dart

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../data/models/cart_item_model.dart';
import '../../../../routes/app_pages.dart';
import '../../../../services/cart_service.dart';

class CartController extends GetxController {

  // --- DEPENDENCY TUNGGAL KE SERVICE ---
  // Controller ini tidak berbicara ke Repository.
  // Dia hanya berbicara ke Service.
  final CartService cartService = Get.find<CartService>();
  
  // Helper
  final rupiahFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  // --- GETTERS (Membaca state dari Service) ---
  RxList<CartItemModel> get items => cartService.cartItems;
  RxDouble get totalPrice => cartService.cartTotalPrice;
  RxInt get totalItems => cartService.totalItemsCount;
  
  // --- METODE AKSI (Meneruskan perintah ke Service) ---

  void incrementQuantity(CartItemModel item) {
    int newQty = item.quantity + 1;
    // TODO: Cek stok (item.product.stockQuantity)
    cartService.updateItemQuantity(item.cartItemId, newQty);
  }

  void decrementQuantity(CartItemModel item) {
    if (item.quantity > 1) {
      int newQty = item.quantity - 1;
      cartService.updateItemQuantity(item.cartItemId, newQty);
    }
  }

  void removeItem(CartItemModel item) {
    Get.defaultDialog(
      title: "Hapus Item",
      middleText: "Anda yakin ingin menghapus ${item.product.name} dari keranjang?",
      textConfirm: "Ya, Hapus",
      textCancel: "Batal",
      onConfirm: () {
        Get.back();
        cartService.removeItemFromCart(item.cartItemId);
      },
    );
  }
  
  void goToCheckout() {
    if (items.isEmpty) {
      Get.snackbar("Keranjang Kosong", "Silakan belanja terlebih dahulu.");
      return;
    }
    // Lanjut ke Epic 2, Langkah 6
    Get.toNamed(Routes.CHECKOUT_ADDRESS);
  }
}