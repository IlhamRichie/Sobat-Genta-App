// lib/data/models/order_model.dart
// (Buat file baru)

import 'address_model.dart';
import 'cart_item_model.dart';
import 'order_tracking_event_model.dart';

class OrderModel {
  final String orderId;
  final DateTime orderDate;
  final double grandTotal;
  final String status; // Cth: "PAID" atau "PENDING_PAYMENT"
  final AddressModel shippingAddress;
  final List<CartItemModel>? items;

  final List<OrderTrackingEventModel>? trackingEvents;


  OrderModel({
    required this.orderId,
    required this.orderDate,
    required this.grandTotal,
    required this.status,
    required this.shippingAddress,
    this.items,

    this.trackingEvents,
  });
}