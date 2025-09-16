import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/expert_model.dart';
import '../../../data/models/payment_method_model.dart'; // Import model baru
import '../../../routes/app_pages.dart'; // Import routes

// (Konstanta warna tema konsisten)
const kPrimaryDarkGreen = Color(0xFF3A8A40);
const kDarkTextColor = Color(0xFF1B2C1E);
const kBodyTextColor = Color(0xFF5A6A5C);

class PaymentSummaryController extends GetxController {
  
  late ExpertModel expertData;

  // --- State Perhitungan Biaya ---
  final double adminFee = 2500; // Biaya Admin (UI Dulu Aja)
  final RxDouble subtotal = 0.0.obs;
  final RxDouble total = 0.0.obs;

  // --- State Metode Pembayaran ---
  // (null berarti belum dipilih)
  final Rx<PaymentMethodModel?> selectedMethod = Rx<PaymentMethodModel?>(null);
  
  // (UI Dulu Aja - Daftar metode pembayaran untuk bottom sheet)
  final List<PaymentMethodModel> eWallets = [
    PaymentMethodModel(name: 'DANA', code: 'DANA', logoAsset: 'assets/logos/dana.png'),
    PaymentMethodModel(name: 'GOPAY', code: 'GOPAY', logoAsset: 'assets/logos/gopay.png'),
    PaymentMethodModel(name: 'OVO', code: 'OVO', logoAsset: 'assets/logos/ovo.png'),
  ];
  final List<PaymentMethodModel> virtualAccounts = [
    PaymentMethodModel(name: 'BCA Virtual Account', code: 'BCA_VA', logoAsset: 'assets/logos/bca.png'),
    PaymentMethodModel(name: 'Mandiri Virtual Account', code: 'MANDIRI_VA', logoAsset: 'assets/logos/mandiri.png'),
  ];

  @override
  void onInit() {
    super.onInit();
    // 1. Tangkap data ExpertModel
    expertData = Get.arguments as ExpertModel;
    
    // 2. Hitung harga
    // (Simulasi parsing harga '50rb' -> 50000)
    double price = double.tryParse(expertData.price.replaceAll('rb', '000')) ?? 0.0;
    subtotal.value = price;
    total.value = price + adminFee;
  }

  // --- Aksi Utama ---
  
  // 1. Dipanggil saat tombol "Pilih Pembayaran" (bawah) ditekan
  void onChoosePaymentPressed() {
    if (selectedMethod.value == null) {
      Get.snackbar("Pilih Pembayaran", "Silakan pilih metode pembayaran terlebih dahulu.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    // (LOGIC API NANTI DI SINI: Buat 'charge' ke payment gateway)
    
    // (UI SEMENTARA) Navigasi ke halaman instruksi
    Get.toNamed(
      Routes.PAYMENT_INSTRUCTIONS, // <-- Rute BARU yang akan kita buat
      arguments: {
        'expert': expertData,
        'payment': selectedMethod.value,
        'total': total.value,
      },
    );
  }

  // 2. Dipanggil saat "Metode Pembayaran" di-tap
  // Ini akan membuka bottom sheet (sesuai image_8fc710.png)
  void openPaymentMethodSheet() {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.6,
        padding: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Header Bottom Sheet ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Pilih Metode Pembayaran',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kDarkTextColor),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: kDarkTextColor),
                  onPressed: () => Get.back(),
                )
              ],
            ),
            const Divider(),
            
            // --- Daftar Metode ---
            Expanded(
              child: ListView(
                children: [
                  _buildPaymentCategoryTitle('E-Wallet'),
                  ...eWallets.map((method) => _buildPaymentMethodTile(method)),
                  const SizedBox(height: 16),
                  _buildPaymentCategoryTitle('Virtual Account (VA)'),
                  ...virtualAccounts.map((method) => _buildPaymentMethodTile(method)),
                ],
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true, // Wajib untuk bottom sheet dinamis
    );
  }

  // Helper untuk tile di dalam Bottom Sheet
  Widget _buildPaymentCategoryTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: kBodyTextColor)),
    );
  }

  // Helper untuk tile di dalam Bottom Sheet
  Widget _buildPaymentMethodTile(PaymentMethodModel method) {
    return ListTile(
      leading: Image.asset(method.logoAsset, width: 40, height: 40, fit: BoxFit.contain),
      title: Text(method.name, style: const TextStyle(fontWeight: FontWeight.bold, color: kDarkTextColor)),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: kBodyTextColor),
      onTap: () {
        // 1. Set metode yang dipilih
        selectedMethod.value = method;
        // 2. Tutup bottom sheet
        Get.back();
      },
    );
  }
}