import 'package:get/get.dart';

import '../controllers/wallet_main_controller.dart';

class WalletMainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WalletMainController>(
      () => WalletMainController(),
    );
  }
}
