import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../controllers/clinic_home_controller.dart';

const kPrimaryDarkGreen = Color(0xFF3A8A40);
const kLightGreenBlob = Color(0xFFEAF4EB);
const kDarkTextColor = Color(0xFF1B2C1E);
const kBodyTextColor = Color(0xFF5A6A5C);

class ClinicHomeView extends GetView<ClinicHomeController> {
  const ClinicHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightGreenBlob, // Background halaman tab
      // AppBar kustom untuk Halaman Tab
      appBar: AppBar(
        title: const Text(
          'Klinik Tani',
          style: TextStyle(color: kDarkTextColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {}, // Tombol notifikasi
            icon: const Icon(Icons.notifications_outlined, color: kDarkTextColor),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            // Fitur Utama 1: Telekonsultasi (CTA Besar)
            _buildFeatureCardLarge(
              context: context,
              icon: FontAwesomeIcons.userDoctor,
              title: 'Telekonsultasi Pakar',
              description: 'Konsultasi chat/video langsung dengan Ahli Tani & Dokter Hewan.',
              onTap: controller.goToTelekonsultasi,
            ).animate().fadeIn(delay: 500.ms).slideX(begin: -0.2),

            const SizedBox(height: 20),
            
            // Fitur Utama 2 & 3 (Side-by-side)
            Row(
              children: [
                Expanded(
                  child: _buildFeatureCardSmall(
                    context: context,
                    icon: FontAwesomeIcons.cameraRetro,
                    title: 'Scan AI',
                    onTap: controller.goToAiScan,
                  ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.5),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildFeatureCardSmall(
                    context: context,
                    icon: FontAwesomeIcons.bookAtlas,
                    title: 'Pustaka Digital',
                    onTap: controller.goToPustakaDigital,
                  ).animate().fadeIn(delay: 900.ms).slideY(begin: 0.5),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            _buildSectionTitle(title: 'Artikel Terbaru'),
            _buildArticlePlaceholder(), // Placeholder untuk artikel
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Butuh Bantuan?',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: kDarkTextColor,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Temukan solusi instan untuk masalah pertanian atau peternakan Anda di sini.',
          style: TextStyle(
            fontSize: 17,
            color: kBodyTextColor,
            height: 1.5,
          ),
        ),
      ],
    ).animate().fadeIn(delay: 300.ms).slideY(begin: -0.2);
  }

  // Kartu CTA Besar (Telekonsultasi)
  Widget _buildFeatureCardLarge({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: kPrimaryDarkGreen,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: kPrimaryDarkGreen.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Row(
          children: [
            FaIcon(icon, color: Colors.white.withOpacity(0.8), size: 40),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
          ],
        ),
      ),
    );
  }

  // Kartu CTA Kecil (AI Scan & Pustaka)
  Widget _buildFeatureCardSmall({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        height: 120, // Tinggi tetap agar sejajar
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(icon, color: kPrimaryDarkGreen, size: 32),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: kDarkTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle({required String title}) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kDarkTextColor),
    ).animate().fadeIn();
  }

  Widget _buildArticlePlaceholder() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: const Center(child: Text('Placeholder Artikel Terbaru (ListView)')),
    ).animate().fadeIn(delay: 500.ms);
  }
}