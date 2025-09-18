// lib/app/modules/expert_availability_settings/views/expert_availability_settings_view.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../data/models/availability_slot_model.dart';
import '../../../../theme/app_colors.dart';
import '../controllers/expert_availability_settings_controller.dart';

class ExpertAvailabilitySettingsView
    extends GetView<ExpertAvailabilitySettingsController> {
  const ExpertAvailabilitySettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Atur Jadwal & Tarif"),
      ),
      bottomNavigationBar: _buildBottomSaveButton(),
      body: Obx(() {
        if (controller.isLoadingPage.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFeeSection(),
              const Divider(height: 32),
              _buildScheduleSection(),
            ],
          ),
        );
      }),
    );
  }

  /// Bagian 1: Pengaturan Tarif
  Widget _buildFeeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Tarif Konsultasi",
          style: Get.textTheme.titleLarge?.copyWith(fontSize: 18),
        ),
        const SizedBox(height: 4),
        Text(
          "Atur biaya yang akan dibayar pengguna untuk per sesi konsultasi.",
          style: Get.textTheme.bodyMedium?.copyWith(color: AppColors.textLight),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: controller.feeC,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            labelText: "Tarif per Sesi",
            prefixText: "Rp ",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }

  /// Bagian 2: Pengaturan Jadwal
  Widget _buildScheduleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Jam Ketersediaan (Praktik)",
          style: Get.textTheme.titleLarge?.copyWith(fontSize: 18),
        ),
        const SizedBox(height: 4),
        Text(
          "Atur hari dan jam di mana Anda bersedia menerima konsultasi.",
          style: Get.textTheme.bodyMedium?.copyWith(color: AppColors.textLight),
        ),
        const SizedBox(height: 16),
        // Render 7 hari dari RxList
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

  /// Satu baris hari (Senin, Selasa, dst)
  Widget _buildDayRow(BuildContext context, AvailabilitySlot slot, int index) {
    return Obx(() {
      bool isActive = slot.isActive.value;
      return Card(
        elevation: 0,
        color: isActive ? AppColors.primary.withOpacity(0.05) : AppColors.greyLight.withOpacity(0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: isActive ? AppColors.primary.withOpacity(0.3) : Colors.grey.shade300)
        ),
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Column(
            children: [
              // Baris utama: Toggle dan Nama Hari
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: SwitchListTile(
                      value: isActive,
                      onChanged: (value) => controller.toggleDayActive(index, value),
                      title: Text(slot.dayName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                ],
              ),
              // Baris kedua: Pilihan Jam (hanya tampil jika aktif)
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: isActive ? 60 : 0,
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildTimePickerButton(context, index, slot.startTime.value, true),
                        const Text("-", style: TextStyle(fontWeight: FontWeight.bold)),
                        _buildTimePickerButton(context, index, slot.endTime.value, false),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  /// Tombol untuk memilih jam (Start atau End)
  Widget _buildTimePickerButton(BuildContext context, int index, String time, bool isStartTime) {
    return TextButton(
      onPressed: () => controller.selectTime(context, index, isStartTime),
      child: Column(
        children: [
          Text(isStartTime ? "Mulai" : "Selesai", style: Get.textTheme.bodySmall),
          Text(time, style: Get.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary)),
        ],
      ),
    );
  }
  
  /// Tombol Simpan di Bawah
  Widget _buildBottomSaveButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Obx(() => FilledButton(
        onPressed: controller.isSaving.value ? null : controller.saveSettings,
        child: controller.isSaving.value
            ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
            : const Text("Simpan Pengaturan"),
      )),
    );
  }
}