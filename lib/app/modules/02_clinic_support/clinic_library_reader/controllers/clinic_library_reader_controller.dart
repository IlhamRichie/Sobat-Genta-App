// lib/app/modules/clinic_library_reader/controllers/clinic_library_reader_controller.dart
import 'package:get/get.dart';

import '../../../../data/models/digital_document_model.dart';

class ClinicLibraryReaderController extends GetxController {
  
  late final DigitalDocumentModel document;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    document = Get.arguments as DigitalDocumentModel;
    _simulateLoading();
  }
  
  // Simulasi loading webview/pdf
  void _simulateLoading() async {
    await Future.delayed(const Duration(milliseconds: 500));
    isLoading.value = false;
  }
  
  // Nanti di sini akan ada logic untuk WebView Controller
  // atau PDF Controller
}