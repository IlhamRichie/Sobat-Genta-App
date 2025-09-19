// lib/data/models/tender_request_model.dart
// (Buat file baru)
import 'package:intl/intl.dart';

import 'tender_offer_model.dart';

class TenderRequestModel {
  final String requestId;
  final String title;
  final String category;
  final double? targetBudget; // Budget bisa opsional
  final DateTime deadline;
  final String requestorName; // Hasil JOIN dengan tabel user
  final int totalOffers; // Hasil COUNT dari 'tenderoffers'

  final String? fullDescription;
  final List<TenderOfferModel>? offers;

  TenderRequestModel({
    required this.requestId,
    required this.title,
    required this.category,
    this.targetBudget,
    required this.deadline,
    required this.requestorName,
    this.totalOffers = 0,

    this.fullDescription,
    this.offers,
  });

  String get formattedDeadline => DateFormat('d MMM yyyy', 'id_ID').format(deadline);
  bool get isExpired => DateTime.now().isAfter(deadline);

  factory TenderRequestModel.fromJson(Map<String, dynamic> json) {
    // Parsing list penawaran (jika ada)
    List<TenderOfferModel> parsedOffers = [];
    if (json['offers'] != null && json['offers'] is List) {
      parsedOffers = (json['offers'] as List)
          .map((item) => TenderOfferModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    
    return TenderRequestModel(
      requestId: json['request_id'].toString(),
      title: json['title'],
      category: json['category'],
      targetBudget: (json['target_budget'] as num?)?.toDouble(),
      deadline: DateTime.parse(json['deadline']),
      requestorName: json['requestor_name'] ?? 'Petani Genta',
      totalOffers: (json['total_offers_count'] as num?)?.toInt() ?? parsedOffers.length,
      
      // --- Parsing data detail ---
      fullDescription: json['full_description'],
      offers: parsedOffers,
    );
  }
}