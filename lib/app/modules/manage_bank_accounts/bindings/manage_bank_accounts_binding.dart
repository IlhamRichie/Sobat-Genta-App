import 'package:get/get.dart';

import '../controllers/manage_bank_accounts_controller.dart';

class ManageBankAccountsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ManageBankAccountsController>(
      () => ManageBankAccountsController(),
    );
  }
}
