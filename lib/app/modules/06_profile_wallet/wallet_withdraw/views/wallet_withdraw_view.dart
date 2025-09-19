// lib/app/modules/wallet_withdraw/views/wallet_withdraw_view.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../theme/app_colors.dart';
import '../controllers/wallet_withdraw_controller.dart';

class WalletWithdrawView extends GetView<WalletWithdrawController> {
  const WalletWithdrawView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tarik Dana (Withdraw)"),
      ),
      bottomNavigationBar: _buildBottomButton(),
      body: Obx(() {
        if (controller.isLoadingData.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBalanceCard(),
              const SizedBox(height: 24),
              _buildDestinationCard(),
              const SizedBox(height: 24),
              if (controller.primaryAccount.value != null) // Hanya tampilkan form jika ada rekening
                _buildAmountForm(),
            ],
          ),
        );
      }),
    );
  }

  /// Kartu 1: Saldo Saat Ini
  Widget _buildBalanceCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Saldo Tersedia", style: Get.textTheme.titleMedium),
        Text(
          controller.rupiahFormatter.format(controller.availableBalance),
          style: Get.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primary
          ),
        ),
      ],
    );
  }

  /// Kartu 2: Rekening Tujuan
  Widget _buildDestinationCard() {
    // Cek jika pakar sudah punya rekening utama
    if (controller.primaryAccount.value == null) {
      // Case 2: Tidak ada rekening
      return _buildNoAccountWarning();
    }
    
    // Case 1: Rekening utama ada
    final account = controller.primaryAccount.value!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Tujuan Penarikan (Utama)", style: Get.textTheme.titleMedium),
        const SizedBox(height: 8),
        ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade300)
          ),
          leading: const CircleAvatar(child: FaIcon(FontAwesomeIcons.buildingColumns)),
          title: Text(account.bankName.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text("${account.accountNumber} (a.n ${account.accountHolderName})"),
          trailing: TextButton(
            child: const Text("Ganti"),
            onPressed: controller.goToManageAccounts, // Arahkan ke manajemen
          ),
        ),
      ],
    );
  }
  
  /// Peringatan jika belum ada rekening bank terdaftar
  Widget _buildNoAccountWarning() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade300)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Rekening Bank Belum Ada", style: Get.textTheme.titleMedium?.copyWith(color: Colors.red.shade900)),
          const SizedBox(height: 8),
          Text(
            "Anda harus mendaftarkan minimal 1 rekening bank dan mengaturnya sebagai 'Utama' sebelum dapat melakukan penarikan.",
            style: Get.textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: controller.goToManageAccounts, 
            icon: const FaIcon(FontAwesomeIcons.plus, size: 16),
            label: const Text("Daftarkan Rekening Sekarang"),
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade700)
          ),
        ],
      ),
    );
  }

  /// Form 3: Jumlah Penarikan
  Widget _buildAmountForm() {
    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Jumlah Penarikan", style: Get.textTheme.titleMedium),
          const SizedBox(height: 16),
          TextFormField(
            controller: controller.amountC,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: Get.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              prefixText: "Rp ",
              prefixStyle: Get.textTheme.headlineMedium?.copyWith(color: AppColors.textLight),
              labelText: "Jumlah",
              labelStyle: Get.textTheme.bodyLarge,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            validator: (v) => (v == null || v.isEmpty) ? "Wajib diisi" : null,
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: controller.setMaxAmount,
              child: const Text("Gunakan Semua Saldo"),
            ),
          )
        ],
      ),
    );
  }

  /// Tombol CTA Bawah
  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Obx(() => FilledButton(
        // Tombol non-aktif jika sedang submit ATAU jika user tidak bisa submit
        onPressed: (controller.isSubmitting.value || !controller.canSubmitRequest)
            ? null 
            : controller.submitWithdrawalRequest,
        child: controller.isSubmitting.value
            ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white))
            : const Text('Kirim Permintaan Penarikan'),
      )),
    );
  }
}