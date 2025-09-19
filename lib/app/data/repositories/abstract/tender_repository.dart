// lib/data/repositories/abstract/tender_repository.dart
// (Buat file baru)

import '../../models/tender_offer_model.dart';
import '../../models/tender_request_model.dart';

abstract class ITenderRepository {
  /// Mengambil daftar tender yang aktif (dengan pagination)
  Future<List<TenderRequestModel>> getActiveTenders(int page, {int limit = 10});

  Future<void> createTenderRequest(Map<String, dynamic> tenderData);

  Future<TenderRequestModel> getTenderDetailById(String requestId);

  Future<void> submitTenderOffer(Map<String, dynamic> offerData);

  Future<List<TenderOfferModel>> getMySubmittedOffers(int page, {int limit = 10});
  
  // (Nanti kita akan tambah: createTender, getTenderById, submitOffer)
}