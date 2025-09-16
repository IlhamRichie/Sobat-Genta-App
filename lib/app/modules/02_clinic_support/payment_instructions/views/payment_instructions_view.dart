import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../controllers/payment_instructions_controller.dart';

// (Konstanta warna tema konsisten)
const kPrimaryDarkGreen = Color(0xFF3A8A40);
const kLightGreenBlob = Color(0xFFEAF4EB);
const kDarkTextColor = Color(0xFF1B2C1E);
const kBodyTextColor = Color(0xFF5A6A5C);
const kTextFieldBorder = Color(0xFFD9D9D9);

class PaymentInstructionsView extends GetView<PaymentInstructionsController> {
  const PaymentInstructionsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightGreenBlob, // Background abu-abu muda
      appBar: AppBar(
        title: const Text('Pembayaran',
            style: TextStyle(color: kDarkTextColor, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: kDarkTextColor),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildHeaderCard(context)
                .animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
            const SizedBox(height: 20),
            _buildVaCard(context)
                .animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
            const SizedBox(height: 20),
            _buildInstructionsExpansion()
                .animate().fadeIn(delay: 600.ms).slideY(begin: 0.2),
          ],
        ),
      ),
      // Tombol Sticky di Bawah
      bottomNavigationBar: _buildStickyButton(context),
    );
  }

  // --- Helper Widgets (Best Practice) ---

  // Kartu Header (Metode & Total)
  Widget _buildHeaderCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(controller.paymentMethod.logoAsset, height: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('Total Pembayaran', style: TextStyle(color: kBodyTextColor, fontSize: 15)),
                  Text(
                    'Rp ${controller.totalPayment.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: kPrimaryDarkGreen,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Divider(height: 24, color: kTextFieldBorder),
          // Timer Countdown (Reaktif)
          Obx(() {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Selesaikan dalam', style: TextStyle(color: kBodyTextColor, fontSize: 15)),
                Text(
                  controller.formattedCountdown, // Data dari controller
                  style: const TextStyle(
                    color: kDarkTextColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  // Kartu Nomor Virtual Account
  Widget _buildVaCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nomor Virtual Account (${controller.paymentMethod.name})',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: kBodyTextColor),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                controller.virtualAccount,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: kDarkTextColor,
                ),
              ),
              OutlinedButton.icon(
                onPressed: () => controller.copyToClipboard(context),
                icon: const FaIcon(FontAwesomeIcons.copy, size: 16, color: kPrimaryDarkGreen),
                label: const Text('Salin', style: TextStyle(color: kPrimaryDarkGreen, fontWeight: FontWeight.bold)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: kPrimaryDarkGreen, width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  // Petunjuk Pembayaran (ExpansionTile)
  Widget _buildInstructionsExpansion() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: ExpansionTile(
        title: const Text(
          'Petunjuk Pembayaran',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kDarkTextColor),
        ),
        tilePadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
        childrenPadding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 20.0),
        children: [
          // (UI Dulu Aja: Isi dengan langkah-langkah dummy)
          _buildInstructionStep(1, 'Buka aplikasi ${controller.paymentMethod.name} Anda.'),
          _buildInstructionStep(2, 'Pilih menu "Bayar" atau "Transfer".'),
          _buildInstructionStep(3, 'Masukkan Nomor Virtual Account di atas.'),
          _buildInstructionStep(4, 'Konfirmasi jumlah pembayaran (Rp ${controller.totalPayment.toStringAsFixed(0)}).'),
          _buildInstructionStep(5, 'Masukkan PIN Anda dan selesaikan transaksi.'),
        ],
      ),
    );
  }

  Widget _buildInstructionStep(int step, String text) {
    return ListTile(
      leading: CircleAvatar(
        radius: 14,
        backgroundColor: kPrimaryDarkGreen,
        child: Text('$step', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
      ),
      title: Text(text, style: const TextStyle(color: kBodyTextColor, fontSize: 15, height: 1.4)),
    );
  }

  // Tombol Bawah (Sticky)
  Widget _buildStickyButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 15)],
      ),
      child: ElevatedButton(
        onPressed: () => controller.checkPaymentStatus(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryDarkGreen,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Text(
          'Cek Status Pembayaran',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.5),
    );
  }
}