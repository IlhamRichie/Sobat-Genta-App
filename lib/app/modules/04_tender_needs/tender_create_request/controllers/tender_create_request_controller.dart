// lib/app/modules/tender_create_request/controllers/tender_create_request_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../data/repositories/abstract/tender_repository.dart';

class TenderCreateRequestController extends GetxController {

  // --- DEPENDENCIES ---
  final ITenderRepository _tenderRepo = Get.find<ITenderRepository>();

  // --- FORM STATE ---
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController titleC = TextEditingController();
  final TextEditingController categoryC = TextEditingController();
  final TextEditingController budgetC = TextEditingController();
  final TextEditingController descriptionC = TextEditingController();
  
  final Rx<DateTime?> selectedDeadline = Rxn<DateTime>();
  
  final RxBool isLoading = false.obs;

  // Helper format tanggal
  String get formattedDeadline {
    if (selectedDeadline.value == null) {
      return "Pilih Tanggal";
    }
    return DateFormat('d MMMM yyyy', 'id_ID').format(selectedDeadline.value!);
  }

  @override
  void onClose() {
    titleC.dispose();
    categoryC.dispose();
    budgetC.dispose();
    descriptionC.dispose();
    super.onClose();
  }

  /// 1. Aksi untuk memilih tanggal deadline
  Future<void> pickDeadlineDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDeadline.value ?? DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now().add(const Duration(days: 1)), // Tender harus di masa depan
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != selectedDeadline.value) {
      selectedDeadline.value = picked;
    }
  }

  /// 2. Aksi utama: Submit Request (sesuai DB)
  Future<void> submitRequest() async {
    // Validasi Form
    if (!formKey.currentState!.validate()) return;

    // Validasi Deadline
    if (selectedDeadline.value == null) {
      Get.snackbar("Error", "Batas waktu penawaran (deadline) wajib diisi.");
      return;
    }
    
    isLoading.value = true;
    
    try {
      // Siapkan payload
      final Map<String, dynamic> data = {
        "title": titleC.text,
        "category": categoryC.text,
        "target_budget": double.tryParse(budgetC.text) ?? 0.0, // Kirim 0 jika kosong
        "description": descriptionC.text,
        "deadline": selectedDeadline.value!.toIso8601String(), // Kirim sbg string ISO
      };

      // Panggil Repo
      await _tenderRepo.createTenderRequest(data);
      
      showTopSnackBar(
        Overlay.of(Get.context!),
        CustomSnackBar.success(
          message: "Permintaan tender berhasil dipublikasikan!",
          backgroundColor: Colors.green.shade700,
        ),
      );
      
      // Kirim 'result' sukses agar halaman list bisa refresh
      Get.back(result: 'success');

    } catch (e) {
      Get.snackbar("Error", "Gagal mengirim permintaan: $e");
    } finally {
      isLoading.value = false;
    }
  }
}