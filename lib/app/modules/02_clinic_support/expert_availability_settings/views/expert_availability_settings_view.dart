// lib/app/modules/expert_availability_settings/views/expert_availability_settings_view.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../data/models/availability_slot_model.dart';
import '../../../../theme/app_colors.dart';
import '../controllers/expert_availability_settings_controller.dart';

class ExpertAvailabilitySettingsView
    extends GetView<ExpertAvailabilitySettingsController> {
  const ExpertAvailabilitySettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      bottomNavigationBar: _buildBottomSaveButton(),
      body: Obx(() {
        if (controller.isLoadingPage.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFeeSection(),
              const SizedBox(height: 24),
              _buildScheduleSection(),
              const SizedBox(height: 24),
            ],
          ),
        );
      }),
    );
  }

  /// AppBar Kustom
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: BackButton(
        color: AppColors.textDark,
        onPressed: () => Get.back(),
      ),
      title: Text(
        "Atur Jadwal & Tarif",
        style: Get.textTheme.headlineSmall?.copyWith(
          color: AppColors.textDark,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: false,
    );
  }

  /// Bagian 1: Pengaturan Tarif (Didesain Ulang)
  Widget _buildFeeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Tarif Konsultasi",
          style: Get.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          "Atur biaya yang akan dibayar pengguna untuk per sesi konsultasi.",
          style: Get.textTheme.bodyMedium?.copyWith(color: AppColors.textLight),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller.feeC,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: Get.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              labelText: "Tarif per Sesi",
              prefixText: "Rp ",
              prefixStyle: Get.textTheme.headlineSmall?.copyWith(color: AppColors.textLight),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.greyLight)),
            ),
          ),
        ),
      ],
    );
  }

  /// Bagian 2: Pengaturan Jadwal (Didesain Ulang)
  Widget _buildScheduleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Jam Ketersediaan (Praktik)",
          style: Get.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          "Atur hari dan jam di mana Anda bersedia menerima konsultasi.",
          style: Get.textTheme.bodyMedium?.copyWith(color: AppColors.textLight),
        ),
        const SizedBox(height: 16),
        Obx(() => ListView.builder(
              itemCount: controller.scheduleList.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final slot = controller.scheduleList[index];
                return _buildDayRow(context, slot, index);
              },
            )),
      ],
    );
  }

  /// Satu baris hari (Senin, Selasa, dst) (Didesain Ulang)
  Widget _buildDayRow(BuildContext context, AvailabilitySlot slot, int index) {
    return Obx(() {
      bool isActive = slot.isActive.value;
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive ? AppColors.primary : AppColors.greyLight,
            width: isActive ? 1.5 : 1.0,
          ),
          boxShadow: [
            if (isActive)
              BoxShadow(
                color: AppColors.primary.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      slot.dayName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isActive ? AppColors.textDark : AppColors.textLight,
                      ),
                    ),
                  ],
                ),
                Switch(
                  value: isActive,
                  onChanged: (value) => controller.toggleDayActive(index, value),
                  activeColor: AppColors.primary,
                ),
              ],
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: isActive ? 60 : 0,
              curve: Curves.easeInOut,
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildTimePickerButton(context, index, slot.startTime.value, true, isActive),
                      const Text("-", style: TextStyle(fontWeight: FontWeight.bold)),
                      _buildTimePickerButton(context, index, slot.endTime.value, false, isActive),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  /// Tombol untuk memilih jam (Start atau End) (Didesain Ulang)
  Widget _buildTimePickerButton(BuildContext context, int index, String time, bool isStartTime, bool isActive) {
    return InkWell(
      onTap: isActive ? () => controller.selectTime(context, index, isStartTime) : null,
      child: Column(
        children: [
          Text(
            isStartTime ? "Mulai" : "Selesai",
            style: Get.textTheme.bodySmall?.copyWith(color: AppColors.textLight),
          ),
          Text(
            time,
            style: Get.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isActive ? AppColors.primary : AppColors.textLight.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
  
  /// Tombol Simpan di Bawah (Didesain Ulang)
  Widget _buildBottomSaveButton() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Obx(() => FilledButton(
        onPressed: controller.isSaving.value ? null : controller.saveSettings,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
        ),
        child: controller.isSaving.value
            ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : const Text("Simpan Pengaturan", style: TextStyle(fontWeight: FontWeight.bold)),
      )),
    );
  }
}