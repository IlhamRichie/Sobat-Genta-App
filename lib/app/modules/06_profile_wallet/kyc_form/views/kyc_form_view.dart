import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Import FontAwesome
import 'package:flutter_animate/flutter_animate.dart'; // Import Animate
import 'package:image_picker/image_picker.dart';
import '../controllers/kyc_form_controller.dart';

// --- Palet Warna Konsisten ---
const kPrimaryDarkGreen = Color(0xFF3A8A40);
const kLightGreenBlob = Color(0xFFEAF4EB);
const kTextFieldBorder = Color(0xFFD9D9D9);
const kDarkTextColor = Color(0xFF1B2C1E);
const kBodyTextColor = Color(0xFF5A6A5C);

class KycFormView extends GetView<KycFormController> {
  const KycFormView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Verifikasi Data (KYC)',
          style: TextStyle(color: kDarkTextColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: kDarkTextColor),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          // --- 1. Indikator Step Kustom ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Obx(() => _buildStepIndicator(controller.currentStep.value)),
          ).animate().fadeIn(duration: 400.ms),

          // --- 2. Konten Form (Menggunakan PageView) ---
          Expanded(
            child: PageView(
              // PENTING: Matikan swipe manual oleh pengguna
              physics: const NeverScrollableScrollPhysics(), 
              controller: controller.pageController,
              children: [
                _buildStep1DataDiri(),
                _buildStep2Ktp(),
                _buildStep3Selfie(),
              ],
            ),
          ),

          // --- 3. Tombol Navigasi Kustom ---
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  // --- Helper Widget Kustom ---

  // 1. INDIKATOR STEP (BARU)
  Widget _buildStepIndicator(int currentStep) {
    return Row(
      children: [
        _buildStepDot(index: 0, title: 'Data Diri', currentStep: currentStep),
        _buildStepLine(isActive: currentStep >= 1),
        _buildStepDot(index: 1, title: 'KTP', currentStep: currentStep),
        _buildStepLine(isActive: currentStep >= 2),
        _buildStepDot(index: 2, title: 'Selfie', currentStep: currentStep),
      ],
    );
  }

  Widget _buildStepDot({required int index, required String title, required int currentStep}) {
    bool isCompleted = currentStep > index;
    bool isActive = currentStep == index;

    return Column(
      children: [
        AnimatedContainer(
          duration: 300.ms,
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted || isActive ? kPrimaryDarkGreen : Colors.white,
            border: Border.all(
              color: isCompleted || isActive ? kPrimaryDarkGreen : kTextFieldBorder,
              width: 2,
            ),
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, color: Colors.white, size: 20)
                : Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: isActive ? Colors.white : kBodyTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 8),
        Text(title, style: TextStyle(
          color: isActive || isCompleted ? kDarkTextColor : kBodyTextColor,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        )),
      ],
    );
  }

  Widget _buildStepLine({required bool isActive}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 28.0), // Sejajarkan dengan titik
        child: AnimatedContainer(
          duration: 300.ms,
          height: 2,
          color: isActive ? kPrimaryDarkGreen : kTextFieldBorder,
        ),
      ),
    );
  }

  // 2. KONTEN FORM (Direvisi agar pas di PageView)
  Widget _buildStep1DataDiri() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: controller.step1FormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Langkah 1: Data Diri', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const Text('Isi data Anda sesuai KTP.', style: TextStyle(color: kBodyTextColor, fontSize: 16)),
            const SizedBox(height: 24),
            _buildTextField(
              controller: controller.nameController,
              label: 'Nama Lengkap (sesuai KTP)',
              prefixIcon: const FaIcon(FontAwesomeIcons.solidUser, size: 20),
              validator: (val) => (val == null || val.isEmpty) ? 'Nama tidak boleh kosong' : null,
            ),
            _buildTextField(
              controller: controller.nikController,
              label: 'Nomor NIK',
              prefixIcon: const FaIcon(FontAwesomeIcons.solidIdCard, size: 20),
              keyboardType: TextInputType.number,
              validator: (val) => (val == null || val.length != 16) ? 'NIK harus 16 digit' : null,
            ),
            _buildTextField(
              controller: controller.addressController,
              label: 'Alamat (sesuai KTP)',
              prefixIcon: const FaIcon(FontAwesomeIcons.mapLocationDot, size: 20),
              maxLines: 3,
              validator: (val) => (val == null || val.isEmpty) ? 'Alamat tidak boleh kosong' : null,
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 100.ms);
  }

  Widget _buildStep2Ktp() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Langkah 2: Unggah Foto KTP', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const Text('Ambil foto KTP Anda dengan jelas.', style: TextStyle(color: kBodyTextColor, fontSize: 16)),
          const SizedBox(height: 24),
          Obx(() {
            return _buildImagePickerBox(
              context: Get.context!,
              imageFile: controller.ktpImage.value,
              onTap: () => _showImageSourceModal(Get.context!, controller.ktpImage),
            );
          }),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms);
  }
  
  Widget _buildStep3Selfie() {
     return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Langkah 3: Verifikasi Wajah', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const Text('Ambil foto selfie sambil memegang KTP.', style: TextStyle(color: kBodyTextColor, fontSize: 16)),
          const SizedBox(height: 24),
          Obx(() {
            return _buildImagePickerBox(
              context: Get.context!,
              imageFile: controller.selfieImage.value,
              onTap: () => _showImageSourceModal(Get.context!, controller.selfieImage),
            );
          }),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms);
  }

  // 3. TOMBOL NAVIGASI BAWAH (BARU)
  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))
        ],
      ),
      child: Obx(() {
        final isLastStep = controller.currentStep.value == controller.totalSteps - 1;
        return Row(
          children: [
            // Tombol Kembali
            if (controller.currentStep.value > 0)
              TextButton(
                onPressed: controller.onStepCancel,
                child: const Text('Kembali', style: TextStyle(color: kBodyTextColor, fontSize: 16)),
              ).animate().fadeIn(),

            const Spacer(),

            // Tombol Lanjut / Kirim
            ElevatedButton(
              onPressed: controller.onStepContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryDarkGreen,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              ),
              child: Text(
                isLastStep ? 'KIRIM DATA' : 'LANJUT',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // <-- Ubah warna teks jadi putih
                ),
              ),
            ).animate().fadeIn(),
          ],
        );
      }),
    );
  }
  // --- Helper Widget Kustom (Reusable) ---

  // [UPDATE] Mengubah prefixIcon dari IconData menjadi Widget
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required Widget prefixIcon, // Lebih fleksibel
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: kBodyTextColor),
          // [UPDATE] Gunakan Padding agar ikon tidak terlalu mepet
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: prefixIcon,
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 24, minHeight: 24),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: kTextFieldBorder, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: kPrimaryDarkGreen, width: 2),
          ),
        ),
      ),
    );
  }
  
  // [UPDATE] Box Upload Gambar dengan Animasi
  Widget _buildImagePickerBox({
    required BuildContext context,
    required File? imageFile,
    required VoidCallback onTap,
  }) {
    return DottedBorder(
      color: kTextFieldBorder,
      strokeWidth: 2,
      dashPattern: const [8, 4],
      radius: const Radius.circular(16), // Radius lebih besar
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14), // Radius di dalam border
        child: Container(
          height: Get.height * 0.25,
          width: double.infinity,
          decoration: BoxDecoration(
            color: kLightGreenBlob,
            borderRadius: BorderRadius.circular(14),
          ),
          child: imageFile != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.file(imageFile, fit: BoxFit.cover),
                ).animate().fadeIn() // Animasi saat gambar muncul
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // [UPDATE] Ikon FontAwesome dengan animasi shimmer
                    FaIcon(
                      FontAwesomeIcons.cameraRetro,
                      color: kBodyTextColor.withOpacity(0.7),
                      size: 50,
                    ).animate(onPlay: (c) => c.repeat())
                     .shimmer(delay: 800.ms, duration: 1000.ms, color: kPrimaryDarkGreen.withOpacity(0.3)),
                    
                    const SizedBox(height: 12),
                    const Text(
                      'Klik untuk unggah gambar',
                      style: TextStyle(color: kBodyTextColor, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  // [UPDATE] Modal dengan Ikon FontAwesome
  void _showImageSourceModal(BuildContext context, Rx<File?> imageFile) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder( // UI lebih modern
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Pilih Sumber Gambar', style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: kDarkTextColor,
              )),
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.camera, color: kPrimaryDarkGreen),
              title: const Text('Buka Kamera', style: TextStyle(color: kDarkTextColor)),
              onTap: () {
                Get.back();
                controller.pickImage(ImageSource.camera, imageFile);
              },
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.solidImages, color: kPrimaryDarkGreen),
              title: const Text('Pilih dari Galeri', style: TextStyle(color: kDarkTextColor)),
              onTap: () {
                Get.back();
                controller.pickImage(ImageSource.gallery, imageFile);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}