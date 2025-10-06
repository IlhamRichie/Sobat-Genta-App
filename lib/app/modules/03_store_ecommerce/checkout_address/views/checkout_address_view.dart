// lib/app/modules/checkout_address/views/checkout_address_view.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../data/models/address_model.dart';
import '../../../../theme/app_colors.dart';
import '../controllers/checkout_address_controller.dart';

class CheckoutAddressView extends GetView<CheckoutAddressController> {
  const CheckoutAddressView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      bottomNavigationBar: _buildBottomConfirmBar(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          children: [
            ...controller.addressList
                .map((addr) => _buildAddressCard(addr))
                .toList(),
            const SizedBox(height: 16),
            _buildAddAddressButton(context),
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
      title: Text(
        "Pilih Alamat",
        style: Get.textTheme.headlineSmall?.copyWith(
          color: AppColors.textDark,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: false,
    );
  }

  /// Kartu untuk satu alamat (Didesain Ulang)
  Widget _buildAddressCard(AddressModel address) {
    return Obx(() {
      final isSelected =
          controller.selectedAddressId.value == address.addressId;
      return GestureDetector(
        onTap: () => controller.selectAddress(address.addressId),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color:
                isSelected ? AppColors.primary.withOpacity(0.1) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.greyLight,
              width: 1.5,
            ),
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${address.label} (${address.recipientName})",
                    style: Get.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color:
                          isSelected ? AppColors.primary : AppColors.textDark,
                    ),
                  ),
                  FaIcon(
                    isSelected
                        ? FontAwesomeIcons.solidCircleDot
                        : FontAwesomeIcons.circle,
                    size: 20,
                    color: isSelected ? AppColors.primary : AppColors.textLight,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                "${address.fullAddress}, ${address.city}, ${address.postalCode}",
                style: Get.textTheme.bodyMedium
                    ?.copyWith(color: AppColors.textDark),
              ),
              const SizedBox(height: 4),
              Text(
                address.phoneNumber,
                style: Get.textTheme.bodyMedium
                    ?.copyWith(color: AppColors.textLight),
              ),
            ],
          ),
        ),
      );
    });
  }

  /// Tombol "Tambah Alamat" (Didesain Ulang)
  Widget _buildAddAddressButton(BuildContext context) {
    return TextButton.icon(
      onPressed: () => _showAddAddressSheet(context),
      icon: const FaIcon(FontAwesomeIcons.plus,
          size: 16, color: AppColors.primary),
      label: const Text(
        "Tambah Alamat Baru",
        style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        side: const BorderSide(color: AppColors.primary),
      ),
    );
  }

  /// Bottom Sheet Formulir (Didesain Ulang)
  void _showAddAddressSheet(BuildContext context) {
    controller.clearForm();

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Tambahkan Alamat Baru",
                  style: Get.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                _buildTextFormField(
                  controller: controller.labelC,
                  label: 'Label Alamat (cth: Rumah)',
                  hint: 'Contoh: Rumah, Kantor',
                  icon: FontAwesomeIcons.solidBookmark,
                ),
                const SizedBox(height: 16),
                _buildTextFormField(
                  controller: controller.nameC,
                  label: 'Nama Penerima',
                  icon: FontAwesomeIcons.solidUser,
                ),
                const SizedBox(height: 16),
                _buildTextFormField(
                  controller: controller.phoneC,
                  label: 'Nomor Telepon',
                  icon: FontAwesomeIcons.phone,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                _buildTextFormField(
                  controller: controller.addressC,
                  label: 'Alamat Lengkap',
                  icon: FontAwesomeIcons.locationDot,
                ),
                const SizedBox(height: 16),
                Row(children: [
                  Expanded(
                    child: _buildTextFormField(
                      controller: controller.cityC,
                      label: 'Kota / Kabupaten',
                      icon: FontAwesomeIcons.city,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextFormField(
                      controller: controller.postalC,
                      label: 'Kode Pos',
                      icon: FontAwesomeIcons.mailchimp,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ]),
                const SizedBox(height: 32),
                Obx(() => FilledButton(
                      onPressed: controller.isSavingNewAddress.value
                          ? null
                          : controller.saveNewAddress,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        elevation: 4,
                      ),
                      child: controller.isSavingNewAddress.value
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2))
                          : const Text("Simpan Alamat",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                    )),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  /// Tombol Konfirmasi di Bawah (Didesain Ulang)
  Widget _buildBottomConfirmBar() {
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
            onPressed: controller.selectedAddressId.value != null
                ? controller.confirmAndContinue
                : null,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 4,
            ),
            child: const Text("Lanjut ke Pembayaran",
                style: TextStyle(fontWeight: FontWeight.bold)),
          )),
    );
  }

  /// Helper untuk TextFormField (Baru)
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: FaIcon(icon, size: 20, color: AppColors.textLight),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.primary, width: 2)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.greyLight)),
      ),
      validator: (v) => (v == null || v.isEmpty) ? "Wajib diisi" : null,
    );
  }
}
