// lib/app/modules/manage_bank_accounts/controllers/manage_bank_accounts_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../data/models/bank_account_model.dart';
import '../../../../data/repositories/abstract/bank_account_repository.dart';

class ManageBankAccountsController extends GetxController {

  // --- DEPENDENCIES ---
  final IBankAccountRepository _bankRepo = Get.find<IBankAccountRepository>();

  // --- STATE ---
  final RxBool isLoading = true.obs;
  final RxList<BankAccountModel> accountList = <BankAccountModel>[].obs;
  final RxBool isProcessing = false.obs; // Loader untuk aksi C, U, D

  // --- Form Controller (untuk BottomSheet) ---
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController bankNameC = TextEditingController();
  final TextEditingController accNumberC = TextEditingController();
  final TextEditingController holderNameC = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchAccounts();
  }

  @override
  void onClose() {
    bankNameC.dispose();
    accNumberC.dispose();
    holderNameC.dispose();
    super.onClose();
  }

  /// (R) READ: Mengambil daftar rekening
  Future<void> fetchAccounts() async {
    isLoading.value = true;
    try {
      accountList.assignAll(await _bankRepo.getMyBankAccounts());
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat rekening bank: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// (C) CREATE: Menyimpan rekening baru dari bottom sheet
  Future<void> saveNewAccount() async {
    if (!formKey.currentState!.validate()) return;
    
    isProcessing.value = true;
    try {
      final data = {
        'bank_name': bankNameC.text,
        'account_number': accNumberC.text,
        'account_holder_name': holderNameC.text,
      };
      await _bankRepo.addBankAccount(data);
      Get.back(); // Tutup bottom sheet
      await fetchAccounts(); // Refresh list
      Get.back(result: 'updated'); // Kirim result 'updated' ke halaman Payout
      
    } catch (e) {
      Get.snackbar("Error", "Gagal menyimpan rekening: $e");
    } finally {
      isProcessing.value = false;
    }
  }

  /// (U) UPDATE: Menjadikan utama
  Future<void> setAsPrimary(String accountId) async {
    isProcessing.value = true; // Tampilkan loader umum
    try {
      await _bankRepo.setPrimaryAccount(accountId);
      await fetchAccounts(); // Refresh list
      Get.back(result: 'updated'); // Kirim result 'updated' ke halaman Payout
    } catch (e) {
      Get.snackbar("Error", "Gagal mengubah rekening utama: $e");
    } finally {
      isProcessing.value = false;
    }
  }

  /// (D) DELETE: Menghapus rekening
  Future<void> deleteAccount(String accountId) async {
    Get.defaultDialog(
      title: "Hapus Rekening",
      middleText: "Anda yakin ingin menghapus rekening bank ini?",
      textConfirm: "Ya, Hapus",
      textCancel: "Batal",
      onConfirm: () async {
        Get.back(); // Tutup dialog
        isProcessing.value = true; // Tampilkan loader
        try {
          await _bankRepo.deleteBankAccount(accountId);
          await fetchAccounts(); // Refresh list
          Get.back(result: 'updated'); // Kirim result 'updated' ke halaman Payout
          
          showTopSnackBar(
            Overlay.of(Get.context!),
            CustomSnackBar.success(message: "Rekening berhasil dihapus."),
          );
        } catch (e) {
          Get.snackbar("Error", "Gagal menghapus rekening: $e");
        } finally {
          isProcessing.value = false;
        }
      },
    );
  }

  /// Helper untuk membersihkan form
  void clearFormControllers() {
    bankNameC.clear();
    accNumberC.clear();
    holderNameC.clear();
  }
}