// lib/app/bindings/initial_binding.dart

import 'package:get/get.dart';
import '../data/repositories/abstract/address_repository.dart';
import '../data/repositories/abstract/ai_diagnosis_repository.dart';
import '../data/repositories/abstract/asset_repository.dart';
import '../data/repositories/abstract/auth_repository.dart';
import '../data/repositories/abstract/bank_account_repository.dart';
import '../data/repositories/abstract/cart_repository.dart';
import '../data/repositories/abstract/consultation_repository.dart';
import '../data/repositories/abstract/digital_library_repository.dart';
import '../data/repositories/abstract/investment_repository.dart';
import '../data/repositories/abstract/order_repository.dart';
import '../data/repositories/abstract/pakar_profile_repository.dart';
import '../data/repositories/abstract/kyc_repository.dart';
import '../data/repositories/abstract/project_repository.dart';
import '../data/repositories/abstract/store_repository.dart';
import '../data/repositories/abstract/tender_repository.dart';
import '../data/repositories/abstract/wallet_repository.dart';
import '../data/repositories/implementations/fake_address_repository.dart';
import '../data/repositories/implementations/fake_ai_diagnosis_repository.dart';
import '../data/repositories/implementations/fake_asset_repository.dart';
import '../data/repositories/implementations/fake_auth_repository.dart';
import '../data/repositories/implementations/fake_bank_account_repository.dart';
import '../data/repositories/implementations/fake_cart_repository.dart';
import '../data/repositories/implementations/fake_consultation_repository.dart';
import '../data/repositories/implementations/fake_digital_library_repository.dart';
import '../data/repositories/implementations/fake_investment_repository.dart';
import '../data/repositories/implementations/fake_kyc_repository.dart';
import '../data/repositories/implementations/fake_order_repository.dart';
import '../data/repositories/implementations/fake_pakar_profile_repository.dart';
import '../data/repositories/implementations/fake_project_repository.dart';
import '../data/repositories/implementations/fake_store_repository.dart';
import '../data/repositories/implementations/fake_tender_repository.dart';
import '../data/repositories/implementations/fake_wallet_repository.dart';
import '../services/cart_service.dart';
import '../services/chat_service.dart';
import '../services/session_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
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

    Get.lazyPut<IStoreRepository>(() => FakeStoreRepository(), fenix: true);

    Get.lazyPut<ICartRepository>(() => FakeCartRepository(), fenix: true);

    Get.lazyPut<IAddressRepository>(() => FakeAddressRepository(), fenix: true);

    Get.lazyPut<IOrderRepository>(() => FakeOrderRepository(), fenix: true);

    Get.lazyPut<IWalletRepository>(() => FakeWalletRepository(), fenix: true);

    Get.lazyPut<ITenderRepository>(() => FakeTenderRepository(), fenix: true);

    Get.lazyPut<IAiDiagnosisRepository>(() => FakeAiDiagnosisRepository(), fenix: true);

    Get.lazyPut<IDigitalLibraryRepository>(() => FakeDigitalLibraryRepository(), fenix: true);

    // Nanti kita akan tambahkan repository lain di sini
    // Get.lazyPut<IStoreRepository>(() => FakeStoreRepository(), fenix: true);
    // Get.lazyPut<IFundingRepository>(() => FakeFundingRepository(), fenix: true);

    // --- Services ---
    // Kita inject SessionService sebagai singleton permanen.
    // Ini berarti data state akan hidup selama aplikasi berjalan.
    Get.put(SessionService(), permanent: true);

    Get.put(ChatService(), permanent: true); 

    Get.put(CartService(), permanent: true);
  }
}