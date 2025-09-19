// lib/app/services/cart_service.dart
// (Buat file baru)
import 'package:get/get.dart';

import '../data/models/cart_item_model.dart';
import '../data/models/product_model.dart';
import '../data/repositories/abstract/cart_repository.dart';

class CartService extends GetxService {
  final ICartRepository _cartRepo = Get.find<ICartRepository>();

  // --- STATE REAKTIF GLOBAL ---
  final RxBool isLoading = false.obs;
  final RxList<CartItemModel> cartItems = <CartItemModel>[].obs;
  
  // --- STATE TURUNAN (DERIVED STATE) ---
  /// Total jumlah item unik (untuk badge di AppBar)
  RxInt get totalItemsCount => cartItems.length.obs;
  
  /// Total harga keranjang
  final RxDouble cartTotalPrice = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    loadCartData(); // Muat keranjang saat aplikasi dimulai
  }

  /// Menghitung ulang total harga
  void _calculateTotal() {
    double total = 0.0;
    for (var item in cartItems) {
      total += item.subTotal;
    }
    cartTotalPrice.value = total;
  }

  /// 1. Mengambil data keranjang dari Repo
  Future<void> loadCartData() async {
    isLoading.value = true;
    try {
      final items = await _cartRepo.getMyCartItems();
      cartItems.assignAll(items);
      _calculateTotal();
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat keranjang.");
    } finally {
      isLoading.value = false;
    }
  }

  /// 2. Menambah item (Dipanggil dari ProductDetail)
  Future<void> addItemToCart(ProductModel product, int quantity) async {
    try {
      await _cartRepo.addToCart(product.productId, quantity);
      // PENTING: Setelah API call sukses, kita muat ulang seluruh keranjang
      // untuk mendapatkan data terbaru (termasuk cart_item_id baru)
      await loadCartData(); 
    } catch (e) {
      Get.snackbar("Error", "Gagal menambah ke keranjang: $e");
    }
  }
  
  /// 3. Update Kuantitas (Dipanggil dari CartView)
  Future<void> updateItemQuantity(String cartItemId, int newQuantity) async {
    // Optimistic UI update
    final index = cartItems.indexWhere((item) => item.cartItemId == cartItemId);
    if (index != -1) {
      cartItems[index].quantity = newQuantity;
      _calculateTotal(); // Hitung ulang total
      cartItems.refresh(); // Paksa update list
    }
    
    // Panggil API di background
    try {
      await _cartRepo.updateCartItemQuantity(cartItemId, newQuantity);
    } catch (e) {
      Get.snackbar("Gagal", "Gagal update kuantitas. Memuat ulang...");
      await loadCartData(); // Rollback jika gagal
    }
  }
  
  /// 4. Hapus Item (Dipanggil dari CartView)
  Future<void> removeItemFromCart(String cartItemId) async {
    try {
      // Optimistic UI
      cartItems.removeWhere((item) => item.cartItemId == cartItemId);
      _calculateTotal();
      
      await _cartRepo.removeCartItem(cartItemId);
    } catch (e) {
      Get.snackbar("Gagal", "Gagal menghapus item. Memuat ulang...");
      await loadCartData(); // Rollback jika gagal
    }
  }

  Future<void> clearCartLocalState() async {
    // Ini hanya membersihkan state lokal, repo dipanggil oleh OrderRepo
     cartItems.clear();
    _calculateTotal();
  }
}