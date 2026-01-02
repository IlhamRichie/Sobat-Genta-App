// lib/app/modules/expert_availability_settings/views/expert_availability_settings_view.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Obx(() {
        if (controller.isLoadingPage.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 100), // Padding bawah ekstra untuk tombol sticky
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFeeSection(),
                  const SizedBox(height: 32),
                  _buildScheduleSection(),
                ],
              ),
            ),
            
            // Sticky Bottom Button
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildBottomSaveButton(),
            ),
          ],
        );
      }),
    );
  }

  /// AppBar Kustom
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const FaIcon(FontAwesomeIcons.arrowLeft, color: AppColors.textDark),
        onPressed: () => Get.back(),
      ),
      title: Text(
        "Atur Jadwal & Tarif",
        style: Get.textTheme.headlineSmall?.copyWith(
          color: AppColors.textDark,
          fontWeight: FontWeight.w800,
          fontSize: 20,
        ),
      ),
    );
  }

  /// Bagian 1: Pengaturan Tarif (Clean Card)
  Widget _buildFeeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Tarif Konsultasi",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
        ),
        const SizedBox(height: 8),
        const Text(
          "Tentukan biaya jasa Anda per sesi konsultasi.",
          style: TextStyle(color: AppColors.textLight, fontSize: 14),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller.feeC,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.primary),
            decoration: InputDecoration(
              prefixText: "Rp ",
              prefixStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.textDark),
              labelText: "Nominal Tarif",
              labelStyle: const TextStyle(color: AppColors.textLight),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            ),
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
        const Text(
          "Jadwal Praktik",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
        ),
        const SizedBox(height: 8),
        const Text(
          "Pilih hari dan atur jam operasional Anda.",
          style: TextStyle(color: AppColors.textLight, fontSize: 14),
        ),
        const SizedBox(height: 16),
        Obx(() => ListView.separated(
          itemCount: controller.scheduleList.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (ctx, i) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final slot = controller.scheduleList[index];
            return _buildDayRow(context, slot, index);
          },
        )),
      ],
    );
  }

  /// Kartu Hari (Expandable)
  Widget _buildDayRow(BuildContext context, AvailabilitySlot slot, int index) {
    return Obx(() {
      bool isActive = slot.isActive.value;
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive ? AppColors.primary : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isActive ? AppColors.primary.withOpacity(0.1) : Colors.grey.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header Hari (Toggle)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    slot.dayName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isActive ? AppColors.textDark : AppColors.textLight,
                    ),
                  ),
                  Switch.adaptive(
                    value: isActive,
                    onChanged: (value) => controller.toggleDayActive(index, value),
                    activeColor: AppColors.primary,
                  ),
                ],
              ),
            ),
            
            // Body Jam (Expandable)
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              child: isActive 
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Column(
                      children: [
                        const Divider(height: 1, color: AppColors.greyLight),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTimePicker(
                                context, 
                                "Mulai", 
                                slot.startTime.value, 
                                () => controller.selectTime(context, index, true),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Icon(Icons.arrow_forward, color: AppColors.textLight, size: 16),
                            ),
                            Expanded(
                              child: _buildTimePicker(
                                context, 
                                "Selesai", 
                                slot.endTime.value, 
                                () => controller.selectTime(context, index, false),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ) 
                : const SizedBox.shrink(),
            ),
          ],
        ),
      );
    });
  }

  /// Tombol Pilih Jam (Modern)
  Widget _buildTimePicker(BuildContext context, String label, String time, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.greyLight.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.greyLight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textLight)),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  time,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDark),
                ),
                const FaIcon(FontAwesomeIcons.clock, size: 14, color: AppColors.primary),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  /// Sticky Save Button
  Widget _buildBottomSaveButton() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 54,
          child: Obx(() => ElevatedButton(
            onPressed: controller.isSaving.value ? null : controller.saveSettings,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              shadowColor: AppColors.primary.withOpacity(0.4),
            ),
            child: controller.isSaving.value
                ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Text("Simpan Perubahan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          )),
        ),
      ),
    );
  }
}