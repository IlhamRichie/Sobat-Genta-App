import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../controllers/onboarding_controller.dart';

// --- Palet Warna (Diambil dari kode Anda) ---
const kPrimaryColor = Color(0xFF4CAF50);
const kDarkTextColor = Color(0xFF1B2C1E);
const kBodyTextColor = Color(0xFF5A6A5C);
const kPageBackground = Colors.white;

// --- Best Practice: Buat Model Data untuk Halaman ---
class OnboardingPageModel {
  final String imagePath;
  final String title;
  final String body;

  OnboardingPageModel({
    required this.imagePath,
    required this.title,
    required this.body,
  });
}

class OnboardingView extends GetView<OnboardingController> {
  OnboardingView({Key? key}) : super(key: key);

  // --- Best Practice: Pisahkan Data dari UI ---
  // (Idealnya, list ini ada di controller atau file data terpisah)
  final List<OnboardingPageModel> onboardingPages = [
    OnboardingPageModel(
      imagePath: 'assets/onboarding/onboarding_funding.png',
      title: "Pendanaan Proyek Tani",
      body:
          "Ajukan proposal proyek tani Anda dan dapatkan pendanaan dari ribuan investor terverifikasi.",
    ),
    OnboardingPageModel(
      imagePath: 'assets/onboarding/onboarding_clinic.png',
      title: "Klinik & Konsultasi Pakar",
      body:
          "Tanya jawab langsung dengan Pakar Tani dan diagnosa penyakit via AI Scan.",
    ),
    OnboardingPageModel(
      imagePath: 'assets/onboarding/onboarding_market.png',
      title: "Pasar & Kebutuhan",
      body:
          "Temukan saprotan berkualitas di Toko Tani dan dapatkan penawaran terbaik di modul Tender.",
    ),
    OnboardingPageModel(
      imagePath: 'assets/onboarding/onboarding_start1.png',
      title: "Siap Memulai",
      body:
          "Bergabunglah dengan ekosistem GENTA untuk masa depan agrikultur yang lebih cerah.",
    ),
  ];

  // --- Style Konstan (Diambil dari kode Anda) ---
  TextStyle get _titleTextStyle {
    return const TextStyle(
      fontSize: 26.0,
      fontWeight: FontWeight.bold,
      color: kDarkTextColor,
    );
  }

  TextStyle get _bodyTextStyle {
    return const TextStyle(
      fontSize: 18.0,
      color: kBodyTextColor,
      height: 1.5,
    );
  }

  // --- [UPDATE] Helper Gambar (Dibuat Lebih Besar) ---
  Widget _buildImage(String assetName) {
    return Container(
      width: double.infinity,
      // Kurangi tinggi gambar agar tidak overflow
      height: Get.height * 0.32,
      padding: const EdgeInsets.all(8.0),
      child: Image.asset(
        assetName,
        fit: BoxFit.contain,
      ),
    );
  }

  // --- Helper untuk membangun 1 halaman slide ---
  Widget _buildPage(OnboardingPageModel page) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildImage(page.imagePath)
                .animate()
                .fadeIn(duration: 600.ms)
                .slideY(begin: 0.5, end: 0, curve: Curves.easeInOutCubic),
            const SizedBox(height: 24),
            Text(
              page.title,
              style: _titleTextStyle,
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2, end: 0),
            const SizedBox(height: 12),
            Text(
              page.body,
              style: _bodyTextStyle,
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2, end: 0),
          ],
        ),
      ),
    );
  }

  // --- Helper untuk membangun Indikator Titik (Dots) ---
  Widget _buildDotsIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        controller.totalPages,
        (index) => Obx(() { // Obx agar titik aktifnya reaktif
          return AnimatedContainer(
            duration: 300.ms,
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            height: 10,
            width: controller.currentPageIndex.value == index ? 24 : 10,
            decoration: BoxDecoration(
              color: controller.currentPageIndex.value == index
                  ? kPrimaryColor
                  : kPrimaryColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPageBackground,
      body: SafeArea(
        child: Column(
          children: [
            // --- Bagian Atas: Tombol Lewati (Skip) ---
            Obx(() {
              // Hanya tampilkan 'Lewati' jika BUKAN halaman terakhir
              return Visibility(
                visible: controller.currentPageIndex.value != controller.totalPages - 1,
                maintainAnimation: true,
                maintainState: true,
                maintainSize: true, // Agar layout tidak "lompat"
                child: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: TextButton(
                    onPressed: controller.onOnboardingDone, // 'Lewati' = Selesai
                    child: Text('Lewati',
                        style: _bodyTextStyle.copyWith(color: kPrimaryColor)),
                  ),
                ),
              );
            }),

            // --- Bagian Tengah: PageView (Carousel) ---
            Expanded(
              // PageView TIDAK AKAN SCROLL secara vertikal
              // karena dia ada di dalam Column -> Expanded
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                itemCount: controller.totalPages,
                itemBuilder: (context, index) {
                  return _buildPage(onboardingPages[index]);
                },
              ),
            ),

            // --- Bagian Bawah: Indikator Titik & Tombol Navigasi ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              child: Obx(() {
                // Tampilkan layout berdasarkan halaman aktif
                bool isLastPage = controller.currentPageIndex.value == controller.totalPages - 1;

                return isLastPage
                    // --- TAMPILAN HALAMAN TERAKHIR ---
                    ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          minimumSize: const Size(double.infinity, 56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                        onPressed: controller.onOnboardingDone,
                        child: const Text(
                          'Mulai Sekarang',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.5, end: 0)
                      
                    // --- TAMPILAN HALAMAN 1, 2, 3 ---
                    : Column(
                        children: [
                          _buildDotsIndicator(),
                          const SizedBox(height: 40),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimaryColor,
                              minimumSize: const Size(double.infinity, 56),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                            ),
                            onPressed: controller.nextPage,
                            child: const Text(
                              'Berikutnya',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      );
              }),
            ),
          ],
        ),
      ),
    );
  }
}