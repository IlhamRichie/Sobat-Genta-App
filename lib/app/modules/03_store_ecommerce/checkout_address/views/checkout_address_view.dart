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
      appBar: AppBar(
        title: const Text("Pilih Alamat Pengiriman"),
      ),
      bottomNavigationBar: _buildBottomConfirmBar(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Render list alamat yang ada
            ...controller.addressList.map((addr) => _buildAddressCard(addr)),
            
            // Tombol Tambah Alamat Baru
            const SizedBox(height: 16),
            _buildAddAddressButton(context),
          ],
        );
      }),
    );
  }

  /// Kartu untuk satu alamat (menggunakan Radio)
  Widget _buildAddressCard(AddressModel address) {
    return Obx(() => Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: (controller.selectedAddressId.value == address.addressId)
              ? AppColors.primary
              : Colors.grey.shade300,
          width: 2,
        ),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: RadioListTile<String>(
        value: address.addressId,
        groupValue: controller.selectedAddressId.value,
        onChanged: (val) => controller.selectAddress(val!),
        activeColor: AppColors.primary,
        title: Text("${address.label} (${address.recipientName})", style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          "${address.fullAddress}, ${address.city}, ${address.postalCode}\n${address.phoneNumber}",
          style: Get.textTheme.bodyMedium,
        ),
        isThreeLine: true,
      ),
    ));
  }

  /// Tombol "Tambah Alamat"
  Widget _buildAddAddressButton(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () => _showAddAddressSheet(context),
      icon: const FaIcon(FontAwesomeIcons.plus, size: 16),
      label: const Text("Tambah Alamat Baru"),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }
  
  /// Bottom Sheet Formulir (Inline Form)
  void _showAddAddressSheet(BuildContext context) {
    // Reset field
    controller.nameC.clear();
    controller.phoneC.clear();
    controller.addressC.clear();
    controller.cityC.clear();
    controller.postalC.clear();
    
    Get.bottomSheet(
      Container(
        height: Get.height * 0.8,
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("Alamat Baru", style: Get.textTheme.titleLarge),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    TextFormField(
                      controller: controller.labelC,
                      decoration: _inputDecoration('Label Alamat (cth: Rumah)', null),
                      validator: (v) => (v == null || v.isEmpty) ? "Wajib diisi" : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: controller.nameC,
                      decoration: _inputDecoration('Nama Penerima', null),
                       validator: (v) => (v == null || v.isEmpty) ? "Wajib diisi" : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: controller.phoneC,
                      decoration: _inputDecoration('Nomor Telepon', null),
                      keyboardType: TextInputType.phone,
                       validator: (v) => (v == null || v.isEmpty) ? "Wajib diisi" : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: controller.addressC,
                      decoration: _inputDecoration('Alamat Lengkap (Jalan, RT/RW)', null),
                       validator: (v) => (v == null || v.isEmpty) ? "Wajib diisi" : null,
                    ),
                    const SizedBox(height: 16),
                    Row(children: [
                      Expanded(
                        child: TextFormField(
                          controller: controller.cityC,
                          decoration: _inputDecoration('Kota / Kabupaten', null),
                          validator: (v) => (v == null || v.isEmpty) ? "Wajib diisi" : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: controller.postalC,
                          decoration: _inputDecoration('Kode Pos', null),
                          keyboardType: TextInputType.number,
                          validator: (v) => (v == null || v.isEmpty) ? "Wajib diisi" : null,
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
              // Tombol Simpan di dalam Sheet
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Obx(() => FilledButton(
                  onPressed: controller.isSavingNewAddress.value ? null : controller.saveNewAddress,
                  child: controller.isSavingNewAddress.value 
                      ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white))
                      : const Text("Simpan Alamat"),
                )),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true, // Wajib agar BottomSheet bisa full height
    );
  }

  InputDecoration _inputDecoration(String label, IconData? icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: icon != null ? FaIcon(icon, size: 20) : null,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  /// Tombol Konfirmasi di Bawah
  Widget _buildBottomConfirmBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: FilledButton(
        onPressed: controller.confirmAndContinue,
        child: const Text("Lanjut ke Pembayaran"),
      ),
    );
  }
}