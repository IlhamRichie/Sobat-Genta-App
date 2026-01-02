// lib/app/modules/expert_payout/views/expert_payout_view.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../theme/app_colors.dart';
import '../controllers/expert_payout_controller.dart';

class ExpertPayoutView extends GetView<ExpertPayoutController> {
  ExpertPayoutView({Key? key}) : super(key: key);

  final rupiahFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // 1. BACKGROUND DECORATION
          Positioned(
            top: -80,
            right: -60,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.05), // Nuansa hijau uang
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 150,
            left: -80,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // 2. MAIN CONTENT
          SafeArea(
            child: Column(
              children: [
                _buildCustomAppBar(),
                
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: controller.fetchPayoutData,
                    color: AppColors.primary,
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      
                      return SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildEarningsCard(),
                            const SizedBox(height: 24),
                            
                            _buildSectionTitle("Rekening Pencairan"),
                            const SizedBox(height: 12),
                            _buildBankAccountsSection(),
                            
                            const SizedBox(height: 24),
                            _buildSectionTitle("Riwayat Transaksi"),
                            const SizedBox(height: 12),
                            _buildHistorySection(),
                            
                            const SizedBox(height: 40),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Custom AppBar
  Widget _buildCustomAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textDark),
                  onPressed: () => Get.back(),
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                "Keuangan",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          // Ikon Bantuan atau Info
          IconButton(
            onPressed: () {}, 
            icon: const FaIcon(FontAwesomeIcons.circleQuestion, color: AppColors.textLight),
          ),
        ],
      ),
    );
  }

  /// 1. Kartu Penghasilan (Premium Gradient)
  Widget _buildEarningsCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2E7D32), Color(0xFF43A047)], // Hijau tua ke hijau terang
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Pattern
          Positioned(
            right: -20,
            top: -20,
            child: Icon(
              FontAwesomeIcons.moneyBillWave,
              size: 150,
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          FaIcon(FontAwesomeIcons.wallet, size: 12, color: Colors.white),
                          SizedBox(width: 6),
                          Text(
                            "SALDO AKTIF",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Obx(() => Text(
                  rupiahFormatter.format(controller.wallet.value?.balance ?? 0),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.2,
                  ),
                )),
                const SizedBox(height: 4),
                Text(
                  "Total penghasilan siap tarik",
                  style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13),
                ),
                const SizedBox(height: 24),
                
                // Tombol Withdraw
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: controller.canWithdraw ? controller.goToWithdrawForm : null,
                    icon: const FaIcon(FontAwesomeIcons.moneyBillTransfer, size: 16),
                    label: const Text("Tarik Dana Sekarang"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF2E7D32),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 2. Rekening Bank (Card Style)
  Widget _buildBankAccountsSection() {
    return Obx(() {
      if (controller.accountList.isEmpty) {
        return _buildEmptyBankAccount();
      }
      
      // Ambil akun utama atau yang pertama
      final account = controller.accountList.firstWhere(
        (acc) => acc.isPrimary,
        orElse: () => controller.accountList.first,
      );

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.greyLight.withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 50, height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: FaIcon(FontAwesomeIcons.buildingColumns, color: AppColors.primary, size: 24),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        account.bankName.toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDark),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        account.accountNumber,
                        style: const TextStyle(fontSize: 14, color: AppColors.textLight, fontFamily: 'monospace'),
                      ),
                      Text(
                        account.accountHolderName,
                        style: const TextStyle(fontSize: 12, color: AppColors.textLight),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.check_circle, color: Colors.green, size: 20),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1, color: AppColors.greyLight),
            const SizedBox(height: 12),
            InkWell(
              onTap: controller.goToManageAccounts,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("Kelola Rekening", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 14)),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppColors.primary),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildEmptyBankAccount() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.greyLight, style: BorderStyle.solid),
      ),
      child: Column(
        children: [
          const FaIcon(FontAwesomeIcons.creditCard, size: 40, color: AppColors.greyLight),
          const SizedBox(height: 16),
          const Text(
            "Belum Ada Rekening",
            style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark),
          ),
          const SizedBox(height: 4),
          const Text(
            "Tambahkan rekening untuk menerima pembayaran.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: AppColors.textLight),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: controller.goToManageAccounts,
            icon: const FaIcon(FontAwesomeIcons.plus, size: 14),
            label: const Text("Tambah Rekening"),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  /// 3. Riwayat Transaksi (Timeline Style)
  Widget _buildHistorySection() {
    // Mock Data (Ganti dengan controller.historyList jika sudah ada)
    // Saat ini kita hardcode 1 item contoh seperti request sebelumnya
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        children: [
          _buildHistoryItem(
            title: "Penarikan Dana",
            date: "15 Sep 2025, 10:00",
            amount: -1200000,
            status: "Berhasil",
          ),
          const Divider(height: 1, indent: 70, endIndent: 20, color: AppColors.greyLight),
          _buildHistoryItem(
            title: "Konsultasi #TRX-998",
            date: "14 Sep 2025, 14:30",
            amount: 150000,
            status: "Masuk",
          ),
          // Tambahkan tombol "Lihat Semua" jika perlu
        ],
      ),
    );
  }

  Widget _buildHistoryItem({
    required String title,
    required String date,
    required double amount,
    required String status,
  }) {
    bool isCredit = amount > 0;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isCredit ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: FaIcon(
              isCredit ? FontAwesomeIcons.arrowDown : FontAwesomeIcons.arrowUp, // Arrow logic: Down=Masuk, Up=Keluar
              color: isCredit ? Colors.green : Colors.orange,
              size: 18,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textDark)),
                const SizedBox(height: 4),
                Text(date, style: const TextStyle(fontSize: 12, color: AppColors.textLight)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${isCredit ? '+' : ''} ${rupiahFormatter.format(amount)}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: isCredit ? Colors.green : Colors.orange,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                status,
                style: TextStyle(fontSize: 11, color: isCredit ? Colors.green : AppColors.textLight, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.textDark,
      ),
    );
  }
}