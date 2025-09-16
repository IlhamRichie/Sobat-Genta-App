import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../controllers/register_role_chooser_controller.dart';

// (Best Practice: Pindahkan ini ke lib/app/theme/app_colors.dart)
const kPrimaryDarkGreen = Color(0xFF3A8A40);
const kLightGreenBlob = Color(0xFFEAF4EB);
const kTextFieldBorder = Color(0xFFD9D9D9);
const kDarkTextColor = Color(0xFF1B2C1E);
const kBodyTextColor = Color(0xFF5A6A5C);

class RegisterRoleChooserView extends GetView<RegisterRoleChooserController> {
  const RegisterRoleChooserView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: kDarkTextColor),
          onPressed: () => Get.back(),
        ),
      ),
      body: Stack(
        children: [
          _buildBackgroundBlobs(), // Konsistensi UI
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: Get.height * 0.02),
                  
                  _buildHeader()
                      .animate()
                      .fadeIn(delay: 300.ms)
                      .slideY(begin: 0.2, end: 0),
                  
                  const SizedBox(height: 32),
                  
                  // --- Pilihan Peran (Reaktif) ---
                  // Gunakan Obx untuk 'mendengarkan' perubahan di controller
                  Obx(() {
                    return Column(
                      children: [
                        _buildRoleCard(
                          title: 'Petani',
                          description: 'Saya petani yang butuh modal & konsultasi.',
                          icon: FontAwesomeIcons.leaf,
                          isSelected: controller.selectedRole.value == UserRole.farmer,
                          onTap: () => controller.selectRole(UserRole.farmer),
                        ).animate().fadeIn(delay: 500.ms).slideX(begin: -0.2),
                        
                        const SizedBox(height: 16),
                        
                        _buildRoleCard(
                          title: 'Investor',
                          description: 'Saya ingin mendanai proyek agrikultur.',
                          icon: FontAwesomeIcons.chartLine,
                          isSelected: controller.selectedRole.value == UserRole.investor,
                          onTap: () => controller.selectRole(UserRole.investor),
                        ).animate().fadeIn(delay: 600.ms).slideX(begin: 0.2),
                        
                        const SizedBox(height: 16),
                        
                        _buildRoleCard(
                          title: 'Pakar',
                          description: 'Saya (dokter hewan/ahli tani) penyedia jasa.',
                          icon: FontAwesomeIcons.userDoctor,
                          isSelected: controller.selectedRole.value == UserRole.expert,
                          onTap: () => controller.selectRole(UserRole.expert),
                        ).animate().fadeIn(delay: 700.ms).slideX(begin: -0.2),
                      ],
                    );
                  }),
                  
                  const Spacer(), // Dorong tombol ke bawah
                  
                  // --- Tombol Lanjutkan (State-Driven) ---
                  Obx(() {
                    return _buildContinueButton(
                      // Tombol akan 'null' (disabled) jika selectedRole masih null
                      onPressed: controller.selectedRole.value == null
                          ? null
                          : controller.continueRegistration,
                    );
                  }).animate().fadeIn(delay: 800.ms).slideY(begin: 0.5),
                  
                  SizedBox(height: Get.height * 0.05),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Helper Widgets (Best Practice) ---

  Widget _buildBackgroundBlobs() {
    return Positioned(
      top: -100,
      left: -100,
      child: Container(
        width: 300,
        height: 300,
        decoration: const BoxDecoration(
          color: kLightGreenBlob,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Daftar Akun',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: kDarkTextColor,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Pilih peran yang paling sesuai untuk Anda.',
          style: TextStyle(
            fontSize: 17,
            color: kBodyTextColor,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  // Helper widget kustom untuk kartu pilihan
  Widget _buildRoleCard({
    required String title,
    required String description,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: 200.ms,
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: isSelected ? kLightGreenBlob : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? kPrimaryDarkGreen : kTextFieldBorder,
            width: isSelected ? 2.0 : 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: kPrimaryDarkGreen.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ]
              : [], // Tidak ada shadow jika tidak dipilih
        ),
        child: Row(
          children: [
            FaIcon(
              icon,
              color: isSelected ? kPrimaryDarkGreen : kDarkTextColor,
              size: 32,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? kPrimaryDarkGreen : kDarkTextColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 15,
                      color: kBodyTextColor,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: kPrimaryDarkGreen,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueButton({required VoidCallback? onPressed}) {
    return ElevatedButton(
      onPressed: onPressed, // Ini kuncinya
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryDarkGreen,
        foregroundColor: Colors.white,
        // Style 'disabled' akan otomatis diterapkan saat onPressed: null
        disabledBackgroundColor: kTextFieldBorder,
        disabledForegroundColor: kBodyTextColor,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: const Text(
        'Lanjutkan Pendaftaran',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}