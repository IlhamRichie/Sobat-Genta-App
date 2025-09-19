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
      appBar: AppBar(
        title: const Text("Kelola Rekening Bank"),
      ),
      // Tombol untuk menambah rekening baru
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddAccountSheet(context),
        icon: const FaIcon(FontAwesomeIcons.plus),
        label: const Text("Tambah Rekening"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (controller.accountList.isEmpty) {
          return _buildEmptyState(context);
        }

        // Tampilkan loader di atas list jika sedang memproses C/U/D
        return Stack(
          children: [
            ListView.builder(
              padding: const EdgeInsets.all(16),
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
  
  /// Kartu untuk satu rekening
  Widget _buildAccountCard(BankAccountModel account) {
    bool isPrimary = account.isPrimary;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isPrimary ? AppColors.primary : Colors.grey.shade300, width: 1.5),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(backgroundColor: AppColors.greyLight, child: FaIcon(FontAwesomeIcons.buildingColumns)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(account.bankName.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(account.accountHolderName, style: Get.textTheme.bodySmall),
                    ],
                  ),
                ),
                if (isPrimary)
                  const Chip(label: Text("Utama"), backgroundColor: AppColors.primary, labelStyle: TextStyle(color: Colors.white)),
              ],
            ),
            const Divider(height: 24),
            Text(account.accountNumber, style: Get.textTheme.titleLarge?.copyWith(fontFamily: 'monospace')),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Tombol Hapus
                TextButton(
                  onPressed: () => controller.deleteAccount(account.accountId),
                  child: const Text("Hapus", style: TextStyle(color: Colors.red)),
                ),
                // Tombol Jadikan Utama (hanya jika bukan primary)
                if (!isPrimary)
                  FilledButton(
                    onPressed: () => controller.setAsPrimary(account.accountId),
                    child: const Text("Jadikan Utama"),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }

  /// Tampilan jika rekening kosong
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const FaIcon(FontAwesomeIcons.creditCard, size: 80, color: AppColors.greyLight),
          const SizedBox(height: 16),
          const Text("Anda belum menambah rekening bank.", style: TextStyle(fontSize: 16)),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => _showAddAccountSheet(context), 
            child: const Text("Tambah Rekening Pertama Anda")
          ),
        ],
      ),
    );
  }
  
  /// Bottom Sheet Formulir Penambahan Rekening
  void _showAddAccountSheet(BuildContext context) {
    controller.clearFormControllers();
    Get.bottomSheet(
      Container(
        height: Get.height * 0.7,
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("Tambah Rekening Baru", style: Get.textTheme.titleLarge),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    TextFormField(
                      controller: controller.bankNameC,
                      decoration: _inputDecoration('Nama Bank (cth: BCA, Mandiri)', FontAwesomeIcons.buildingColumns),
                      validator: (v) => (v == null || v.isEmpty) ? "Wajib diisi" : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: controller.holderNameC,
                      decoration: _inputDecoration('Nama Pemilik Rekening', FontAwesomeIcons.solidUser),
                      validator: (v) => (v == null || v.isEmpty) ? "Wajib diisi" : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: controller.accNumberC,
                      keyboardType: TextInputType.number,
                      decoration: _inputDecoration('Nomor Rekening', FontAwesomeIcons.hashtag),
                      validator: (v) => (v == null || v.isEmpty) ? "Wajib diisi" : null,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Obx(() => FilledButton(
                  onPressed: controller.isProcessing.value ? null : controller.saveNewAccount,
                  child: controller.isProcessing.value 
                      ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white))
                      : const Text("Simpan Rekening"),
                )),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
  
  InputDecoration _inputDecoration(String label, IconData? icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: icon != null ? FaIcon(icon, size: 20, color: AppColors.textLight) : null,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}