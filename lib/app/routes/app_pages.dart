import 'package:get/get.dart';

import '../modules/forgot_password/bindings/forgot_password_binding.dart';
import '../modules/forgot_password/views/forgot_password_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/home_dashboard/bindings/home_dashboard_binding.dart';
import '../modules/home_dashboard/views/home_dashboard_view.dart';
import '../modules/kyc_form/bindings/kyc_form_binding.dart';
import '../modules/kyc_form/views/kyc_form_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/main_navigation/bindings/main_navigation_binding.dart';
import '../modules/main_navigation/views/main_navigation_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/otp_verification/bindings/otp_verification_binding.dart';
import '../modules/otp_verification/views/otp_verification_view.dart';
import '../modules/register_expert/bindings/register_expert_binding.dart';
import '../modules/register_expert/views/register_expert_view.dart';
import '../modules/register_farmer/bindings/register_farmer_binding.dart';
import '../modules/register_farmer/views/register_farmer_view.dart';
import '../modules/register_investor/bindings/register_investor_binding.dart';
import '../modules/register_investor/views/register_investor_view.dart';
import '../modules/register_role_chooser/bindings/register_role_chooser_binding.dart';
import '../modules/register_role_chooser/views/register_role_chooser_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/store_home/bindings/store_home_binding.dart';
import '../modules/store_home/views/store_home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: _Paths.FORGOT_PASSWORD,
      page: () => const ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: _Paths.OTP_VERIFICATION,
      page: () => const OtpVerificationView(),
      binding: OtpVerificationBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER_ROLE_CHOOSER,
      page: () => const RegisterRoleChooserView(),
      binding: RegisterRoleChooserBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER_FARMER,
      page: () => const RegisterFarmerView(),
      binding: RegisterFarmerBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER_INVESTOR,
      page: () => const RegisterInvestorView(),
      binding: RegisterInvestorBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER_EXPERT,
      page: () => const RegisterExpertView(),
      binding: RegisterExpertBinding(),
    ),
    GetPage(
      name: _Paths.MAIN_NAVIGATION,
      page: () => const MainNavigationView(),
      binding: MainNavigationBinding(),
    ),
    GetPage(
      name: _Paths.HOME_DASHBOARD,
      page: () => const HomeDashboardView(),
      binding: HomeDashboardBinding(),
    ),
    GetPage(
      name: _Paths.KYC_FORM,
      page: () => const KycFormView(),
      binding: KycFormBinding(),
    ),
    GetPage(
      name: _Paths.STORE_HOME,
      page: () => const StoreHomeView(),
      binding: StoreHomeBinding(),
    ),
  ];
}
