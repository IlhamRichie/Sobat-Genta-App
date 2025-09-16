import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Import intl
import '../../../../data/models/expert_model.dart';
import '../../../../data/models/payment_method_model.dart';
import '../../../../routes/app_pages.dart';

class PaymentSuccessController extends GetxController {

  // --- State Data Diterima ---
  late ExpertModel expertData;
  late PaymentMethodModel paymentMethod;
  late double totalPayment;

  // --- State Info Pesanan (Dummy) ---
  final RxString orderId = "".obs;
  final RxString orderTime = "".obs;

  @override
  void onInit() {
    super.onInit();
    
    // 1. Tangkap semua arguments
    final args = Get.arguments as Map<String, dynamic>;
    expertData = args['expert'];
    paymentMethod = args['payment'];
    totalPayment = args['total'];

    // 2. Generate data dummy untuk UI
    orderId.value = 'INV-${DateTime.now().millisecondsSinceEpoch}';
    // Format tanggal ke 'id_ID' (Indonesia)
    orderTime.value = DateFormat('d MMM yyyy, HH:mm', 'id_ID').format(DateTime.now());
  }

  // --- Aksi Tombol ---

  // 1. Aksi "Kirim Pesan"
  void goToChatRoom() {
    // 'offNamed' digunakan untuk MENGGANTI halaman sukses ini dengan ruang chat.
    // Jika pengguna back dari chat, mereka tidak akan kembali ke halaman "Sukses" ini.
    Get.offNamed(
      Routes.CONSULTATION_CHAT_ROOM,
      arguments: expertData, // Kirim data pakar ke ruang chat
    );
  }

  // 2. Aksi "Kembali ke Beranda"
  void goToHome() {
    // 'offAllNamed' akan MENGHAPUS SELURUH tumpukan navigasi checkout
    // (Summary, Instruct, Success) dan kembali ke Tab 0.
    Get.offAllNamed(Routes.MAIN_NAVIGATION);
  }
}