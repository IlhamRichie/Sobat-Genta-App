// lib/app/modules/06_profile_wallet/wallet_top_up/views/wallet_top_up_view.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; 
import '../../../../theme/app_colors.dart';
import '../controllers/wallet_top_up_controller.dart';

class WalletTopUpView extends GetView<WalletTopUpController> {
  WalletTopUpView({Key? key}) : super(key: key);

  final rupiahFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background putih bersih untuk kesan finansial
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Text(
                        "Mau isi saldo berapa?",
                        style: Get.textTheme.titleMedium?.copyWith(
                          color: AppColors.textLight,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // 1. Input Nominal Besar
                      _buildAmountInput(),
                      
                      const SizedBox(height: 8),
                      Text(
                        "Min. top up ${rupiahFormatter.format(controller.minTopUp)}",
                        style: TextStyle(color: AppColors.textLight.withOpacity(0.6), fontSize: 12),
                      ),
                      
                      const SizedBox(height: 48),
                      
                      // 2. Pilihan Cepat (Grid)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Pilihan Cepat",
                          style: Get.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildQuickAmountGrid(),
                    ],
                  ),
                ),
              ),
            ),
            
            // 3. Tombol Bottom
            _buildBottomSection(),
          ],
        ),
      ),
    );
  }

  /// AppBar Minimalis
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: const FaIcon(FontAwesomeIcons.arrowLeft, color: AppColors.textDark, size: 20),
      ),
      title: const Text(
        "Isi Saldo",
        style: TextStyle(
          color: AppColors.textDark,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      centerTitle: true,
    );
  }

  /// Input Nominal (Super Big & Clean)
  Widget _buildAmountInput() {
    return IntrinsicWidth(
      child: TextFormField(
        controller: controller.amountC,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 40, 
          fontWeight: FontWeight.w800, 
          color: AppColors.textDark,
        ),
        decoration: InputDecoration(
          prefixText: "Rp ",
          prefixStyle: const TextStyle(
            fontSize: 40, 
            fontWeight: FontWeight.w800, 
            color: AppColors.greyLight, // Warna prefix lebih pudar biar angka menonjol
          ),
          hintText: "0",
          hintStyle: TextStyle(
            fontSize: 40, 
            fontWeight: FontWeight.w800, 
            color: AppColors.greyLight.withOpacity(0.5),
          ),
          border: InputBorder.none, // Hilangkan garis bawah default
          contentPadding: EdgeInsets.zero,
        ),
        validator: (v) {
          if (v == null || v.isEmpty) return null; // Biarkan tombol handle validasi
          double? amount = double.tryParse(v);
          if (amount != null && amount < controller.minTopUp) {
            return "Minimal Rp 10.000";
          }
          return null;
        },
      ),
    );
  }

  /// Grid Pilihan Cepat (Modern Pills)
  Widget _buildQuickAmountGrid() {
    final List<double> amounts = [20000, 50000, 100000, 200000, 500000, 1000000];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: amounts.map((amount) {
        return InkWell(
          onTap: () => controller.setAmountFromChip(amount),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.greyLight),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0).format(amount),
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
                fontSize: 15,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  /// Bottom Section dengan Tombol
  Widget _buildBottomSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.greyLight.withOpacity(0.5))),
      ),
      child: SafeArea(
        child: Obx(() => SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: controller.isLoading.value ? null : () => controller.submitTopUpRequest(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: controller.isLoading.value
                ? const SizedBox(
                    height: 24, 
                    width: 24, 
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5)
                  )
                : const Text(
                    "Lanjut Pembayaran",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
          ),
        )),
      ),
    );
  }
}