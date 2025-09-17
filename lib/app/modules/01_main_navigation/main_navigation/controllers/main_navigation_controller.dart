import 'package:get/get.dart';
import '../../../../routes/app_pages.dart';

// [UPDATE] Tambahkan status 'inReview'
enum UserKycStatus { pending, inReview, verified }

class MainNavigationController extends GetxController {
  
  final RxInt selectedIndex = 0.obs;

  void onItemTapped(int index) {
    selectedIndex.value = index;
  }

  // [SIMULASI] Tetap mulai sebagai 'pending' (belum mengisi)
  final Rx<UserKycStatus> kycStatus = UserKycStatus.verified.obs;
  //pending

  // (Nanti, 'kycStatus' ini akan diisi dari data user_model saat login)

  void goToKycForm() {
    Get.toNamed(Routes.KYC_FORM);
  }
}