import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../../01_main_navigation/main_navigation/controllers/main_navigation_controller.dart';

class KycFormController extends GetxController {
  
  // --- [UPDATE] Tambahkan PageController ---
  late PageController pageController;

  final RxInt currentStep = 0.obs;
  final int totalSteps = 3;
  final GlobalKey<FormState> step1FormKey = GlobalKey<FormState>();
  late TextEditingController nameController, nikController, addressController;
  final ImagePicker _picker = ImagePicker();
  final Rx<File?> ktpImage = Rx<File?>(null);
  final Rx<File?> selfieImage = Rx<File?>(null);
  late MainNavigationController mainNavController;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(); // Inisialisasi
    nameController = TextEditingController();
    nikController = TextEditingController();
    addressController = TextEditingController();
    mainNavController = Get.find<MainNavigationController>();
  }

  @override
  void onClose() {
    pageController.dispose(); // Dispose PageController
    nameController.dispose();
    nikController.dispose();
    addressController.dispose();
    super.onClose();
  }

  // --- [UPDATE] Aksi Stepper sekarang juga mengontrol PageView ---
  
  void onStepContinue() {
    BuildContext context = Get.context!; 
    bool isStepValid = false;

    switch (currentStep.value) {
      case 0:
        isStepValid = step1FormKey.currentState!.validate();
        break;
      case 1:
        if (ktpImage.value == null) {
          showTopSnackBar(Overlay.of(context),
            const CustomSnackBar.error(message: 'Foto KTP tidak boleh kosong'),
          );
          isStepValid = false;
        } else {
          isStepValid = true;
        }
        break;
      case 2:
        if (selfieImage.value == null) {
          showTopSnackBar(Overlay.of(context),
            const CustomSnackBar.error(message: 'Foto selfie tidak boleh kosong'),
          );
          isStepValid = false;
        } else {
          isStepValid = true;
        }
        break;
    }

    if (isStepValid) {
      if (currentStep.value < (totalSteps - 1)) {
        currentStep.value += 1;
        // Pindahkan PageView
        pageController.animateToPage(
          currentStep.value,
          duration: 300.ms,
          curve: Curves.easeInOut,
        );
      } else {
        submitKycData(context);
      }
    }
  }

  void onStepCancel() {
    if (currentStep.value > 0) {
      currentStep.value -= 1;
      // Mundurkan PageView
      pageController.animateToPage(
        currentStep.value,
        duration: 300.ms,
        curve: Curves.easeInOut,
      );
    }
  }
  Future<void> pickImage(ImageSource source, Rx<File?> imageFile) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path);
    }
  }

  // Aksi tombol "Kirim Data" (Langkah Terakhir)
  void submitKycData(BuildContext context) {
    // (LOGIC API SUBMIT KYC NANTI DI SINI)
    
    showTopSnackBar(
      Overlay.of(context),
      const CustomSnackBar.success(
        message: "Data KYC terkirim. Data Anda akan segera ditinjau oleh Admin.",
      ),
    );

    // [UPDATE SR-KYC-04] Ubah status global
    mainNavController.kycStatus.value = UserKycStatus.inReview;

    Get.back(); // Kembali ke halaman Dashboard
  }
}