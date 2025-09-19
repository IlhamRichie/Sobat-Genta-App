// lib/data/models/order_tracking_event_model.dart
// (Buat file baru)
import 'package:intl/intl.dart';

class OrderTrackingEventModel {
  final String statusTitle;
  final String description;
  final DateTime timestamp;

  OrderTrackingEventModel({
    required this.statusTitle,
    required this.description,
    required this.timestamp,
  });

  String get formattedDate => DateFormat('d MMM yyyy', 'id_ID').format(timestamp);
  String get formattedTime => DateFormat('HH:mm', 'id_ID').format(timestamp);

  factory OrderTrackingEventModel.fromJson(Map<String, dynamic> json) {
    return OrderTrackingEventModel(
      statusTitle: json['status_title'],
      description: json['description'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}