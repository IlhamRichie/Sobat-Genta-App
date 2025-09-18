// lib/app/bindings/initial_binding.dart

import 'package:get/get.dart';
import '../data/repositories/abstract/asset_repository.dart';
import '../data/repositories/abstract/auth_repository.dart';
import '../data/repositories/abstract/bank_account_repository.dart';
import '../data/repositories/abstract/consultation_repository.dart';
import '../data/repositories/abstract/investment_repository.dart';
import '../data/repositories/abstract/pakar_profile_repository.dart';
import '../data/repositories/abstract/kyc_repository.dart';
import '../data/repositories/abstract/project_repository.dart';
import '../data/repositories/abstract/store_repository.dart';
import '../data/repositories/implementations/fake_asset_repository.dart';
import '../data/repositories/implementations/fake_auth_repository.dart';
import '../data/repositories/implementations/fake_bank_account_repository.dart';
import '../data/repositories/implementations/fake_consultation_repository.dart';
import '../data/repositories/implementations/fake_investment_repository.dart';
import '../data/repositories/implementations/fake_kyc_repository.dart';
import '../data/repositories/implementations/fake_pakar_profile_repository.dart';
import '../data/repositories/implementations/fake_project_repository.dart';
import '../data/repositories/implementations/fake_store_repository.dart';
import '../services/chat_service.dart';
import '../services/session_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // --- Services ---
    // Kita inject SessionService sebagai singleton permanen.
    // Ini berarti data state akan hidup selama aplikasi berjalan.
    Get.put(SessionService(), permanent: true);

    // --- Repositories ---
    // Kita inject implementasi FAKE dari IAuthRepository.
    // fenix: true -> jika tidak sengaja ter-delete, akan dibuat ulang
    Get.lazyPut<IAuthRepository>(() => FakeAuthRepository(), fenix: true);

    Get.lazyPut<IKycRepository>(() => FakeKycRepository(), fenix: true);

    Get.lazyPut<IAssetRepository>(() => FakeAssetRepository(), fenix: true);

    Get.lazyPut<IProjectRepository>(() => FakeProjectRepository(), fenix: true);

    Get.lazyPut<IInvestmentRepository>(() => FakeInvestmentRepository(), fenix: true);

    Get.lazyPut<IPakarProfileRepository>(() => FakePakarProfileRepository(), fenix: true);

    Get.lazyPut<IBankAccountRepository>(() => FakeBankAccountRepository(), fenix: true);

    Get.lazyPut<IConsultationRepository>(() => FakeConsultationRepository(), fenix: true);

    Get.put(ChatService(), permanent: true); 

    Get.lazyPut<IStoreRepository>(() => FakeStoreRepository(), fenix: true);

    // Nanti kita akan tambahkan repository lain di sini
    // Get.lazyPut<IStoreRepository>(() => FakeStoreRepository(), fenix: true);
    // Get.lazyPut<IFundingRepository>(() => FakeFundingRepository(), fenix: true);
  }
}