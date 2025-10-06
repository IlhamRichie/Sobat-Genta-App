import 'package:get/get.dart';

import '../controllers/wallet_withdraw_controller.dart';

class WalletWithdrawBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WalletWithdrawController>(
      () => WalletWithdrawController(),
    );
  }
}