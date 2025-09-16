import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../data/models/expert_model.dart';
import '../controllers/clinic_expert_list_controller.dart'; // Import controller

// (Konstanta warna tema konsisten)
const kPrimaryDarkGreen = Color(0xFF3A8A40);
const kLightGreenBlob = Color(0xFFEAF4EB);
const kDarkTextColor = Color(0xFF1B2C1E);
const kBodyTextColor = Color(0xFF5A6A5C);
const kTextFieldBorder = Color(0xFFD9D9D9);

class ClinicExpertListView extends GetView<ClinicExpertListController> {
  const ClinicExpertListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Daftar Pakar',
          style: TextStyle(color: kDarkTextColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: kDarkTextColor),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          // --- 1. Search Bar ---
          _buildSearchBar()
              .animate()
              .fadeIn(delay: 200.ms)
              .slideY(begin: -0.2),
          
          // --- 2. Filter Chips ---
          _buildFilterChips()
              .animate()
              .fadeIn(delay: 400.ms)
              .slideX(begin: -0.2),

          // --- 3. Daftar Pakar (Reaktif) ---
          Expanded(
            child: Obx(() {
              if (controller.filteredExperts.isEmpty) {
                return const Center(child: Text('Pakar tidak ditemukan.'));
              }
              // Daftar menggunakan ListView.builder
              return ListView.builder(
                padding: const EdgeInsets.all(24.0),
                itemCount: controller.filteredExperts.length,
                itemBuilder: (context, index) {
                  final expert = controller.filteredExperts[index];
                  // Tampilkan Kartu Pakar
                  return _buildExpertCard(context, expert)
                      .animate()
                      .fadeIn(delay: (100 * index).ms)
                      .slideX(begin: 0.5);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  // --- Helper Widgets (Best Practice) ---

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 16.0),
      child: TextFormField(
        controller: controller.searchController,
        decoration: InputDecoration(
          hintText: 'Cari nama pakar atau spesialisasi...',
          hintStyle: const TextStyle(color: kBodyTextColor),
          prefixIcon: const Icon(Icons.search, color: kBodyTextColor),
          filled: true,
          fillColor: kLightGreenBlob, // Warna BG konsisten
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none, // Tanpa border
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        itemCount: controller.filterChips.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return Obx(() {
            final filterName = controller.filterChips[index];
            final bool isSelected = 
                controller.selectedFilter.value.name == filterName.toLowerCase().split(' ').last;

            return ChoiceChip(
              label: Text(filterName),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : kPrimaryDarkGreen,
                fontWeight: FontWeight.bold,
              ),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  controller.selectFilter(index);
                }
              },
              selectedColor: kPrimaryDarkGreen,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: isSelected ? kPrimaryDarkGreen : kTextFieldBorder, width: 1.5),
              ),
            );
          });
        },
      ),
    );
  }

  // Helper untuk Kartu Pakar
  // (Ini adalah PENGGANTI untuk function _buildExpertCard di file clinic_expert_list_view.dart)

Widget _buildExpertCard(BuildContext context, ExpertModel expert) {
  return Container(
    margin: const EdgeInsets.only(bottom: 20.0),
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 15,
          offset: const Offset(0, 4),
        )
      ],
      border: Border.all(color: kTextFieldBorder.withOpacity(0.5)),
    ),
    // --- [REFACTOR] Parent diubah menjadi COLUMN ---
    child: Column(
      children: [
        // --- ROW 1: INFO UTAMA ---
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto Profile (dengan status Online)
            CircleAvatar(
              radius: 35,
              backgroundImage: NetworkImage(expert.imageUrl),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  width: 15, height: 15,
                  decoration: BoxDecoration(
                    color: expert.isOnline ? kPrimaryDarkGreen : Colors.grey,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Info Teks (Ini sekarang EXPANDED dan AMAN)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    expert.name,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: kDarkTextColor),
                    maxLines: 2, // Aman jika nama panjang
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    expert.specialtyName,
                    style: const TextStyle(
                        fontSize: 15,
                        color: kPrimaryDarkGreen,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  // Row Rating (dibuat responsif dengan Flexible)
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text(expert.rating.toString(),
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
                      const Flexible( // Ini mencegah overflow jika teks 'sesi' panjang
                        child: Text(
                          '(100+ sesi)',
                          style: TextStyle(color: kBodyTextColor, fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        const Divider(color: kTextFieldBorder, height: 1),
        const SizedBox(height: 12),

        // --- ROW 2: HARGA & TOMBOL AKSI ---
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Kolom Harga
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rp ${expert.price}',
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryDarkGreen),
                ),
                const Text('/sesi', style: TextStyle(color: kBodyTextColor, fontSize: 14)),
              ],
            ),
            // Tombol Chat
            ElevatedButton(
              onPressed: () => controller.onConsultationTap(context, expert),
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryDarkGreen,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
                child: const Row(
                children: [
                  FaIcon(FontAwesomeIcons.solidMessage, size: 16, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Chat', style: TextStyle(color: Colors.white)),
                ],
                ),
            )
          ],
        ),
      ],
    ),
  );
}
}