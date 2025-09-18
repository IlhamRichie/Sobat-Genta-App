// lib/app/modules/kyc_form/controllers/kyc_form_controller.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../data/models/user_model.dart';
import '../../../../data/repositories/abstract/kyc_repository.dart';
import '../../../../routes/app_pages.dart';
import '../../../../services/session_service.dart';

class KycFormController extends GetxController {
  
  // --- DEPENDENCIES ---
  final IKycRepository _kycRepo = Get.find<IKycRepository>();
  final SessionService _sessionService = Get.find<SessionService>();
  final ImagePicker _picker = ImagePicker();

  // --- ROLE ---
  late final UserRole userRole;

  // --- FORM KEY ---
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // --- STATE ---
  final RxBool isLoading = false.obs;

  // --- COMMON FIELDS ---
  final TextEditingController ktpNumberC = TextEditingController();
  final Rx<File?> ktpFile = Rx<File?>(null);
  final Rx<File?> selfieFile = Rx<File?>(null);

  // --- INVESTOR FIELDS ---
  final TextEditingController npwpC = TextEditingController();
  final TextEditingController bankNameC = TextEditingController();
  final TextEditingController bankAccountC = TextEditingController();

  // --- EXPERT FIELDS ---
  final TextEditingController specializationC = TextEditingController();
  final TextEditingController sipNumberC = TextEditingController();
  final Rx<File?> ijazahFile = Rx<File?>(null);
  final Rx<File?> sipFile = Rx<File?>(null);

  @override
  void onInit() {
    super.onInit();
    // Ambil peran user saat ini
    userRole = _sessionService.userRole;
  }

  @override
  void onClose() {
    ktpNumberC.dispose();
    npwpC.dispose();
    bankNameC.dispose();
    bankAccountC.dispose();
    specializationC.dispose();
    sipNumberC.dispose();
    super.onClose();
  }

  /// Helper untuk mengambil gambar dari Kamera atau Galeri
  Future<void> pickImage(ImageSource source, Rx<File?> targetFile) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source, imageQuality: 80);
      if (pickedFile != null) {
        targetFile.value = File(pickedFile.path);
      }
    } catch (e) {
      showTopSnackBar(
        Overlay.of(Get.context!),
        CustomSnackBar.error(message: "Gagal mengambil gambar: $e"),
      );
    }
  }

  /// Aksi utama submit KYC
  Future<void> submitKyc() async {
    // 1. Validasi form
    if (!formKey.currentState!.validate()) {
      showTopSnackBar(
        Overlay.of(Get.context!),
        CustomSnackBar.info(message: "Harap isi semua field wajib."),
      );
      return;
    }
    
    // 2. Validasi file
    if (ktpFile.value == null || selfieFile.value == null) {
      showTopSnackBar(
        Overlay.of(Get.context!),
        CustomSnackBar.info(message: "Foto KTP dan Swafoto wajib diisi."),
      );
      return;
    }

    isLoading.value = true;
    
    // 3. Siapkan data berdasarkan peran
    Map<String, dynamic> textData = { 'ktp_number': ktpNumberC.text };
    List<File> files = [ktpFile.value!, selfieFile.value!];

    switch (userRole) {
      case UserRole.INVESTOR:
        textData.addAll({
          'npwp': npwpC.text,
          'bank_name': bankNameC.text,
          'bank_account': bankAccountC.text,
        });
        break;
      case UserRole.EXPERT:
        textData.addAll({
          'specialization': specializationC.text,
          'sip_number': sipNumberC.text,
        });
        if (ijazahFile.value != null) files.add(ijazahFile.value!);
        if (sipFile.value != null) files.add(sipFile.value!);
        break;
      case UserRole.FARMER:
      default:
        // Petani hanya butuh data umum
        break;
    }

    try {
      // 4. Kirim ke repository
      final updatedUser = await _kycRepo.submitKyc(textData, files);
      
      // 5. Update sesi lokal
      _sessionService.setCurrentUser(updatedUser);
      
      showTopSnackBar(
        Overlay.of(Get.context!),
        CustomSnackBar.success(
          message: "Data KYC berhasil dikirim! Akun Anda akan direview oleh Admin.",
          backgroundColor: Colors.green.shade700,
        ),
      );
      
      // 6. Kembali ke halaman utama
      Get.offAllNamed(Routes.MAIN_NAVIGATION);

    } catch (e) {
      showTopSnackBar(
        Overlay.of(Get.context!),
        CustomSnackBar.error(message: e.toString().replaceAll("Exception: ", "")),
      );
    } finally {
      isLoading.value = false;
    }
  }
}