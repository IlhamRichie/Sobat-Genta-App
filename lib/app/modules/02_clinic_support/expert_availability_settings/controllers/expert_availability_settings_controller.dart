// lib/app/modules/expert_availability_settings/controllers/expert_availability_settings_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../data/models/availability_slot_model.dart';
import '../../../../data/repositories/abstract/pakar_profile_repository.dart';

class ExpertAvailabilitySettingsController extends GetxController {

  // --- DEPENDENCIES ---
  final IPakarProfileRepository _pakarRepo = Get.find<IPakarProfileRepository>();
  
  // --- STATE ---
  final RxBool isLoadingPage = true.obs;
  final RxBool isSaving = false.obs;
  
  // --- FORM FIELDS ---
  final TextEditingController feeC = TextEditingController();
  // State untuk 7 hari jadwal
  final RxList<AvailabilitySlot> scheduleList = <AvailabilitySlot>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadProfileSettings();
  }

  @override
  void onClose() {
    feeC.dispose();
    super.onClose();
  }

  /// Mengambil data setting saat ini dari repo
  Future<void> loadProfileSettings() async {
    isLoadingPage.value = true;
    try {
      final profile = await _pakarRepo.getMyPakarProfile();
      feeC.text = profile.consultationFee.toStringAsFixed(0);
      scheduleList.assignAll(profile.schedule);
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat pengaturan: $e");
    } finally {
      isLoadingPage.value = false;
    }
  }

  // --- LOGIKA UI FORM ---

  /// Mengaktifkan/menonaktifkan satu hari
  void toggleDayActive(int index, bool isActive) {
    scheduleList[index].isActive.value = isActive;
  }

  /// Menampilkan modal TimePicker
  Future<void> selectTime(BuildContext context, int index, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    
    if (picked != null) {
      // Format ke "HH:mm" (24-jam)
      final formattedTime = "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
      if (isStartTime) {
        scheduleList[index].startTime.value = formattedTime;
      } else {
        scheduleList[index].endTime.value = formattedTime;
      }
    }
  }
  
  /// Aksi Simpan Perubahan
  Future<void> saveSettings() async {
    isSaving.value = true;
    
    final double newFee = double.tryParse(feeC.text) ?? 50000.0;
    
    try {
      await _pakarRepo.updatePakarProfileSettings(newFee, scheduleList);
      
      showTopSnackBar(
        Overlay.of(Get.context!),
        CustomSnackBar.success(
          message: "Pengaturan berhasil disimpan!",
          backgroundColor: Colors.green.shade700,
        ),
      );
      Get.back();
      
    } catch (e) {
      Get.snackbar("Error", "Gagal menyimpan pengaturan: $e");
    } finally {
      isSaving.value = false;
    }
  }
}