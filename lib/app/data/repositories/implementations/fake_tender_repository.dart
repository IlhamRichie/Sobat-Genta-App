// lib/data/repositories/implementations/fake_tender_repository.dart
// (Buat file baru)

import 'package:get/get.dart';

import '../../../services/session_service.dart';
import '../../models/tender_offer_model.dart';
import '../../models/tender_request_model.dart';
import '../abstract/tender_repository.dart';

class FakeTenderRepository implements ITenderRepository {

  final SessionService _sessionService = Get.find<SessionService>();

  // --- DATABASE TENDER PALSU (STATEFUL) ---
  final List<Map<String, dynamic>> _mockTenderDB = List.generate(30, (i) {
    // Buat 30 tender palsu
    String category;
    String title;
    if (i % 3 == 0) {
      category = "Pakan Ternak";
      title = "Dibutuhkan: ${i+1}0 Ton Pakan Sapi Konsentrat";
    } else if (i % 2 == 0) {
      category = "Jasa";
      title = "Dibutuhkan: Jasa Sewa Traktor (2 Hektar)";
    } else {
      category = "Bibit/Pupuk";
      title = "Dibutuhkan: Pemasok Sekam Mentah (Rutinan)";
    }
    
    return {
      "request_id": "TDR-${30-i}",
      "title": title,
      "category": category,
      "target_budget": (i + 1) * 1000000.0,
      "deadline": DateTime.now().add(Duration(days: i + 2)).toIso8601String(),
      "requestor_name": "Petani Budi ${i+1}",
      "total_offers_count": i % 5, // Jumlah penawar palsu
    };
  });

  final Map<String, List<Map<String, dynamic>>> _mockOfferDB = {
    // Penawaran untuk tender "TDR-29" (Jasa Sewa Traktor)
    "TDR-29": [
      {
        "offer_id": "OFF-001",
        "supplier_name": "CV. Tani Maju",
        "offer_price": 2400000.0,
        "notes": "Harga sudah termasuk operator dan BBM.",
        "timestamp": "2024-11-15T10:00:00Z"
      },
      {
        "offer_id": "OFF-002",
        "supplier_name": "Juragan Traktor",
        "offer_price": 2250000.0,
        "notes": "Unit ready, bisa mulai besok.",
        "timestamp": "2024-11-16T09:00:00Z"
      }
    ],
    // Tender "TDR-30" belum ada penawaran
    "TDR-30": [],
  };

  final List<Map<String, dynamic>> _mockMyOffersDB = List.generate(25, (i) {
    String status = (i == 0) ? "ACCEPTED" : (i == 1 ? "REJECTED" : "PENDING");
    return {
      "offer_id": "MY-OFF-${i+1}",
      "offer_price": (i+1) * 100000.0,
      "notes": "Ini adalah penawaran saya nomor #${i+1}",
      "timestamp": DateTime.now().subtract(Duration(days: i)).toIso8601String(),
      "status": status,
      "tender_request": { // Data Induk yang di-JOIN
        "request_id": "TDR-FAKE-${i+1}",
        "title": "Permintaan Tender Palsu #${i+1}",
        "category": "Jasa",
        "deadline": DateTime.now().add(Duration(days: 5)).toIso8601String(),
        "requestor_name": "Petani Lain"
        // Catatan: API tidak perlu menumpuk 'offers' lagi di dalam sini
      }
    };
  });



  // --- IMPLEMENTASI METODE BARU (PAGINATION) ---
  @override
  Future<List<TenderRequestModel>> getActiveTenders(int page, {int limit = 10}) async {
    await Future.delayed(const Duration(milliseconds: 900));

    // Logika Pagination Palsu (Identik dengan OrderHistory)
    final startIndex = (page - 1) * limit;
    if (startIndex >= _mockTenderDB.length) {
      return []; // Halaman habis
    }
    
    final endIndex = (startIndex + limit > _mockTenderDB.length)
        ? _mockTenderDB.length
        : (startIndex + limit);
        
    final pageData = _mockTenderDB.sublist(startIndex, endIndex);
    
    return pageData.map((json) => TenderRequestModel.fromJson(json)).toList();
  }

