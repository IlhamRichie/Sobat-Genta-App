// lib/data/repositories/implementations/fake_order_repository.dart
// (Buat file baru)
import 'package:get/get.dart';

import '../../../services/cart_service.dart';
import '../../models/address_model.dart';
import '../../models/cart_item_model.dart';
import '../../models/order_model.dart';
import '../../models/order_tracking_event_model.dart';
import '../abstract/cart_repository.dart';
import '../abstract/order_repository.dart';
import '../abstract/wallet_repository.dart';

class FakeOrderRepository implements IOrderRepository {

  // Repo ini butuh dependensi ke repo lain (simulasi transaksi backend)
  final IWalletRepository _walletRepo = Get.find<IWalletRepository>();
  final ICartRepository _cartRepo = Get.find<ICartRepository>();

  final CartService _cartService = Get.find<CartService>(); // Inject Service

  // --- DATABASE RIWAYAT ORDER PALSU (STATEFUL) ---
  final List<Map<String, dynamic>> _mockOrderDatabase = List.generate(25, (i) {
      // Buat 25 order palsu
      String status;
      if (i == 0) status = "PAID"; // Order terbaru
      else if (i < 5) status = "SHIPPED";
      else status = "COMPLETED";
      
      return {
        "order_id": "ORD-100${25 - i}",
        "order_date": DateTime.now().subtract(Duration(days: i * 2)).toIso8601String(),
        "grand_total": (i + 1) * 50000.0,
        "status": status,
      };
  });

  // Ambil 1 alamat palsu untuk semua order (penyederhanaan)
  final Map<String, dynamic> _mockAddress = {
      "address_id": "ADDR-001", "label": "Rumah", "recipient_name": "User Genta",
      "phone_number": "08123", "address_detail": "Jl. Genta", "city": "Yogya",
      "postal_code": "55200", "is_primary": true,
  };

  final Map<String, List<Map<String, dynamic>>> _mockOrderItemsDB = {
    // Item untuk pesanan terbaru (ORD-10025)
    "ORD-10025": [
      {
        "cart_item_id": "CI-001", "quantity": 2,
        "product": {
          "product_id": "PROD-002", "name": "Bibit Bawang Merah (Super)",
          "price": 45000.0, "image_url": null,
          "average_rating": 0.0, "review_count": 0
        }
      },
      {
        "cart_item_id": "CI-002", "quantity": 1,
        "product": {
          "product_id": "PROD-001", "name": "Pupuk NPK Mutiara (Repack 1kg)",
          "price": 18000.0, "image_url": null,
          "average_rating": 0.0, "review_count": 0
        }
      }
    ],
    // Item untuk pesanan lain
    //  "ORD-10024": [
    //    { "cart_item_id": "CI-003", "quantity": 1, "product": { ... } }
    //  ]
  };

  final Map<String, List<Map<String, dynamic>>> _mockTrackingEventsDB = {
    // Tracking untuk ORD-10025
    "ORD-10025": [
      {"status_title": "Diproses Penjual", "description": "Pesanan Anda sedang disiapkan.", "timestamp": "2024-11-20T11:00:00Z"},
      {"status_title": "Pembayaran Dikonfirmasi", "description": "Pembayaran Anda (Genta Wallet) telah berhasil.", "timestamp": "2024-11-20T10:59:00Z"}
    ],
    // Tracking untuk ORD-10024 (yang SHIPPED)
    "ORD-10024": [
      {"status_title": "Dikirim", "description": "Paket diserahkan ke Kurir XYZ (Resi: JP123456)", "timestamp": "2024-11-18T17:00:00Z"},
      {"status_title": "Siap Dikirim", "description": "Paket sudah dikemas.", "timestamp": "2024-11-18T14:00:00Z"},
      {"status_title": "Pembayaran Dikonfirmasi", "description": "Pembayaran Anda telah berhasil.", "timestamp": "2024-11-18T11:00:00Z"}
    ]
  };

