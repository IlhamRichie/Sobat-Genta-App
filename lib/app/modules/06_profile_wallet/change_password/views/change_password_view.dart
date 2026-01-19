import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../theme/app_colors.dart';
import '../controllers/change_password_controller.dart';

class ChangePasswordView extends GetView<ChangePasswordController> {
  const ChangePasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Keamanan Akun",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      bottomNavigationBar: _buildBottomButton(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderInfo(),
              const SizedBox(height: 32),
              
              // 1. Password Saat Ini
              _buildInputLabel("Password Lama"),
              Obx(() => _buildPasswordField(
                controller: controller.currentPassC,
                hintText: "Masukkan password saat ini",
                isHidden: controller.isCurrentPassHidden.value,
                onToggle: controller.toggleCurrentPass,
                validator: (v) => (v == null || v.isEmpty) ? "Wajib diisi" : null,
              )),
              
              const SizedBox(height: 24),
              
              // 2. Password Baru
              _buildInputLabel("Password Baru"),
              Obx(() => _buildPasswordField(
                controller: controller.newPassC,
                hintText: "Minimal 6 karakter",
                isHidden: controller.isNewPassHidden.value,
                onToggle: controller.toggleNewPass,
                validator: (v) {
                  if (v == null || v.length < 6) return 'Password terlalu pendek';
                  return null;
                },
              )),
              
              const SizedBox(height: 24),
              
              // 3. Konfirmasi Password Baru
              _buildInputLabel("Konfirmasi Password Baru"),
              Obx(() => _buildPasswordField(
                controller: controller.confirmNewPassC,
                hintText: "Ulangi password baru",
                isHidden: controller.isConfirmNewPassHidden.value,
                onToggle: controller.toggleConfirmNewPass,
                validator: (v) {
                  if (v != controller.newPassC.text) return 'Password tidak cocok';
                  return null;
                },
              )),
              
              const SizedBox(height: 32),
              
              // Info Tambahan
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.blue, size: 20),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        "Password yang kuat membantu melindungi akun dan data pribadi Anda.",
                        style: TextStyle(color: Colors.blue, fontSize: 12, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Header Info dengan Ikon Besar
  Widget _buildHeaderInfo() {
    return Center(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const FaIcon(FontAwesomeIcons.shieldHalved, size: 40, color: AppColors.primary),
          ),
          const SizedBox(height: 16),
          const Text(
            "Ubah Password",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2D3436)),
          ),
          const SizedBox(height: 8),
          const Text(
            "Buat password baru yang unik dan belum pernah digunakan sebelumnya.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF2D3436), fontSize: 14),
      ),
    );
  }

  /// Password Field Modern
  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required bool isHidden,
    required VoidCallback onToggle,
    required String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isHidden,
      style: const TextStyle(fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.normal),
        filled: true,
        fillColor: const Color(0xFFF9F9F9), // Abu sangat muda
        prefixIcon: Padding(
          padding: const EdgeInsets.all(12),
          child: FaIcon(FontAwesomeIcons.lock, size: 18, color: Colors.grey.shade400),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            isHidden ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: Colors.grey.shade400,
            size: 20,
          ),
          onPressed: onToggle,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14), 
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5)
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5)
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
      ),
      validator: validator,
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: Obx(() => ElevatedButton(
            onPressed: controller.isLoading.value ? null : controller.submitChangePassword,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: controller.isLoading.value
                ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Text("Simpan Password Baru", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          )),
        ),
      ),
    );
  }
}