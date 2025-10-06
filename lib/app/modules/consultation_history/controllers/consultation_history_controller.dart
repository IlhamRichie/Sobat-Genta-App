// lib/app/modules/consultation_history/controllers/consultation_history_controller.dart
// (Buat file baru)
import 'package:get/get.dart';

import '../../../data/models/consultation_model.dart';
import '../../../data/repositories/abstract/consultation_repository.dart';
import '../../../routes/app_pages.dart';

class ConsultationHistoryController extends GetxController {

  final IConsultationRepository _consultationRepo = Get.find<IConsultationRepository>();

  final RxBool isLoading = true.obs;
  final RxList<ConsultationModel> consultationList = <ConsultationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchHistory();
  }

  Future<void> fetchHistory() async {
    isLoading.value = true;
    try {
      final list = await _consultationRepo.getMyConsultationList();
      consultationList.assignAll(list);
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat riwayat konsultasi: $e");
    } finally {
      isLoading.value = false;
    }
  }
  
  /// Navigasi ke Ruang Chat yang sudah ada
  void goToChatRoom(ConsultationModel consultation) {
    Get.toNamed(Routes.CONSULTATION_CHAT_ROOM, arguments: consultation);
  }
}