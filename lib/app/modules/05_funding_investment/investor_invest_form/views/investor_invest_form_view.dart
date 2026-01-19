import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../theme/app_colors.dart';
import '../controllers/investor_invest_form_controller.dart';

class InvestorInvestFormView extends GetView<InvestorInvestFormController> {
  const InvestorInvestFormView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background putih bersih
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Investasi Baru",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      bottomNavigationBar: _buildSubmitButtonSection(),
      body: Obx(() {
        if (controller.isLoadingPage.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. Info Proyek (Minimalis)
              _buildProjectInfo(),
              const SizedBox(height: 40),
              
              // 2. Input Nominal Besar
              Text(
                "Masukkan Nominal",
                style: TextStyle(color: Colors.grey.shade500, fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              _buildBigAmountInput(),
              
              const SizedBox(height: 32),
              
              // 3. Quick Chips (Scrollable)
              _buildQuickAmountChips(),
              
              const SizedBox(height: 40),
              
              // 4. Info Saldo & Estimasi
              _buildWalletInfoCard(),
            ],
          ),
        );
      }),
    );
  }

  /// 1. Info Proyek yang sedang didanai
  Widget _buildProjectInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6F8),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const FaIcon(FontAwesomeIcons.leaf, size: 14, color: AppColors.primary),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              controller.project.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3436),
                fontSize: 14
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 2. Input Nominal Besar (Hero)
  Widget _buildBigAmountInput() {
    return IntrinsicWidth(
      child: TextField(
        controller: controller.amountC,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.w900,
          color: AppColors.primary,
        ),
        decoration: InputDecoration(
          prefixText: "Rp ",
          prefixStyle: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w900,
            color: AppColors.primary,
          ),
          hintText: "0",
          hintStyle: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w900,
            color: Colors.grey.shade300,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }

  /// 3. Quick Chips (Scrollable Horizontal)
  Widget _buildQuickAmountChips() {
    final List<double> quickAmounts = [500000, 1000000, 2000000, 5000000];
    final rupiahFormatter = NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0);

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: quickAmounts.length + 1, // +1 button max
        separatorBuilder: (ctx, i) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          if (index == quickAmounts.length) {
            // Tombol Max
            return _buildChip(
              label: "Maksimal",
              onTap: controller.setMaxAmount,
              isPrimary: true,
            );
          }
          final amount = quickAmounts[index];
          return _buildChip(
            label: rupiahFormatter.format(amount),
            onTap: () => controller.setAmountFromChip(amount),
            isPrimary: false,
          );
        },
      ),
    );
  }

  Widget _buildChip({required String label, required VoidCallback onTap, bool isPrimary = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isPrimary ? AppColors.primary.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isPrimary ? AppColors.primary : Colors.grey.shade300,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isPrimary ? AppColors.primary : Colors.grey.shade600,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  /// 4. Info Saldo & Estimasi ROI
  Widget _buildWalletInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Row Saldo
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Saldo Tersedia", style: TextStyle(color: Colors.grey)),
              Text(
                controller.rupiahFormatter.format(controller.availableBalance),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1),
          ),
          // Row Estimasi ROI
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Estimasi ROI (12%)", style: TextStyle(color: Colors.grey)),
              const Text(
                "Tahun Pertama",
                style: TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Tombol Submit (Sticky)
  Widget _buildSubmitButtonSection() {
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
            onPressed: controller.isLoading.value ? null : controller.submitInvestment,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: controller.isLoading.value
                ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                : const Text("Konfirmasi Investasi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          )),
        ),
      ),
    );
  }
}