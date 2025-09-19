// lib/app/modules/checkout_address/controllers/checkout_address_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/models/address_model.dart';
import '../../../../data/repositories/abstract/address_repository.dart';
import '../../../../routes/app_pages.dart';

class CheckoutAddressController extends GetxController {
  // --- DEPENDENCIES ---
  final IAddressRepository _addressRepo = Get.find<IAddressRepository>();

  // --- STATE ---
  final RxBool isLoading = true.obs;
  final RxList<AddressModel> addressList = <AddressModel>[].obs;

  // State untuk melacak ID alamat yang dipilih di UI (radio button)
  final RxString selectedAddressId = ''.obs;

  // Controller untuk form tambah alamat baru (digunakan di bottom sheet)
  final formKey = GlobalKey<FormState>();
  final labelC = TextEditingController(text: "Rumah");
  final nameC = TextEditingController();
  final phoneC = TextEditingController();
  final addressC = TextEditingController();
  final cityC = TextEditingController();
  final postalC = TextEditingController();
  final RxBool isSavingNewAddress = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAddresses();
  }

  @override
  void onClose() {
    labelC.dispose();
    nameC.dispose();
    phoneC.dispose();
    addressC.dispose();
    cityC.dispose();
    postalC.dispose();
    super.onClose();
  }

  /// 1. Mengambil semua alamat
  Future<void> fetchAddresses() async {
    isLoading.value = true;
    try {
      final addresses = await _addressRepo.getMyAddresses();
      addressList.assignAll(addresses);

      // Otomatis pilih alamat 'isPrimary' jika ada
      AddressModel? defaultSelectedAddress;

      // 1. Coba cari alamat yang ditandai sebagai 'primary'
      final primaryList = addresses.where((addr) => addr.isPrimary).toList();

      if (primaryList.isNotEmpty) {
      // 1a. Jika ditemukan, gunakan itu.
        defaultSelectedAddress = primaryList.first;
      }
      // 2. Jika tidak ada primary, tapi list alamat tidak kosong,
      //    pilih saja alamat PERTAMA di daftar sebagai default.
      else if (addresses.isNotEmpty) {
        defaultSelectedAddress = addresses.first;
      }
      // 3. Jika list alamat kosong, defaultSelectedAddress akan tetap 'null'.

      // Set state reaktif hanya jika kita menemukan alamat
      if (defaultSelectedAddress != null) {
        selectedAddressId.value = defaultSelectedAddress.addressId;
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat alamat: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// 2. Aksi saat user memilih alamat lain di list
  void selectAddress(String addressId) {
    selectedAddressId.value = addressId;
  }

  /// 3. Aksi utama: Konfirmasi & Lanjut ke Pembayaran
  Future<void> confirmAndContinue() async {
    if (selectedAddressId.value.isEmpty) {
      Get.snackbar(
          "Pilih Alamat", "Anda harus memilih satu alamat pengiriman.");
      return;
    }

    // (Opsional tapi Best Practice): Kirim pilihan terakhir ke backend
    await _addressRepo.setSelectedAddress(selectedAddressId.value);

    // Kirim data alamat yang dipilih ke halaman berikutnya
    final selectedAddress =
        addressList.firstWhere((a) => a.addressId == selectedAddressId.value);

    Get.toNamed(Routes.CHECKOUT_PAYMENT,
        arguments: {'selected_address': selectedAddress});
  }

  /// 4. Menyimpan alamat baru dari bottom sheet
  Future<void> saveNewAddress() async {
    if (!formKey.currentState!.validate()) return;

    isSavingNewAddress.value = true;
    try {
      final data = {
        "label": labelC.text,
        "recipient_name": nameC.text,
        "phone_number": phoneC.text,
        "address_detail": addressC.text,
        "city": cityC.text,
        "postal_code": postalC.text,
      };

      await _addressRepo.addAddress(data);
      Get.back(); // Tutup bottom sheet
      await fetchAddresses(); // Muat ulang list alamat
    } catch (e) {
      Get.snackbar("Error", "Gagal menyimpan alamat: $e");
    } finally {
      isSavingNewAddress.value = false;
    }
  }
}
