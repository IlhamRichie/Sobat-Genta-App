// lib/app/modules/manage_bank_accounts/views/manage_bank_accounts_view.dart

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
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      floatingActionButton: _buildFloatingActionButton(context),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        return Stack(
          children: [
            // List Content / Empty State
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
                  return _buildAccountCard(account);
                },
              ),

            // Loading Overlay (jika sedang proses simpan/hapus)
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

  /// AppBar Kustom
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const FaIcon(FontAwesomeIcons.arrowLeft, color: AppColors.textDark),
        onPressed: () => Get.back(),
      ),
      title: Text(
        "Kelola Rekening",
        style: Get.textTheme.headlineSmall?.copyWith(
          color: AppColors.textDark,
          fontWeight: FontWeight.w800,
          fontSize: 20,
        ),
      ),
    );
  }

  /// FAB Modern
  Widget _buildFloatingActionButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: FloatingActionButton.extended(
        onPressed: () => _showAddAccountSheet(context),
        icon: const FaIcon(FontAwesomeIcons.plus, size: 16),
        label: const Text("Rekening Baru", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        elevation: 0,
        highlightElevation: 0,
      ),
    );
  }

  /// Kartu Rekening (Bank Card Style)
  Widget _buildAccountCard(BankAccountModel account) {
    bool isPrimary = account.isPrimary;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isPrimary ? Border.all(color: AppColors.primary, width: 1.5) : null,
        boxShadow: [
          BoxShadow(
            color: isPrimary ? AppColors.primary.withOpacity(0.1) : Colors.grey.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Bank Info & Primary Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.greyLight.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const FaIcon(FontAwesomeIcons.buildingColumns, color: AppColors.textDark, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        account.bankName.toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.textDark),
                      ),
                      Text(
                        account.accountHolderName,
                        style: const TextStyle(fontSize: 12, color: AppColors.textLight),
                      ),
                    ],
                  ),
                ],
              ),
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
          
          // Account Number (Monospace)
          Text(
            account.accountNumber,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
              color: AppColors.textDark,
            ),
          ),
          
          const SizedBox(height: 20),
          const Divider(height: 1, color: AppColors.greyLight),
          const SizedBox(height: 8),
          
          // Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => controller.deleteAccount(account.accountId),
                style: TextButton.styleFrom(foregroundColor: Colors.red.shade700),
                child: const Text("Hapus"),
              ),
              if (!isPrimary) ...[
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () => controller.setAsPrimary(account.accountId),
                  child: const Text("Jadikan Utama"),
                ),
              ]
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
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.greyLight.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: const FaIcon(FontAwesomeIcons.creditCard, size: 48, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            const Text(
              "Belum Ada Rekening",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
            const SizedBox(height: 8),
            const Text(
              "Tambahkan rekening bank untuk mempermudah proses pencairan dana (withdraw).",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textLight),
            ),
            const SizedBox(height: 32),
            OutlinedButton.icon(
              onPressed: () => _showAddAccountSheet(context),
              icon: const FaIcon(FontAwesomeIcons.plus, size: 14),
              label: const Text("Tambah Sekarang"),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Bottom Sheet Form (Add Account)
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
          child: SingleChildScrollView( // Agar tidak overflow saat keyboard muncul
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                      width: 40, height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Tambah Rekening Baru",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark),
                  ),
                  const SizedBox(height: 24),
                  
                  _buildInputField(
                    controller: controller.bankNameC,
                    label: "Nama Bank",
                    hint: "Contoh: BCA, Mandiri, BNI",
                    icon: FontAwesomeIcons.buildingColumns,
                  ),
                  const SizedBox(height: 16),
                  
                  _buildInputField(
                    controller: controller.holderNameC,
                    label: "Nama Pemilik",
                    hint: "Nama sesuai buku tabungan",
                    icon: FontAwesomeIcons.user,
                  ),
                  const SizedBox(height: 16),
                  
                  _buildInputField(
                    controller: controller.accNumberC,
                    label: "Nomor Rekening",
                    hint: "Masukkan digit angka saja",
                    icon: FontAwesomeIcons.hashtag,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 32),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Obx(() => ElevatedButton(
                      onPressed: controller.isProcessing.value ? null : controller.saveNewAccount,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: controller.isProcessing.value
                          ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text("Simpan Rekening", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    )),
                  ),
                  const SizedBox(height: 16), // Padding bawah
                ],
              ),
            ),
          ),
        ),
      ),
      isScrollControlled: true, // Agar bottom sheet bisa full screen jika perlu
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: AppColors.textDark),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: TextStyle(color: AppColors.textLight.withOpacity(0.5), fontSize: 14),
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: FaIcon(icon, size: 18, color: AppColors.textLight),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 50),
        filled: true,
        fillColor: AppColors.greyLight.withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
      ),
      validator: (v) => (v == null || v.isEmpty) ? "$label tidak boleh kosong" : null,
    );
  }
}