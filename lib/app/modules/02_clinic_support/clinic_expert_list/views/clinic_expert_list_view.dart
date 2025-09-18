// lib/app/modules/clinic_expert_list/views/clinic_expert_list_view.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../theme/app_colors.dart';
import '../../../../widgets/cards/pakar_card.dart';
import '../controllers/clinic_expert_list_controller.dart';

class ClinicExpertListView extends GetView<ClinicExpertListController> {
  const ClinicExpertListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cari Pakar ${controller.filterCategory.value.capitalizeFirst ?? ''}".trim()),
      ),
      body: Column(
        children: [
          // Bagian Filter & Search
          _buildFilterBar(),
          
          // Bagian List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.displayedPakarList.isEmpty) {
                return _buildEmptyState();
              }
              
              // Gunakan GridView agar lebih rapi
              return GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 kolom
                  childAspectRatio: 0.75, // Sesuaikan rasio kartu
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: controller.displayedPakarList.length,
                itemBuilder: (context, index) {
                  final pakar = controller.displayedPakarList[index];
                  // Panggil widget REUSABLE kita
                  return PakarCard(
                    pakar: pakar,
                    onTap: () => controller.goToPakarDetail(pakar),
                    cardWidth: double.infinity, // Biarkan Grid yang mengatur lebar
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  /// Widget untuk Search Bar dan Toggle Online
  Widget _buildFilterBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Search Bar
          TextFormField(
            controller: controller.searchC,
            onChanged: controller.onSearchChanged,
            decoration: InputDecoration(
              hintText: "Cari nama pakar atau spesialisasi...",
              prefixIcon: const FaIcon(FontAwesomeIcons.magnifyingGlass, size: 16),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
          const SizedBox(height: 8),
          // Toggle Online
          Obx(() => SwitchListTile(
                title: const Text("Hanya Tampilkan yang Online", style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text("Lihat pakar yang siap konsultasi sekarang."),
                value: controller.filterOnlineOnly.value,
                onChanged: controller.onOnlineOnlyToggled,
                activeColor: Colors.green.shade700,
                dense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 4),
              )),
        ],
      ),
    );
  }
  
  Widget _buildEmptyState() {
     return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(FontAwesomeIcons.userSlash, size: 80, color: AppColors.greyLight),
            const SizedBox(height: 24),
            Text(
              "Pakar Tidak Ditemukan",
              style: Get.textTheme.titleLarge?.copyWith(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "Coba ubah kata kunci pencarian atau matikan filter 'Online'.",
              style: Get.textTheme.bodyMedium?.copyWith(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}