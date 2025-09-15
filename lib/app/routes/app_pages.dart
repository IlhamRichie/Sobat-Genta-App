import 'package:get/get.dart';

import '../modules/cart/bindings/cart_binding.dart';
import '../modules/cart/views/cart_view.dart';
import '../modules/checkout_address/bindings/checkout_address_binding.dart';
import '../modules/checkout_address/views/checkout_address_view.dart';
import '../modules/checkout_payment/bindings/checkout_payment_binding.dart';
import '../modules/checkout_payment/views/checkout_payment_view.dart';
import '../modules/clinic_ai_scan/bindings/clinic_ai_scan_binding.dart';
import '../modules/clinic_ai_scan/views/clinic_ai_scan_view.dart';
import '../modules/clinic_digital_library/bindings/clinic_digital_library_binding.dart';
import '../modules/clinic_digital_library/views/clinic_digital_library_view.dart';
import '../modules/clinic_expert_list/bindings/clinic_expert_list_binding.dart';
import '../modules/clinic_expert_list/views/clinic_expert_list_view.dart';
import '../modules/clinic_expert_profile/bindings/clinic_expert_profile_binding.dart';
import '../modules/clinic_expert_profile/views/clinic_expert_profile_view.dart';
import '../modules/clinic_home/bindings/clinic_home_binding.dart';
import '../modules/clinic_home/views/clinic_home_view.dart';
import '../modules/clinic_library_reader/bindings/clinic_library_reader_binding.dart';
import '../modules/clinic_library_reader/views/clinic_library_reader_view.dart';
import '../modules/consultation_chat_room/bindings/consultation_chat_room_binding.dart';
import '../modules/consultation_chat_room/views/consultation_chat_room_view.dart';
import '../modules/consultation_video_call/bindings/consultation_video_call_binding.dart';
import '../modules/consultation_video_call/views/consultation_video_call_view.dart';
import '../modules/expert_availability_settings/bindings/expert_availability_settings_binding.dart';
import '../modules/expert_availability_settings/views/expert_availability_settings_view.dart';
import '../modules/expert_dashboard/bindings/expert_dashboard_binding.dart';
import '../modules/expert_dashboard/views/expert_dashboard_view.dart';
import '../modules/expert_payout/bindings/expert_payout_binding.dart';
import '../modules/expert_payout/views/expert_payout_view.dart';
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
import '../modules/order_confirmation/bindings/order_confirmation_binding.dart';
import '../modules/order_confirmation/views/order_confirmation_view.dart';
import '../modules/order_history/bindings/order_history_binding.dart';
import '../modules/order_history/views/order_history_view.dart';
import '../modules/order_tracking_detail/bindings/order_tracking_detail_binding.dart';
import '../modules/order_tracking_detail/views/order_tracking_detail_view.dart';
import '../modules/otp_verification/bindings/otp_verification_binding.dart';
import '../modules/otp_verification/views/otp_verification_view.dart';
import '../modules/product_detail/bindings/product_detail_binding.dart';
import '../modules/product_detail/views/product_detail_view.dart';
import '../modules/product_reviews/bindings/product_reviews_binding.dart';
import '../modules/product_reviews/views/product_reviews_view.dart';
import '../modules/product_search/bindings/product_search_binding.dart';
import '../modules/product_search/views/product_search_view.dart';
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
    GetPage(
      name: _Paths.PRODUCT_SEARCH,
      page: () => const ProductSearchView(),
      binding: ProductSearchBinding(),
    ),
    GetPage(
      name: _Paths.PRODUCT_DETAIL,
      page: () => const ProductDetailView(),
      binding: ProductDetailBinding(),
    ),
    GetPage(
      name: _Paths.PRODUCT_REVIEWS,
      page: () => const ProductReviewsView(),
      binding: ProductReviewsBinding(),
    ),
    GetPage(
      name: _Paths.CART,
      page: () => const CartView(),
      binding: CartBinding(),
    ),
    GetPage(
      name: _Paths.CHECKOUT_ADDRESS,
      page: () => const CheckoutAddressView(),
      binding: CheckoutAddressBinding(),
    ),
    GetPage(
      name: _Paths.CHECKOUT_PAYMENT,
      page: () => const CheckoutPaymentView(),
      binding: CheckoutPaymentBinding(),
    ),
    GetPage(
      name: _Paths.ORDER_CONFIRMATION,
      page: () => const OrderConfirmationView(),
      binding: OrderConfirmationBinding(),
    ),
    GetPage(
      name: _Paths.ORDER_HISTORY,
      page: () => const OrderHistoryView(),
      binding: OrderHistoryBinding(),
    ),
    GetPage(
      name: _Paths.ORDER_TRACKING_DETAIL,
      page: () => const OrderTrackingDetailView(),
      binding: OrderTrackingDetailBinding(),
    ),
    GetPage(
      name: _Paths.CLINIC_HOME,
      page: () => const ClinicHomeView(),
      binding: ClinicHomeBinding(),
    ),
    GetPage(
      name: _Paths.CLINIC_EXPERT_LIST,
      page: () => const ClinicExpertListView(),
      binding: ClinicExpertListBinding(),
    ),
    GetPage(
      name: _Paths.CLINIC_EXPERT_PROFILE,
      page: () => const ClinicExpertProfileView(),
      binding: ClinicExpertProfileBinding(),
    ),
    GetPage(
      name: _Paths.CONSULTATION_CHAT_ROOM,
      page: () => const ConsultationChatRoomView(),
      binding: ConsultationChatRoomBinding(),
    ),
    GetPage(
      name: _Paths.CONSULTATION_VIDEO_CALL,
      page: () => const ConsultationVideoCallView(),
      binding: ConsultationVideoCallBinding(),
    ),
    GetPage(
      name: _Paths.EXPERT_DASHBOARD,
      page: () => const ExpertDashboardView(),
      binding: ExpertDashboardBinding(),
    ),
    GetPage(
      name: _Paths.EXPERT_AVAILABILITY_SETTINGS,
      page: () => const ExpertAvailabilitySettingsView(),
      binding: ExpertAvailabilitySettingsBinding(),
    ),
    GetPage(
      name: _Paths.EXPERT_PAYOUT,
      page: () => const ExpertPayoutView(),
      binding: ExpertPayoutBinding(),
    ),
    GetPage(
      name: _Paths.CLINIC_AI_SCAN,
      page: () => const ClinicAiScanView(),
      binding: ClinicAiScanBinding(),
    ),
    GetPage(
      name: _Paths.CLINIC_DIGITAL_LIBRARY,
      page: () => const ClinicDigitalLibraryView(),
      binding: ClinicDigitalLibraryBinding(),
    ),
    GetPage(
      name: _Paths.CLINIC_LIBRARY_READER,
      page: () => const ClinicLibraryReaderView(),
      binding: ClinicLibraryReaderBinding(),
    ),
  ];
}
