// lib/app/modules/wallet_history/controllers/wallet_history_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/models/wallet_transaction_model.dart';
import '../../../../data/repositories/abstract/wallet_repository.dart';

class WalletHistoryController extends GetxController {

  // --- DEPENDENCIES ---
  final IWalletRepository _walletRepo = Get.find<IWalletRepository>();

  // --- STATE ---
  final RxBool isLoading = true.obs;
  final RxList<WalletTransactionModel> transactionList = <WalletTransactionModel>[].obs;

  // --- PAGINATION STATE ---
  final ScrollController scrollController = ScrollController();
  final RxBool isLoadingMore = false.obs;
  final RxInt currentPage = 1.obs;
  final RxBool hasMoreData = true.obs;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_scrollListener);
    fetchInitialHistory();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  /// 1. Ambil data halaman pertama
  Future<void> fetchInitialHistory() async {
    isLoading.value = true;
    hasMoreData.value = true;
    currentPage.value = 1;
    transactionList.clear();
    
    try {
      final transactions = await _walletRepo.getWalletHistory(1);
      if (transactions.isEmpty) {
        hasMoreData.value = false;
      }
      transactionList.assignAll(transactions);
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat riwayat transaksi: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// 2. Listener scroll
  void _scrollListener() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent &&
        !isLoadingMore.value &&
        hasMoreData.value) {
      loadMoreHistory();
    }
  }

  /// 3. Ambil data halaman berikutnya
  Future<void> loadMoreHistory() async {
    isLoadingMore.value = true;
    currentPage.value++;

    try {
      final newTransactions = await _walletRepo.getWalletHistory(currentPage.value);
      if (newTransactions.isEmpty) {
        hasMoreData.value = false;
      } else {
        transactionList.addAll(newTransactions);
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat data tambahan: $e");
    } finally {
      isLoadingMore.value = false;
    }
  }
}