  @override
  Future<void> createTenderRequest(Map<String, dynamic> tenderData) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulasi API call

    final String requestorName = _sessionService.currentUser.value?.fullName ?? "User Genta";
    
    // 1. Buat data JSON palsu baru
    final newTender = {
      "request_id": "TDR-NEW-${DateTime.now().millisecondsSinceEpoch}",
      "title": tenderData['title'],
      "category": tenderData['category'],
      "target_budget": tenderData['target_budget'],
      "deadline": tenderData['deadline'], // Ini adalah string ISO
      "requestor_name": requestorName, // Ambil dari sesi
      "total_offers_count": 0, // Tender baru belum ada penawaran
    };
    
    // 2. Tambahkan ke 'database' palsu kita di paling atas
    _mockTenderDB.insert(0, newTender);
    
    print("Fake DB: Tender Request baru ditambahkan.");
    return;
  }

  @override
  Future<TenderRequestModel> getTenderDetailById(String requestId) async {
    await Future.delayed(const Duration(milliseconds: 600));

    // 1. Ambil data tender dasar
    final baseTenderJson = _mockTenderDB.firstWhere(
      (t) => t['request_id'] == requestId,
      orElse: () => throw Exception("Tender tidak ditemukan"),
    );

    // 2. Tambahkan data detail (enrichment)
    baseTenderJson['full_description'] = "Deskripsi lengkap untuk ${baseTenderJson['title']}. Kami membutuhkan pasokan rutin dan siap kontrak jangka panjang. Kualitas adalah prioritas utama.";
    
    // 3. Ambil dan gabungkan data penawaran (JOIN palsu)
    baseTenderJson['offers'] = _mockOfferDB[requestId] ?? [];

    return TenderRequestModel.fromJson(baseTenderJson);
  }

  @override
  Future<void> submitTenderOffer(Map<String, dynamic> offerData) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulasi API
    
    String requestId = offerData['request_id'];
    
    // 1. Buat data penawaran palsu baru
    final newOffer = {
      "offer_id": "OFF-${DateTime.now().millisecondsSinceEpoch}",
      "supplier_name": _sessionService.currentUser.value?.fullName ?? "Supplier Misterius",
      "offer_price": offerData['offer_price'],
      "notes": offerData['notes'],
      "timestamp": DateTime.now().toIso8601String()
    };

    // 2. Tambahkan ke 'database' palsu kita
    if (_mockOfferDB.containsKey(requestId)) {
      _mockOfferDB[requestId]!.add(newOffer);
    } else {
      _mockOfferDB[requestId] = [newOffer];
    }
    
    // 3. Update juga jumlah 'total_offers_count' di data tender utama
    final tenderIndex = _mockTenderDB.indexWhere((t) => t['request_id'] == requestId);
    if (tenderIndex != -1) {
      int currentOffers = _mockTenderDB[tenderIndex]['total_offers_count'];
      _mockTenderDB[tenderIndex]['total_offers_count'] = currentOffers + 1;
    }
    
    print("Fake DB: Offer baru ditambahkan ke $requestId.");
  }

  @override
  Future<List<TenderOfferModel>> getMySubmittedOffers(int page, {int limit = 10}) async {
    await Future.delayed(const Duration(milliseconds: 900));

    // Logika Pagination Palsu (Identik dengan OrderHistory)
    final startIndex = (page - 1) * limit;
    if (startIndex >= _mockMyOffersDB.length) {
      return []; // Halaman habis
    }
    
    final endIndex = (startIndex + limit > _mockMyOffersDB.length)
        ? _mockMyOffersDB.length
        : (startIndex + limit);
        
    final pageData = _mockMyOffersDB.sublist(startIndex, endIndex);
    
    // Gunakan factory TenderOfferModel.fromJson (yang sekarang mengharapkan data nested)
    return pageData.map((json) => TenderOfferModel.fromJson(json)).toList();
  }
}