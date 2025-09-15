import 'package:get/get.dart';

import '../controllers/clinic_library_reader_controller.dart';

class ClinicLibraryReaderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClinicLibraryReaderController>(
      () => ClinicLibraryReaderController(),
    );
  }
}
