import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../theme/app_colors.dart';
import '../controllers/tender_create_request_controller.dart';

class TenderCreateRequestView extends GetView<TenderCreateRequestController> {
  const TenderCreateRequestView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background putih bersih
      appBar: _buildAppBar(),
      bottomNavigationBar: _buildBottomSubmitButton(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderSection(),
              const SizedBox(height: 32),
              
              // --- Form Fields ---
              _buildInputLabel("Judul Kebutuhan"),
              _buildTextFormField(
                controller: controller.titleC,
                hintText: "Contoh: Butuh 5 Ton Pupuk Urea",
                icon: FontAwesomeIcons.pen,
                validator: (v) => (v == null || v.isEmpty) ? "Judul wajib diisi" : null,
              ),
              const SizedBox(height: 24),
              
              _buildInputLabel("Kategori"),
              _buildTextFormField(
                controller: controller.categoryC,
                hintText: "Contoh: Pupuk, Bibit, Jasa Panen",
                icon: FontAwesomeIcons.tag,
                validator: (v) => (v == null || v.isEmpty) ? "Kategori wajib diisi" : null,
              ),
              const SizedBox(height: 24),
              
              _buildInputLabel("Estimasi Budget (Opsional)"),
              _buildTextFormField(
                controller: controller.budgetC,
                hintText: "Rp 0",
                icon: FontAwesomeIcons.sackDollar,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 24),
              
              // --- Pilihan Tanggal Deadline ---
              _buildInputLabel("Batas Waktu Penawaran"),
              _buildDeadlinePicker(context),
              
              const SizedBox(height: 24),
              _buildInputLabel("Deskripsi Rinci"),
              _buildTextFormField(
                controller: controller.descriptionC,
                hintText: "Jelaskan spesifikasi, lokasi pengiriman, dan detail lainnya...",
                icon: FontAwesomeIcons.alignLeft, // Ikon alignment untuk textarea
                maxLines: 5,
                alignTop: true,
                validator: (v) => (v == null || v.isEmpty) ? "Deskripsi wajib diisi" : null,
              ),
              
              // Spacer extra biar ga ketutup button
              const SizedBox(height: 100), 
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.close, color: Colors.black), // Icon Close lebih cocok untuk modal/create
        onPressed: () => Get.back(),
      ),
      title: const Text(
        "Buat Tender Baru",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const FaIcon(FontAwesomeIcons.circleInfo, color: AppColors.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Permintaan tender akan ditayangkan ke publik agar para Pakar/Investor dapat memberikan penawaran.",
              style: TextStyle(color: AppColors.primary.withOpacity(0.9), fontSize: 13, height: 1.4),
            ),
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

  /// Helper untuk Input Form Modern (Filled Style)
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    int? maxLines = 1,
    bool alignTop = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      style: const TextStyle(fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        filled: true,
        fillColor: const Color(0xFFF9F9F9), // Abu sangat muda
        prefixIcon: Padding(
          padding: EdgeInsets.only(
            left: 14, 
            right: 14, 
            bottom: alignTop ? (20.0 * (maxLines ?? 1) - 20) : 0 // Adjust icon pos untuk multiline
          ), 
          child: FaIcon(icon, size: 18, color: Colors.grey.shade400),
        ),
        // Border States
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), 
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5)
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5)
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
      validator: validator,
    );
  }

  /// Pilihan Tanggal Deadline (Style Input Field)
  Widget _buildDeadlinePicker(BuildContext context) {
    return Obx(() => GestureDetector(
      onTap: () => controller.pickDeadlineDate(context),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F9F9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            FaIcon(FontAwesomeIcons.calendarDay, size: 18, color: Colors.grey.shade400),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                controller.selectedDeadline.value == null 
                    ? "Pilih Tanggal..." 
                    : controller.formattedDeadline,
                style: TextStyle(
                  color: controller.selectedDeadline.value == null ? Colors.grey.shade400 : Colors.black87,
                  fontWeight: FontWeight.w500,
                  fontSize: 15
                ),
              ),
            ),
            const FaIcon(FontAwesomeIcons.chevronDown, size: 14, color: Colors.grey),
          ],
        ),
      ),
    ));
  }

  /// Tombol CTA Bawah
  Widget _buildBottomSubmitButton() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
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
            onPressed: controller.isLoading.value ? null : controller.submitRequest,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: controller.isLoading.value
                ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                : const Text("Publikasikan Tender", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          )),
        ),
      ),
    );
  }
}