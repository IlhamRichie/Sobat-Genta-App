import 'package:get/get.dart';

import '../modules/00_core_auth/forgot_password/bindings/forgot_password_binding.dart';
import '../modules/00_core_auth/forgot_password/views/forgot_password_view.dart';
import '../modules/00_core_auth/login/bindings/login_binding.dart';
import '../modules/00_core_auth/login/views/login_view.dart';
import '../modules/00_core_auth/onboarding/bindings/onboarding_binding.dart';
import '../modules/00_core_auth/onboarding/views/onboarding_view.dart';
import '../modules/00_core_auth/otp_verification/bindings/otp_verification_binding.dart';
import '../modules/00_core_auth/otp_verification/views/otp_verification_view.dart';
import '../modules/00_core_auth/register_expert/bindings/register_expert_binding.dart';
import '../modules/00_core_auth/register_expert/views/register_expert_view.dart';
import '../modules/00_core_auth/register_farmer/bindings/register_farmer_binding.dart';
import '../modules/00_core_auth/register_farmer/views/register_farmer_view.dart';
import '../modules/00_core_auth/register_investor/bindings/register_investor_binding.dart';
import '../modules/00_core_auth/register_investor/views/register_investor_view.dart';
import '../modules/00_core_auth/register_role_chooser/bindings/register_role_chooser_binding.dart';
import '../modules/00_core_auth/register_role_chooser/views/register_role_chooser_view.dart';
import '../modules/00_core_auth/splash/bindings/splash_binding.dart';
import '../modules/00_core_auth/splash/views/splash_view.dart';
import '../modules/01_main_navigation/home/bindings/home_binding.dart';
import '../modules/01_main_navigation/home/views/home_view.dart';
import '../modules/01_main_navigation/home_dashboard/bindings/home_dashboard_binding.dart';
import '../modules/01_main_navigation/home_dashboard/views/home_dashboard_view.dart';
import '../modules/01_main_navigation/main_navigation/bindings/main_navigation_binding.dart';
import '../modules/01_main_navigation/main_navigation/views/main_navigation_view.dart';
import '../modules/02_clinic_support/clinic_ai_scan/bindings/clinic_ai_scan_binding.dart';
import '../modules/02_clinic_support/clinic_ai_scan/views/clinic_ai_scan_view.dart';
import '../modules/02_clinic_support/clinic_digital_library/bindings/clinic_digital_library_binding.dart';
import '../modules/02_clinic_support/clinic_digital_library/views/clinic_digital_library_view.dart';
import '../modules/02_clinic_support/clinic_expert_list/bindings/clinic_expert_list_binding.dart';
import '../modules/02_clinic_support/clinic_expert_list/views/clinic_expert_list_view.dart';
import '../modules/02_clinic_support/clinic_expert_profile/bindings/clinic_expert_profile_binding.dart';
import '../modules/02_clinic_support/clinic_expert_profile/views/clinic_expert_profile_view.dart';
import '../modules/02_clinic_support/clinic_home/bindings/clinic_home_binding.dart';
import '../modules/02_clinic_support/clinic_home/views/clinic_home_view.dart';
import '../modules/02_clinic_support/clinic_library_reader/bindings/clinic_library_reader_binding.dart';
import '../modules/02_clinic_support/clinic_library_reader/views/clinic_library_reader_view.dart';
import '../modules/02_clinic_support/consultation_chat_room/bindings/consultation_chat_room_binding.dart';
import '../modules/02_clinic_support/consultation_chat_room/views/consultation_chat_room_view.dart';
import '../modules/02_clinic_support/consultation_video_call/bindings/consultation_video_call_binding.dart';
import '../modules/02_clinic_support/consultation_video_call/views/consultation_video_call_view.dart';
import '../modules/02_clinic_support/expert_availability_settings/bindings/expert_availability_settings_binding.dart';
import '../modules/02_clinic_support/expert_availability_settings/views/expert_availability_settings_view.dart';
import '../modules/02_clinic_support/expert_dashboard/bindings/expert_dashboard_binding.dart';
import '../modules/02_clinic_support/expert_dashboard/views/expert_dashboard_view.dart';
import '../modules/02_clinic_support/expert_payout/bindings/expert_payout_binding.dart';
import '../modules/02_clinic_support/expert_payout/views/expert_payout_view.dart';
import '../modules/03_store_ecommerce/cart/bindings/cart_binding.dart';
import '../modules/03_store_ecommerce/cart/views/cart_view.dart';
import '../modules/03_store_ecommerce/checkout_address/bindings/checkout_address_binding.dart';
import '../modules/03_store_ecommerce/checkout_address/views/checkout_address_view.dart';
import '../modules/03_store_ecommerce/checkout_payment/bindings/checkout_payment_binding.dart';
import '../modules/03_store_ecommerce/checkout_payment/views/checkout_payment_view.dart';
import '../modules/03_store_ecommerce/order_confirmation/bindings/order_confirmation_binding.dart';
import '../modules/03_store_ecommerce/order_confirmation/views/order_confirmation_view.dart';
import '../modules/03_store_ecommerce/order_history/bindings/order_history_binding.dart';
import '../modules/03_store_ecommerce/order_history/views/order_history_view.dart';
import '../modules/03_store_ecommerce/order_tracking_detail/bindings/order_tracking_detail_binding.dart';
import '../modules/03_store_ecommerce/order_tracking_detail/views/order_tracking_detail_view.dart';
import '../modules/03_store_ecommerce/product_detail/bindings/product_detail_binding.dart';
import '../modules/03_store_ecommerce/product_detail/views/product_detail_view.dart';
import '../modules/03_store_ecommerce/product_reviews/bindings/product_reviews_binding.dart';
import '../modules/03_store_ecommerce/product_reviews/views/product_reviews_view.dart';
import '../modules/03_store_ecommerce/product_search/bindings/product_search_binding.dart';
import '../modules/03_store_ecommerce/product_search/views/product_search_view.dart';
import '../modules/03_store_ecommerce/store_home/bindings/store_home_binding.dart';
import '../modules/03_store_ecommerce/store_home/views/store_home_view.dart';
import '../modules/04_tender_needs/tender_create_request/bindings/tender_create_request_binding.dart';
import '../modules/04_tender_needs/tender_create_request/views/tender_create_request_view.dart';
import '../modules/04_tender_needs/tender_detail/bindings/tender_detail_binding.dart';
import '../modules/04_tender_needs/tender_detail/views/tender_detail_view.dart';
import '../modules/04_tender_needs/tender_marketplace/bindings/tender_marketplace_binding.dart';
import '../modules/04_tender_needs/tender_marketplace/views/tender_marketplace_view.dart';
import '../modules/04_tender_needs/tender_my_offers_list/bindings/tender_my_offers_list_binding.dart';
import '../modules/04_tender_needs/tender_my_offers_list/views/tender_my_offers_list_view.dart';
import '../modules/04_tender_needs/tender_submit_offer/bindings/tender_submit_offer_binding.dart';
import '../modules/04_tender_needs/tender_submit_offer/views/tender_submit_offer_view.dart';
import '../modules/05_funding_investment/farmer_add_asset_form/bindings/farmer_add_asset_form_binding.dart';
import '../modules/05_funding_investment/farmer_add_asset_form/views/farmer_add_asset_form_view.dart';
import '../modules/05_funding_investment/farmer_apply_funding_form/bindings/farmer_apply_funding_form_binding.dart';
import '../modules/05_funding_investment/farmer_apply_funding_form/views/farmer_apply_funding_form_view.dart';
import '../modules/05_funding_investment/farmer_asset_detail/bindings/farmer_asset_detail_binding.dart';
import '../modules/05_funding_investment/farmer_asset_detail/views/farmer_asset_detail_view.dart';
import '../modules/05_funding_investment/farmer_manage_assets/bindings/farmer_manage_assets_binding.dart';
import '../modules/05_funding_investment/farmer_manage_assets/views/farmer_manage_assets_view.dart';
import '../modules/05_funding_investment/farmer_my_projects_list/bindings/farmer_my_projects_list_binding.dart';
import '../modules/05_funding_investment/farmer_my_projects_list/views/farmer_my_projects_list_view.dart';
import '../modules/05_funding_investment/investor_funding_marketplace/bindings/investor_funding_marketplace_binding.dart';
import '../modules/05_funding_investment/investor_funding_marketplace/views/investor_funding_marketplace_view.dart';
import '../modules/05_funding_investment/investor_invest_form/bindings/investor_invest_form_binding.dart';
import '../modules/05_funding_investment/investor_invest_form/views/investor_invest_form_view.dart';
import '../modules/05_funding_investment/investor_portfolio/bindings/investor_portfolio_binding.dart';
import '../modules/05_funding_investment/investor_portfolio/views/investor_portfolio_view.dart';
import '../modules/05_funding_investment/investor_portfolio_detail/bindings/investor_portfolio_detail_binding.dart';
import '../modules/05_funding_investment/investor_portfolio_detail/views/investor_portfolio_detail_view.dart';
import '../modules/05_funding_investment/investor_project_detail/bindings/investor_project_detail_binding.dart';
import '../modules/05_funding_investment/investor_project_detail/views/investor_project_detail_view.dart';
import '../modules/06_profile_wallet/change_password/bindings/change_password_binding.dart';
import '../modules/06_profile_wallet/change_password/views/change_password_view.dart';
import '../modules/06_profile_wallet/kyc_form/bindings/kyc_form_binding.dart';
import '../modules/06_profile_wallet/kyc_form/views/kyc_form_view.dart';
import '../modules/06_profile_wallet/manage_bank_accounts/bindings/manage_bank_accounts_binding.dart';
import '../modules/06_profile_wallet/manage_bank_accounts/views/manage_bank_accounts_view.dart';
import '../modules/06_profile_wallet/profile_main/bindings/profile_main_binding.dart';
import '../modules/06_profile_wallet/profile_main/views/profile_main_view.dart';
import '../modules/06_profile_wallet/wallet_history/bindings/wallet_history_binding.dart';
import '../modules/06_profile_wallet/wallet_history/views/wallet_history_view.dart';
import '../modules/06_profile_wallet/wallet_main/bindings/wallet_main_binding.dart';
import '../modules/06_profile_wallet/wallet_main/views/wallet_main_view.dart';
import '../modules/06_profile_wallet/wallet_top_up/bindings/wallet_top_up_binding.dart';
import '../modules/06_profile_wallet/wallet_top_up/views/wallet_top_up_view.dart';
import '../modules/06_profile_wallet/wallet_withdraw/bindings/wallet_withdraw_binding.dart';
import '../modules/06_profile_wallet/wallet_withdraw/views/wallet_withdraw_view.dart';
import '../modules/00_core_auth/create_new_password/bindings/create_new_password_binding.dart';
import '../modules/00_core_auth/create_new_password/views/create_new_password_view.dart';
import '../modules/02_clinic_support/payment_instructions/bindings/payment_instructions_binding.dart';
import '../modules/02_clinic_support/payment_instructions/views/payment_instructions_view.dart';
import '../modules/02_clinic_support/payment_success/bindings/payment_success_binding.dart';
import '../modules/02_clinic_support/payment_success/views/payment_success_view.dart';
import '../modules/02_clinic_support/payment_summary/bindings/payment_summary_binding.dart';
import '../modules/02_clinic_support/payment_summary/views/payment_summary_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.ONBOARDING;

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
      page: () => OnboardingView(),
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
      page: () => OrderHistoryView(),
      binding: OrderHistoryBinding(),
    ),
    GetPage(
      name: _Paths.ORDER_TRACKING_DETAIL,
      page: () => const OrderTrackingDetailView(),
      binding: OrderTrackingDetailBinding(),
    ),
    GetPage(
      name: _Paths.CLINIC_HOME,
      page: () => ClinicHomeView(),
      binding: ClinicHomeBinding(),
    ),
    GetPage(
      name: _Paths.CLINIC_EXPERT_LIST,
      page: () => const ClinicExpertListView(),
      binding: ClinicExpertListBinding(),
    ),
    GetPage(
      name: _Paths.CLINIC_EXPERT_PROFILE,
      page: () => ClinicExpertProfileView(),
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
      page: () => ExpertDashboardView(),
      binding: ExpertDashboardBinding(),
    ),
    GetPage(
      name: _Paths.EXPERT_AVAILABILITY_SETTINGS,
      page: () => const ExpertAvailabilitySettingsView(),
      binding: ExpertAvailabilitySettingsBinding(),
    ),
    GetPage(
      name: _Paths.EXPERT_PAYOUT,
      page: () => ExpertPayoutView(),
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
    GetPage(
      name: _Paths.TENDER_MARKETPLACE,
      page: () => const TenderMarketplaceView(),
      binding: TenderMarketplaceBinding(),
    ),
    GetPage(
      name: _Paths.TENDER_CREATE_REQUEST,
      page: () => const TenderCreateRequestView(),
      binding: TenderCreateRequestBinding(),
    ),
    GetPage(
      name: _Paths.TENDER_DETAIL,
      page: () => const TenderDetailView(),
      binding: TenderDetailBinding(),
    ),
    GetPage(
      name: _Paths.TENDER_SUBMIT_OFFER,
      page: () => const TenderSubmitOfferView(),
      binding: TenderSubmitOfferBinding(),
    ),
    GetPage(
      name: _Paths.TENDER_MY_OFFERS_LIST,
      page: () => const TenderMyOffersListView(),
      binding: TenderMyOffersListBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE_MAIN,
      page: () => const ProfileMainView(),
      binding: ProfileMainBinding(),
    ),
    GetPage(
      name: _Paths.WALLET_MAIN,
      page: () => const WalletMainView(),
      binding: WalletMainBinding(),
    ),
    GetPage(
      name: _Paths.WALLET_HISTORY,
      page: () => WalletHistoryView(),
      binding: WalletHistoryBinding(),
    ),
    GetPage(
      name: _Paths.WALLET_TOP_UP,
      page: () => const WalletTopUpView(),
      binding: WalletTopUpBinding(),
    ),
    GetPage(
      name: _Paths.WALLET_WITHDRAW,
      page: () => const WalletWithdrawView(),
      binding: WalletWithdrawBinding(),
    ),
    GetPage(
      name: _Paths.MANAGE_BANK_ACCOUNTS,
      page: () => const ManageBankAccountsView(),
      binding: ManageBankAccountsBinding(),
    ),
    GetPage(
      name: _Paths.CHANGE_PASSWORD,
      page: () => const ChangePasswordView(),
      binding: ChangePasswordBinding(),
    ),
    GetPage(
      name: _Paths.FARMER_MANAGE_ASSETS,
      page: () => const FarmerManageAssetsView(),
      binding: FarmerManageAssetsBinding(),
    ),
    GetPage(
      name: _Paths.FARMER_ADD_ASSET_FORM,
      page: () => const FarmerAddAssetFormView(),
      binding: FarmerAddAssetFormBinding(),
    ),
    GetPage(
      name: _Paths.FARMER_ASSET_DETAIL,
      page: () => const FarmerAssetDetailView(),
      binding: FarmerAssetDetailBinding(),
    ),
    GetPage(
      name: _Paths.FARMER_APPLY_FUNDING_FORM,
      page: () => const FarmerApplyFundingFormView(),
      binding: FarmerApplyFundingFormBinding(),
    ),
    GetPage(
      name: _Paths.FARMER_MY_PROJECTS_LIST,
      page: () => FarmerMyProjectsListView(),
      binding: FarmerMyProjectsListBinding(),
    ),
    GetPage(
      name: _Paths.INVESTOR_FUNDING_MARKETPLACE,
      page: () => InvestorFundingMarketplaceView(),
      binding: InvestorFundingMarketplaceBinding(),
    ),
    GetPage(
      name: _Paths.INVESTOR_PROJECT_DETAIL,
      page: () => InvestorProjectDetailView(),
      binding: InvestorProjectDetailBinding(),
    ),
    GetPage(
      name: _Paths.INVESTOR_INVEST_FORM,
      page: () => const InvestorInvestFormView(),
      binding: InvestorInvestFormBinding(),
    ),
    GetPage(
      name: _Paths.INVESTOR_PORTFOLIO,
      page: () => InvestorPortfolioView(),
      binding: InvestorPortfolioBinding(),
    ),
    GetPage(
      name: _Paths.INVESTOR_PORTFOLIO_DETAIL,
      page: () => InvestorPortfolioDetailView(),
      binding: InvestorPortfolioDetailBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_NEW_PASSWORD,
      page: () => const CreateNewPasswordView(),
      binding: CreateNewPasswordBinding(),
    ),
    GetPage(
      name: _Paths.PAYMENT_SUMMARY,
      page: () => const PaymentSummaryView(),
      binding: PaymentSummaryBinding(),
    ),
    GetPage(
      name: _Paths.PAYMENT_INSTRUCTIONS,
      page: () => const PaymentInstructionsView(),
      binding: PaymentInstructionsBinding(),
    ),
    GetPage(
      name: _Paths.PAYMENT_SUCCESS,
      page: () => const PaymentSuccessView(),
      binding: PaymentSuccessBinding(),
    ),
  ];
}
