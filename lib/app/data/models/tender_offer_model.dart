// lib/data/models/tender_offer_model.dart
// (Buat file baru)
import 'package:intl/intl.dart';

import 'tender_request_model.dart';

enum OfferStatus { PENDING, ACCEPTED, REJECTED, UNKNOWN }

class TenderOfferModel {
  final String offerId;
  final String supplierName; // Hasil JOIN user
  final double offerPrice;
  final String notes;
  final DateTime timestamp;

  final OfferStatus status;
  final TenderRequestModel tenderRequest;

  TenderOfferModel({
    required this.offerId,
    required this.supplierName,
    required this.offerPrice,
    required this.notes,
    required this.timestamp,

    required this.status,
    required this.tenderRequest,
  });
  
  String get formattedDate => DateFormat('d MMM yyyy', 'id_ID').format(timestamp);

  factory TenderOfferModel.fromJson(Map<String, dynamic> json) {
    return TenderOfferModel(
      offerId: json['offer_id'].toString(),
      supplierName: json['supplier_name'] ?? 'Supplier Genta',
      offerPrice: (json['offer_price'] as num).toDouble(),
      notes: json['notes'] ?? '',
      timestamp: DateTime.parse(json['timestamp']),
      status: _parseStatus(json['status']), // <-- TAMBAHKAN INI
      // API backend HARUS melakukan JOIN dan menyertakan data induk tender
      tenderRequest: TenderRequestModel.fromJson(json['tender_request'] as Map<String, dynamic>),
    );
  }

  static OfferStatus _parseStatus(String? status) {
    switch(status?.toUpperCase()) {
      case 'ACCEPTED': return OfferStatus.ACCEPTED;
      case 'REJECTED': return OfferStatus.REJECTED;
      case 'PENDING':
      default: return OfferStatus.PENDING;
    }
  }
}