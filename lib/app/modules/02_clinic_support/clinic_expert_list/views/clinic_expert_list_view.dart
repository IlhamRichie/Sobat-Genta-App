// lib/app/modules/clinic_expert_list/views/clinic_expert_list_view.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../theme/app_colors.dart';
import '../../../../widgets/cards/pakar_card.dart'; // Asumsikan PakarCard sudah di-revamp
import '../controllers/clinic_expert_list_controller.dart';

class ClinicExpertListView extends GetView<ClinicExpertListController> {
  const ClinicExpertListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildFilterBar(),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.displayedPakarList.isEmpty) {
                return _buildEmptyState();
              }
              
              return GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.65,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: controller.displayedPakarList.length,
                itemBuilder: (context, index) {
                  final pakar = controller.displayedPakarList[index];
                  return PakarCard(
                    pakar: pakar,
                    onTap: () => controller.goToPakarDetail(pakar),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  /// AppBar Kustom
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      title: Text(
        "Pakar ${controller.filterCategory.value.capitalizeFirst}".trim(),
        style: Get.textTheme.headlineSmall?.copyWith(
          color: AppColors.textDark,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: false,
    );
  }

  /// Widget untuk Search Bar dan Toggle Online (Didesain Ulang)
  Widget _buildFilterBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: TextFormField(
              controller: controller.searchC,
              onChanged: controller.onSearchChanged,
              decoration: InputDecoration(
                hintText: "Cari nama atau spesialisasi...",
                hintStyle: Get.textTheme.bodyMedium?.copyWith(color: AppColors.textLight),
                prefixIcon: const FaIcon(FontAwesomeIcons.magnifyingGlass, size: 16, color: AppColors.textLight),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Toggle Online (Revisi)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hanya Tampilkan yang Online",
                      style: Get.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Lihat pakar yg siap konsultasi sekarang.",
                      style: Get.textTheme.bodySmall?.copyWith(color: AppColors.textLight),
                    ),
                  ],
                ),
                // Switch yang lebih ringkas
                Transform.scale(
                  scale: 0.8, // Mengecilkan ukuran Switch
                  child: Switch(
                    value: controller.filterOnlineOnly.value,
                    onChanged: controller.onOnlineOnlyToggled,
                    activeColor: Colors.green,
                  ),
                ),
              ],
            )),
          ),
        ],
      ),
    );
  }
  
  /// Empty State yang Didesain Ulang
  Widget _buildEmptyState() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const FaIcon(FontAwesomeIcons.userSlash, size: 96, color: AppColors.greyLight),
              const SizedBox(height: 32),
              Text(
                "Pakar Tidak Ditemukan",
                style: Get.textTheme.titleLarge?.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                "Coba ubah kata kunci pencarian atau matikan filter 'Online'.",
                style: Get.textTheme.bodyMedium?.copyWith(
                  fontSize: 16,
                  color: AppColors.textLight,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}