  @override
  Future<OrderModel> createOrder({
    required AddressModel address,
    required List<CartItemModel> items,
    required double subtotal,
    required double shippingCost,
    required String paymentMethod,
  }) async {
    await Future.delayed(const Duration(seconds: 2)); // Simulasi proses API
    
    double grandTotal = subtotal + shippingCost;
    String orderStatus = "PENDING_PAYMENT";

    if (paymentMethod == 'WALLET') {
      // 1. Coba debit dompet
      try {
        await _walletRepo.debitWallet(grandTotal);
        orderStatus = "PAID"; // Langsung lunas
      } catch (e) {
        rethrow; // Lempar error (cth: Saldo kurang) kembali ke controller
      }
    } else {
      orderStatus = "PENDING_PAYMENT";
    }

    // Buat data JSON palsu untuk disimpan di database palsu kita
    final newOrderJson = {
      "order_id": "ORD-${DateTime.now().millisecondsSinceEpoch}",
      "order_date": DateTime.now().toIso8601String(),
      "grand_total": grandTotal,
      "status": orderStatus,
    };
    
    // Simpan ke 'database' kita (taruh di paling atas)
    _mockOrderDatabase.insert(0, newOrderJson);

    // 2. Kosongkan keranjang (Data & State)
    await _cartRepo.clearMyCart();
    await _cartService.clearCartLocalState();

    // 3. Buat objek OrderModel LENGKAP untuk dikirim ke halaman Konfirmasi
    
    // --- PERBAIKAN DI SINI ---
    // Kita harus melakukan cast eksplisit 'as String'
    return OrderModel(
      orderId: newOrderJson['order_id'] as String,
      orderDate: DateTime.parse(newOrderJson['order_date'] as String),
      grandTotal: grandTotal, // Ini sudah bertipe double
      status: orderStatus,   // Ini sudah bertipe String
      shippingAddress: address,
      items: items, // Kirim item lengkap ke halaman sukses
    );
  } 
  
  @override
  Future<List<OrderModel>> getMyOrders(int page, {int limit = 10}) async {
    await Future.delayed(const Duration(milliseconds: 900));

    // Logika Pagination Palsu (sama seperti ProductReviews)
    final startIndex = (page - 1) * limit;
    if (startIndex >= _mockOrderDatabase.length) {
      return []; // Halaman habis
    }
    
    final endIndex = (startIndex + limit > _mockOrderDatabase.length)
        ? _mockOrderDatabase.length
        : (startIndex + limit);
        
    final pageData = _mockOrderDatabase.sublist(startIndex, endIndex);
    
    // Konversi ke OrderModel (VERSI LIST = 'items' DIBUAT NULL)
    return pageData.map((json) => OrderModel(
      orderId: json['order_id'],
      orderDate: DateTime.parse(json['order_date']),
      grandTotal: json['grand_total'],
      status: json['status'],
      shippingAddress: AddressModel.fromJson(_mockAddress), // Kita butuh alamat untuk list
      items: null, // <-- PENTING: data item tidak di-load di list
    )).toList();
  }

  @override
  Future<OrderModel> getOrderDetailById(String orderId) async {
    await Future.delayed(const Duration(milliseconds: 700));

    // 1. Ambil data order dasar
    final baseOrderJson = _mockOrderDatabase.firstWhere(
      (o) => o['order_id'] == orderId,
      orElse: () => throw Exception("Pesanan tidak ditemukan"),
    );
    
    // 2. Ambil data items
    final itemsJson = _mockOrderItemsDB[orderId] ?? [];
    final items = itemsJson.map((json) => CartItemModel.fromJson(json)).toList();
    
    // 3. Ambil data tracking
    final trackingJson = _mockTrackingEventsDB[orderId] ?? [];
    final tracking = trackingJson.map((json) => OrderTrackingEventModel.fromJson(json)).toList();

    // 4. Gabungkan (Enrich)
    return OrderModel(
      orderId: baseOrderJson['order_id'],
      orderDate: DateTime.parse(baseOrderJson['order_date']),
      grandTotal: baseOrderJson['grand_total'],
      status: baseOrderJson['status'],
      shippingAddress: AddressModel.fromJson(_mockAddress), // Pakai alamat mock
      items: items, // <-- Data "Berat" sudah diisi
      trackingEvents: tracking, // <-- Data "Berat" sudah diisi
    );
  }
}