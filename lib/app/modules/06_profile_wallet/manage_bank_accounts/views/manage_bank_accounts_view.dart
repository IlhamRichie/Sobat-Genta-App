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
        
        if (controller.accountList.isEmpty) {
          return _buildEmptyState(context);
        }

        return Stack(
          children: [
            ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemCount: controller.accountList.length,
              itemBuilder: (context, index) {
                final account = controller.accountList[index];
                return _buildAccountCard(account);
              },
            ),
            if (controller.isProcessing.value)
              Container(
                color: Colors.white.withOpacity(0.5),
                child: const Center(child: CircularProgressIndicator()),
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
      leading: BackButton(
        color: AppColors.textDark,
        onPressed: () => Get.back(),
      ),
      title: Text(
        "Kelola Rekening Bank",
        style: Get.textTheme.headlineSmall?.copyWith(
          color: AppColors.textDark,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: false,
    );
  }

  /// Floating Action Button (Didesain Ulang)
  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => _showAddAccountSheet(context),
      icon: const FaIcon(FontAwesomeIcons.plus),
      label: const Text("Tambah Rekening"),
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
    );
  }
  
  /// Kartu untuk satu rekening (Didesain Ulang)
  Widget _buildAccountCard(BankAccountModel account) {
    bool isPrimary = account.isPrimary;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isPrimary ? AppColors.primary : AppColors.greyLight,
          width: isPrimary ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.greyLight.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const FaIcon(FontAwesomeIcons.buildingColumns, color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(account.bankName.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 4),
                    Text(account.accountHolderName, style: Get.textTheme.bodyMedium?.copyWith(color: AppColors.textLight)),
                  ],
                ),
              ),
              if (isPrimary)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Utama",
                    style: Get.textTheme.bodySmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            account.accountNumber,
            style: Get.textTheme.headlineSmall?.copyWith(fontFamily: 'monospace', fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => controller.deleteAccount(account.accountId),
                style: TextButton.styleFrom(foregroundColor: Colors.red.shade700),
                child: const Text("Hapus"),
              ),
              const SizedBox(width: 16),
              if (!isPrimary)
                FilledButton(
                  onPressed: () => controller.setAsPrimary(account.accountId),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Jadikan Utama"),
                ),
            ],
          )
        ],
      ),
    );
  }

  /// Tampilan jika rekening kosong (Didesain Ulang)
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FaIcon(FontAwesomeIcons.creditCard, size: 96, color: AppColors.greyLight),
            const SizedBox(height: 32),
            Text(
              "Belum Ada Rekening Bank",
              style: Get.textTheme.titleLarge?.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              "Tambahkan rekening bank untuk mempermudah proses pencairan dana (payout).",
              style: Get.textTheme.bodyMedium?.copyWith(
                fontSize: 16,
                color: AppColors.textLight,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: () => _showAddAccountSheet(context),
              child: const Text("Tambah Rekening Pertama"),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// Bottom Sheet Formulir Penambahan Rekening (Didesain Ulang)
  void _showAddAccountSheet(BuildContext context) {
    controller.clearFormControllers();
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Tambah Rekening Baru",
                  style: Get.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                _buildTextFormField(
                  controller: controller.bankNameC,
                  label: 'Nama Bank (cth: BCA, Mandiri)',
                  icon: FontAwesomeIcons.buildingColumns,
                ),
                const SizedBox(height: 16),
                _buildTextFormField(
                  controller: controller.holderNameC,
                  label: 'Nama Pemilik Rekening',
                  icon: FontAwesomeIcons.solidUser,
                ),
                const SizedBox(height: 16),
                _buildTextFormField(
                  controller: controller.accNumberC,
                  label: 'Nomor Rekening',
                  icon: FontAwesomeIcons.hashtag,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 32),
                Obx(() => FilledButton(
                  onPressed: controller.isProcessing.value ? null : controller.saveNewAccount,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 4,
                  ),
                  child: controller.isProcessing.value 
                      ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text("Simpan Rekening", style: TextStyle(fontWeight: FontWeight.bold)),
                )),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
  
  /// Helper untuk TextFormField (Baru)
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: FaIcon(icon, size: 20, color: AppColors.textLight),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.greyLight)),
      ),
      validator: (v) => (v == null || v.isEmpty) ? "Wajib diisi" : null,
    );
  }
}