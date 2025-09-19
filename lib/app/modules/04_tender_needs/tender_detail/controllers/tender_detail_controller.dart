// lib/app/modules/tender_detail/controllers/tender_detail_controller.dart

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../data/models/tender_request_model.dart';
import '../../../../data/repositories/abstract/tender_repository.dart';
import '../../../../routes/app_pages.dart';

class TenderDetailController extends GetxController {

  // --- DEPENDENCIES ---
  final ITenderRepository _tenderRepo = Get.find<ITenderRepository>();

  // --- STATE ---
  final RxBool isLoading = true.obs;
  final Rx<TenderRequestModel?> tender = Rxn<TenderRequestModel>();
  late final String _requestId;
  
  final rupiahFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  void onInit() {
    super.onInit();
    // 1. Ambil ID dari halaman marketplace
    _requestId = Get.arguments as String;
    // 2. Fetch data lengkap
    fetchTenderDetail();
  }

  /// Ambil data lengkap (termasuk daftar penawaran)
  Future<void> fetchTenderDetail() async {
    isLoading.value = true;
    try {
      final data = await _tenderRepo.getTenderDetailById(_requestId);
      tender.value = data;
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat detail tender: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Navigasi ke Halaman Form Penawaran
  void goToSubmitOffer() async { // <-- 1. Tambahkan 'async'
    if (tender.value == null) return;
    
    // 2. 'await' navigasi untuk menunggu hasil
    final result = await Get.toNamed(
      Routes.TENDER_SUBMIT_OFFER, 
      arguments: tender.value, // Kirim data tender ke form
    );
    
    // 3. Jika hasilnya 'success', panggil refresh data
    // Ini akan membuat penawaran baru LANGSUNG MUNCUL di daftar
    if (result == 'success') {
      fetchTenderDetail(); 
    }
  }
}