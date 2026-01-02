// lib/app/modules/onboarding/views/onboarding_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../theme/app_colors.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Mengambil tinggi layar untuk proporsi
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background, // Pastikan warna background agak terang (ex: Colors.grey[50])
      body: Stack(
        children: [
          // 1. BACKGROUND ORNAMENTS (Aesthetic Blobs)
          // Lingkaran utama (Pudar)
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.2),
                    AppColors.primary.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          // Lingkaran kedua (Kecil di kanan tengah)
          Positioned(
            top: height * 0.3,
            right: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondary?.withOpacity(0.1) ?? Colors.orange.withOpacity(0.1),
              ),
            ),
          ),

          // 2. MAIN CONTENT (PageView)
          Column(
            children: [
              // Bagian Atas: Gambar (Mengambil sisa ruang di atas sheet)
              Expanded(
                flex: 3,
                child: PageView.builder(
                  controller: controller.pageController,
                  onPageChanged: controller.onPageChanged,
                  itemCount: 3, // Sesuaikan jumlah halaman
                  itemBuilder: (context, index) {
                    // Data statis (Bisa dipindah ke controller jika mau lebih rapi)
                    final List<Map<String, String>> data = [
                      {
                        "image": 'assets/onboarding/onboarding_funding.png',
                        "title": 'Pendanaan Proyek Transparan', // Judul tidak ditampilkan disini, tapi di bawah
                        "desc": ""
                      },
                      {
                        "image": 'assets/onboarding/onboarding_market.png',
                        "title": 'Toko Kebutuhan Tani',
                        "desc": ""
                      },
                      {
                        "image": 'assets/onboarding/onboarding_clinic.png',
                        "title": 'Klinik Tani & Pakar',
                        "desc": ""
                      },
                    ];
                    return Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Center(
                        child: Image.asset(
                          data[index]['image']!,
                          fit: BoxFit.contain,
                        ),
                      ),
                    );
                  },
                ),
              ),

              // 3. MODERN BOTTOM SHEET (Text & Controls)
              Expanded(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 20,
                        offset: Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
                    child: Column(
                      children: [
                        // Indikator Halaman (Dots) di Tengah atas Sheet
                        Obx(() => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            controller.totalPages,
                            (index) => _buildDotIndicator(
                              index: index,
                              isActive: controller.currentPageIndex.value == index,
                            ),
                          ),
                        )),
                        
                        const Spacer(),

                        // Teks Judul & Deskripsi (Berubah sesuai Page)
                        // Note: Kita butuh listener PageView untuk ubah teks, 
                        // atau gunakan IndexedStack. Disini saya asumsi pakai Obx sederhana.
                        Obx(() {
                          final index = controller.currentPageIndex.value;
                          final contents = [
                             {
                                'title': 'Pendanaan Proyek\nTransparan',
                                'desc': 'Hubungkan lahan produktif Anda dengan investor terverifikasi demi hasil maksimal.'
                             },
                             {
                                'title': 'Toko Kebutuhan\nPertanian',
                                'desc': 'Temukan bibit unggul, pupuk, dan alat berkualitas langsung dari produsen.'
                             },
                             {
                                'title': 'Klinik Tani &\nKonsultasi Pakar',
                                'desc': 'Dapatkan solusi instan untuk masalah tanaman dari pakar pertanian dan dokter hewan.'
                             },
                          ];
                          
                          return Column(
                            children: [
                              Text(
                                contents[index]['title']!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textDark, // Warna teks gelap
                                  height: 1.2,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                contents[index]['desc']!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: AppColors.textLight, // Warna teks abu/ringan
                                  height: 1.5,
                                ),
                              ),
                            ],
                          );
                        }),

                        const Spacer(),

                        // Tombol Utama (Full Width Modern Button)
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: Obx(() {
                            bool isLast = controller.currentPageIndex.value == controller.totalPages - 1;
                            return ElevatedButton(
                              onPressed: controller.nextPage,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                shadowColor: AppColors.primary.withOpacity(0.5),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    isLast ? "Mulai Sekarang" : "Lanjut",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (!isLast) ...[
                                    const SizedBox(width: 8),
                                    const Icon(Icons.arrow_forward_rounded, size: 20),
                                  ]
                                ],
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // 4. TOMBOL LEWATI (Skip) - Floating Pill Style
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            right: 20,
            child: Obx(() => AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: controller.currentPageIndex.value == controller.totalPages - 1 ? 0.0 : 1.0,
              child: TextButton(
                onPressed: controller.skip,
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.8), // Efek Glassmorphism dikit
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: const Text(
                  "Lewati",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            )),
          ),
        ],
      ),
    );
  }

  // Widget Indikator (Modern Pill Shape)
  Widget _buildDotIndicator({required int index, required bool isActive}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 6,
      width: isActive ? 32 : 6, // Transisi dari titik ke garis panjang
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.greyLight.withOpacity(0.5),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}