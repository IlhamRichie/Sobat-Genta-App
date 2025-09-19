// lib/data/models/tender_offer_model.dart
// (Buat file baru)
import 'package:intl/intl.dart';

class TenderOfferModel {
  final String offerId;
  final String supplierName; // Hasil JOIN user
  final double offerPrice;
  final String notes;
  final DateTime timestamp;

  TenderOfferModel({
    required this.offerId,
    required this.supplierName,
    required this.offerPrice,
    required this.notes,
    required this.timestamp,
  });
  
  String get formattedDate => DateFormat('d MMM yyyy', 'id_ID').format(timestamp);

  factory TenderOfferModel.fromJson(Map<String, dynamic> json) {
    return TenderOfferModel(
      offerId: json['offer_id'].toString(),
      supplierName: json['supplier_name'] ?? 'Supplier Genta',
      offerPrice: (json['offer_price'] as num).toDouble(),
      notes: json['notes'] ?? '',
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}