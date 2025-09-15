import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import '../controllers/onboarding_controller.dart';
class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
      bodyTextStyle: TextStyle(fontSize: 19.0),
      bodyPadding: EdgeInsets.all(16.0),
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: controller.introKey,
      pages: [
        // Halaman 1 (Contoh: Fitur Pendanaan)
        PageViewModel(
          title: "Pendanaan Proyek Tani",
          body:
              "Ajukan proposal proyek tani Anda dan dapatkan pendanaan langsung dari ribuan investor terverifikasi.",
          image: _buildImage('assets/images/onboarding_funding.png'), // Ganti path aset Anda
          decoration: pageDecoration,
        ),
        // Halaman 2 (Contoh: Fitur Klinik)
        PageViewModel(
          title: "Klinik & Konsultasi Pakar",
          body:
              "Tanya jawab langsung dengan Pakar Tani dan Dokter Hewan, serta diagnosa penyakit via AI Scan.",
          image: _buildImage('assets/images/onboarding_clinic.png'),
          decoration: pageDecoration,
        ),
        // Halaman 3 (Contoh: Fitur Toko & Tender)
        PageViewModel(
          title: "Pasar & Kebutuhan",
          body:
              "Temukan saprotan berkualitas di Toko Tani dan dapatkan penawaran terbaik melalui modul Tender.",
          image: _buildImage('assets/images/onboarding_market.png'),
          decoration: pageDecoration,
        ),
      ],
      // Fungsi yang dijalankan saat klik "Selesai"
      onDone: () => controller.onOnboardingDone(), 
      // Fungsi yang dijalankan saat klik "Lewati"
      onSkip: () => controller.onOnboardingDone(), // Biasanya fungsinya sama dgn Done
      
      // Tampilkan Tombol Lewati (Skip)
      showSkipButton: true,
      skip: const Text('Lewati', style: TextStyle(fontWeight: FontWeight.w600)),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Selesai', style: TextStyle(fontWeight: FontWeight.w600)),
      
      // Pengaturan Indikator Titik (Dots)
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }

  // Helper widget untuk menampilkan gambar (ganti sesuai kebutuhan)
  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset(assetName, width: width);
  }
}