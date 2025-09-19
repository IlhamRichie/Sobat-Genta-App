// lib/app/modules/tender_submit_offer/controllers/tender_submit_offer_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../data/models/tender_request_model.dart';
import '../../../../data/repositories/abstract/tender_repository.dart';
import '../../../../services/session_service.dart';

class TenderSubmitOfferController extends GetxController {

  // --- DEPENDENCIES ---
  final ITenderRepository _tenderRepo = Get.find<ITenderRepository>();
  final SessionService _sessionService = Get.find<SessionService>(); // Butuh ID user penawar

  // --- STATE ---
  late final TenderRequestModel tenderRequest; // Data dari halaman detail
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController priceC = TextEditingController();
  final TextEditingController notesC = TextEditingController();
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // 1. Ambil data tender yang akan ditawar
    tenderRequest = Get.arguments as TenderRequestModel;
  }

  @override
  void onClose() {
    priceC.dispose();
    notesC.dispose();
    super.onClose();
  }

  /// Aksi utama: Kirim Penawaran (sesuai tabel 'tenderoffers')
  Future<void> submitOffer() async {
    if (!formKey.currentState!.validate()) return;
    
    isLoading.value = true;
    try {
      // 1. Siapkan payload
      final Map<String, dynamic> offerData = {
        "request_id": tenderRequest.requestId,
        "user_id": _sessionService.currentUser.value!.userId, // ID si penawar (kita)
        "offer_price": double.tryParse(priceC.text) ?? 0.0,
        "notes": notesC.text,
      };

      // 2. Panggil Repo
      await _tenderRepo.submitTenderOffer(offerData);

      showTopSnackBar(
        Overlay.of(Get.context!),
        CustomSnackBar.success(
          message: "Penawaran Anda berhasil dikirim!",
          backgroundColor: Colors.green.shade700,
        ),
      );

      // 3. Kembali ke halaman detail dengan sinyal 'success'
      Get.back(result: 'success');

    } catch (e) {
      Get.snackbar("Error", "Gagal mengirim penawaran: $e");
    } finally {
      isLoading.value = false;
    }
  }
}