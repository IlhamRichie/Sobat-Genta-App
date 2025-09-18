// lib/app/modules/expert_dashboard/controllers/expert_dashboard_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../data/models/pakar_profile_model.dart';
import '../../../../data/repositories/abstract/pakar_profile_repository.dart';

class ExpertDashboardController extends GetxController {

  // --- DEPENDENCIES ---
  final IPakarProfileRepository _pakarRepo = Get.find<IPakarProfileRepository>();

  // --- MAIN STATE ---
  final RxBool isLoading = true.obs;
  final Rx<PakarProfileModel?> profile = Rxn<PakarProfileModel>();
  
  // --- STATE KUNCI: KETERSEDIAAN ---
  final RxBool isAvailable = false.obs;
  final RxBool isToggleLoading = false.obs; // State loading khusus untuk toggle

  // --- PRAGMATIC SHORTCUT: Data Mock Lokal ---
  // Kita akan fetch ini dari IWalletRepo & IConsultationRepo nanti
  final RxDouble currentEarnings = 0.0.obs;
  final RxInt pendingConsultations = 0.obs;
  // ---------------------------------------------

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  /// Mengambil data awal untuk dashboard
  Future<void> fetchDashboardData() async {
    isLoading.value = true;
    try {
      final profileData = await _pakarRepo.getMyPakarProfile();
      profile.value = profileData;
      isAvailable.value = profileData.isAvailable;
      
      // --- Mengisi data mock lokal (Pragmatic Shortcut) ---
      // (Asumsi 3 sesi @ 50rb)
      currentEarnings.value = 150000.0; 
      // (Asumsi Budi sedang menunggu di antrian)
      pendingConsultations.value = 1;
      // ----------------------------------------------------

    } catch (e) {
      Get.snackbar("Error", "Gagal memuat data dashboard: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Aksi untuk mengubah status Online/Offline
  Future<void> toggleAvailability(bool newValue) async {
    isToggleLoading.value = true;
    try {
      await _pakarRepo.updateAvailabilityStatus(newValue);
      // Jika sukses di API, update state lokal
      isAvailable.value = newValue;
      
      showTopSnackBar(
        Overlay.of(Get.context!),
        newValue
            ? CustomSnackBar.success(message: "Status Anda sekarang ONLINE", backgroundColor: Colors.green.shade700)
            : CustomSnackBar.info(message: "Status Anda sekarang OFFLINE"),
      );

    } catch (e) {
      Get.snackbar("Error", "Gagal mengubah status: $e");
    } finally {
      isToggleLoading.value = false;
    }
  }
}