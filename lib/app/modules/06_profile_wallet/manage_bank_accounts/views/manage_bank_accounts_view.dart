import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../data/models/bank_account_model.dart';
import '../../../../theme/app_colors.dart';
import '../controllers/manage_bank_accounts_controller.dart';

class ManageBankAccountsView extends GetView<ManageBankAccountsController> {
  const ManageBankAccountsView({Key? key}) : super(key: key);

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
          "Daftar Rekening",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: _buildExtendedFab(context),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        return Stack(
          children: [
            // List Content
            if (controller.accountList.isEmpty)
              _buildEmptyState(context)
            else
              ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 100), // Bottom padding for FAB
                itemCount: controller.accountList.length,
                separatorBuilder: (ctx, i) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final account = controller.accountList[index];
                  return _buildBankCard(account);
                },
              ),

            // Loading Overlay (saat simpan/hapus)
            if (controller.isProcessing.value)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
          ],
        );
      }),
    );
  }

  /// FAB Lebar dengan Label
  Widget _buildExtendedFab(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: FloatingActionButton.extended(
        onPressed: () => _showAddAccountSheet(context),
        label: const Text(
          "Tambah Rekening",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        icon: const Icon(Icons.add),
        backgroundColor: AppColors.primary,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  /// Kartu Bank Modern
  Widget _buildBankCard(BankAccountModel account) {
    bool isPrimary = account.isPrimary;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isPrimary 
            ? Border.all(color: AppColors.primary, width: 2) 
            : Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: isPrimary ? AppColors.primary.withOpacity(0.1) : Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo Bank (Dummy Icon) & Nama
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F6F8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const FaIcon(FontAwesomeIcons.buildingColumns, size: 20, color: Color(0xFF2D3436)),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        account.bankName.toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF2D3436)),
                      ),
                      Text(
                        account.accountHolderName,
                        style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                ],
              ),
              // Badge Utama
              if (isPrimary)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "UTAMA",
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Nomor Rekening Besar
          Text(
            account.accountNumber,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
              color: Color(0xFF2D3436),
              fontFamily: 'monospace', // Biar kayak angka di kartu
            ),
          ),
          
          const SizedBox(height: 20),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          const SizedBox(height: 8),
          
          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => controller.deleteAccount(account.accountId),
                style: TextButton.styleFrom(foregroundColor: Colors.red.shade400),
                child: const Text("Hapus"),
              ),
              if (!isPrimary)
                TextButton(
                  onPressed: () => controller.setAsPrimary(account.accountId),
                  child: const Text("Jadikan Utama"),
                ),
            ],
          )
        ],
      ),
    );
  }

  /// Empty State
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F6F8),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.credit_card_off, size: 50, color: Colors.grey.shade400),
            ),
            const SizedBox(height: 24),
            const Text(
              "Belum Ada Rekening",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D3436)),
            ),
            const SizedBox(height: 8),
            Text(
              "Tambahkan rekening bank Anda untuk menerima pencairan dana dengan mudah.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade500, height: 1.5),
            ),
            const SizedBox(height: 32),
            OutlinedButton.icon(
              onPressed: () => _showAddAccountSheet(context),
              icon: const Icon(Icons.add, size: 18),
              label: const Text("Tambah Sekarang"),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Form Tambah Akun (Modal Sheet)
  void _showAddAccountSheet(BuildContext context) {
    controller.clearFormControllers();
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: controller.formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
                  ),
                  const SizedBox(height: 24),
                  const Text("Tambah Rekening Baru", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  
                  _buildInputLabel("Nama Bank"),
                  _buildTextField(
                    controller: controller.bankNameC,
                    hint: "Contoh: BCA, Mandiri, BRI",
                    icon: FontAwesomeIcons.buildingColumns,
                  ),
                  const SizedBox(height: 16),
                  
                  _buildInputLabel("Nama Pemilik"),
                  _buildTextField(
                    controller: controller.holderNameC,
                    hint: "Sesuai buku tabungan",
                    icon: FontAwesomeIcons.user,
                  ),
                  const SizedBox(height: 16),
                  
                  _buildInputLabel("Nomor Rekening"),
                  _buildTextField(
                    controller: controller.accNumberC,
                    hint: "Masukkan digit angka",
                    icon: FontAwesomeIcons.hashtag,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 32),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: Obx(() => ElevatedButton(
                      onPressed: controller.isProcessing.value ? null : controller.saveNewAccount,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: controller.isProcessing.value
                          ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text("Simpan Rekening", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    )),
                  ),
                  // Keyboard spacer
                  SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                ],
              ),
            ),
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        label,
        style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey.shade800, fontSize: 14),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.normal),
        filled: true,
        fillColor: const Color(0xFFF9F9F9),
        prefixIcon: Padding(
          padding: const EdgeInsets.all(12),
          child: FaIcon(icon, size: 18, color: Colors.grey.shade400),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
      ),
      validator: (v) => (v == null || v.isEmpty) ? "Wajib diisi" : null,
    );
  }
}