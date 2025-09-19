// lib/app/modules/checkout_payment/controllers/checkout_payment_controller.dart

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:flutter/material.dart';

import '../../../../data/models/address_model.dart';
import '../../../../data/models/cart_item_model.dart';
import '../../../../data/models/wallet_model.dart';
import '../../../../data/repositories/abstract/order_repository.dart';
import '../../../../data/repositories/abstract/wallet_repository.dart';
import '../../../../routes/app_pages.dart';
import '../../../../services/cart_service.dart'; // Untuk Overlay

class CheckoutPaymentController extends GetxController {

  // --- DEPENDENCIES ---
  final CartService cartService = Get.find<CartService>();
  final IOrderRepository _orderRepo = Get.find<IOrderRepository>();
  final IWalletRepository _walletRepo = Get.find<IWalletRepository>();

  // --- DATA STATE (dari sumber berbeda) ---
  late final AddressModel selectedAddress;
  late final RxList<CartItemModel> cartItems;
  late final RxDouble cartSubtotal;
  final Rx<WalletModel?> myWallet = Rxn<WalletModel>();
  
  // Data palsu untuk Ongkir (Pragmatic Shortcut)
  final double shippingCost = 15000.0; 

  // --- UI STATE ---
  final RxBool isLoadingWallet = true.obs;
  final RxBool isPlacingOrder = false.obs;
  final RxString selectedPaymentMethod = 'WALLET'.obs; // 'WALLET' atau 'GATEWAY'
  
  // Helper
  final rupiahFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  // --- STATE TURUNAN (Computed) ---
  double get grandTotal => cartSubtotal.value + shippingCost;
  bool get canPayWithWallet => (myWallet.value?.balance ?? 0) >= grandTotal;

  @override
  void onInit() {
    super.onInit();
    // 1. Ambil alamat dari argumen
    selectedAddress = Get.arguments['selected_address'] as AddressModel;
    // 2. Hubungkan ke state global CartService
    cartItems = cartService.cartItems;
    cartSubtotal = cartService.cartTotalPrice;
    // 3. Ambil data dompet untuk validasi
    _fetchWalletBalance();
  }

  Future<void> _fetchWalletBalance() async {
    isLoadingWallet.value = true;
    try {
      myWallet.value = await _walletRepo.getMyWallet();
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat saldo dompet.");
    } finally {
      isLoadingWallet.value = false;
    }
  }

  /// Aksi saat user memilih metode pembayaran
  void selectPaymentMethod(String? method) {
    if (method != null) {
      // Jika memilih dompet tapi tidak bisa, jangan biarkan
      if (method == 'WALLET' && !canPayWithWallet) {
        Get.snackbar("Saldo Kurang", "Saldo dompet Anda tidak cukup untuk transaksi ini.");
        return;
      }
      selectedPaymentMethod.value = method;
    }
  }

  /// Aksi utama: Buat Pesanan
  Future<void> placeOrder() async {
    isPlacingOrder.value = true;
    try {
      // Panggil repo order
      final newOrder = await _orderRepo.createOrder(
        address: selectedAddress,
        items: cartItems.toList(), // Kirim snapshot list
        subtotal: cartSubtotal.value,
        shippingCost: shippingCost,
        paymentMethod: selectedPaymentMethod.value,
      );

      // Sukses! Navigasi ke Halaman Konfirmasi (Langkah 8)
      // Kita gunakan offAllNamed untuk MENGHAPUS semua stack checkout
      // (Detail, Cart, Address, Payment)
      Get.offAllNamed(Routes.ORDER_CONFIRMATION, arguments: newOrder);

    } catch (e) {
      // Error (misal: saldo tidak cukup dari repo)
      showTopSnackBar(
        Overlay.of(Get.context!),
        CustomSnackBar.error(message: e.toString().replaceAll("Exception: ", "")),
      );
    } finally {
      isPlacingOrder.value = false;
    }
  }
}