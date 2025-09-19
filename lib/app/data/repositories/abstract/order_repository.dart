// lib/data/repositories/abstract/order_repository.dart
// (Buat file baru)

import '../../models/address_model.dart';
import '../../models/cart_item_model.dart';
import '../../models/order_model.dart';

abstract class IOrderRepository {
  /// Membuat pesanan baru dari data keranjang & alamat
  Future<OrderModel> createOrder({
    required AddressModel address,
    required List<CartItemModel> items,
    required double subtotal,
    required double shippingCost,
    required String paymentMethod, // 'WALLET' atau 'GATEWAY'
  });

  Future<List<OrderModel>> getMyOrders(int page, {int limit = 10});

  Future<OrderModel> getOrderDetailById(String orderId);

}