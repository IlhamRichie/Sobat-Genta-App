// lib/app/modules/farmer_apply_funding_form/controllers/farmer_apply_funding_form_controller.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../data/models/asset_model.dart';
import '../../../../data/repositories/abstract/project_repository.dart';
import '../../../../routes/app_pages.dart';
import '../../../../services/session_service.dart';

class FarmerApplyFundingFormController extends GetxController {

  // --- DEPENDENCIES ---
  final IProjectRepository _projectRepo = Get.find<IProjectRepository>();
  final SessionService _sessionService = Get.find<SessionService>();
  final ImagePicker _picker = ImagePicker();

  // --- ARGUMEN ---
  late final AssetModel asset; // Aset yang akan didanai

  // --- FORM KEY & STATE ---
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final RxBool isLoading = false.obs;
  
  // --- FORM FIELDS ---
  final TextEditingController titleC = TextEditingController();
  final TextEditingController targetFundC = TextEditingController();
  final TextEditingController durationC = TextEditingController(); // dalam hari
  final TextEditingController roiC = TextEditingController(); // %
  final TextEditingController descriptionC = TextEditingController();
  final Rx<File?> projectImageFile = Rx<File?>(null);

  // --- DYNAMIC RAB FORM ---
  // Kita akan menyimpan list dari Map, di mana tiap Map berisi 2 controller
  final RxList<Map<String, TextEditingController>> rabItemsList = 
      <Map<String, TextEditingController>>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    // 1. Ambil Aset dari argumen
    asset = Get.arguments as AssetModel;
    
    // 2. Tambahkan 1 field RAB kosong secara default
    addRabItem();
  }

  @override
  void onClose() {
    // DISPOSE SEMUA CONTROLLER PENTING!
    titleC.dispose();
    targetFundC.dispose();
    durationC.dispose();
    roiC.dispose();
    descriptionC.dispose();
    // Dispose semua controller RAB dinamis
    for (var item in rabItemsList) {
      item['name']!.dispose();
      item['cost']!.dispose();
    }
    super.onClose();
  }

  // --- LOGIKA RAB DINAMIS ---
  void addRabItem() {
    rabItemsList.add({
      'name': TextEditingController(),
      'cost': TextEditingController(),
    });
  }

  void removeRabItem(int index) {
    // Dispose controller sebelum menghapus dari list
    rabItemsList[index]['name']!.dispose();
    rabItemsList[index]['cost']!.dispose();
    rabItemsList.removeAt(index);
  }

  // --- LOGIKA IMAGE PICKER ---
  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source, imageQuality: 80);
      if (pickedFile != null) {
        projectImageFile.value = File(pickedFile.path);
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal mengambil gambar: $e");
    }
  }

  double calculateTotalRab() {
    double total = 0.0;
    for (var item in rabItemsList) {
      final String costText = item['cost']!.text;
      final double? cost = double.tryParse(costText);
      if (cost != null) {
        total += cost;
      }
    }
    return total;
  }

  /// Aksi utama submit proposal
  Future<void> submitProposal() async {
    if (!formKey.currentState!.validate()) {
      Get.snackbar("Gagal", "Harap isi semua field wajib.");
      return;
    }
    if (projectImageFile.value == null) {
      Get.snackbar("Gagal", "Foto Utama Proyek wajib diisi.");
      return;
    }
    
    isLoading.value = true;
    
    try {
      // 1. Konversi data RAB dari controllers menjadi List<Map> bersih
      final List<Map<String, dynamic>> rabJson = rabItemsList.map((item) {
        return {
          'item_name': item['name']!.text,
          'cost': double.tryParse(item['cost']!.text) ?? 0.0
        };
      }).toList();

      // 2. Siapkan payload data
      final Map<String, dynamic> projectData = {
        'land_id': asset.assetId,
        'user_id': _sessionService.currentUser.value!.userId,
        'title': titleC.text,
        'target_fund': double.tryParse(targetFundC.text) ?? 0.0,
        'duration_days': int.tryParse(durationC.text) ?? 0,
        'roi_percentage': double.tryParse(roiC.text) ?? 0.0,
        'description': descriptionC.text,
        'rab_details_json': rabJson, // Kirim sebagai List, backend akan handle sbg JSONB
        'status': 'PENDING_ADMIN' // Status awal
      };
      
      // 3. Panggil repository
      await _projectRepo.createProjectProposal(projectData, projectImageFile.value);
      
      showTopSnackBar(
        Overlay.of(Get.context!),
        CustomSnackBar.success(
          message: "Proposal proyek berhasil dikirim dan menunggu moderasi Admin.",
          backgroundColor: Colors.green.shade700,
        ),
      );
      
      // 4. Navigasi ke halaman 'My Projects' (Langkah A5)
      // Kita gunakan offAllNamed agar user tidak bisa 'back' ke form/detail
      // ATAU Get.offUntil agar kembali ke Home. Mari kita ke 'My Projects'
      Get.offNamed(Routes.FARMER_MY_PROJECTS_LIST);

    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}