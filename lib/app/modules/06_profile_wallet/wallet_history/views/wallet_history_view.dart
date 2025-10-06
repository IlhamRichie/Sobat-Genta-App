// lib/app/modules/wallet_history/views/wallet_history_view.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../data/models/wallet_transaction_model.dart';
import '../../../../theme/app_colors.dart';
import '../controllers/wallet_history_controller.dart';

class WalletHistoryView extends GetView<WalletHistoryController> {
  WalletHistoryView({Key? key}) : super(key: key);

  final rupiahFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: controller.fetchInitialHistory,
        child: Obx(() {
          if (controller.isLoading.value && controller.transactionList.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (controller.transactionList.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            controller: controller.scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            itemCount: controller.transactionList.length + 1, // +1 untuk loader
            itemBuilder: (context, index) {
              if (index == controller.transactionList.length) {
                return _buildLoader();
              }
              final trx = controller.transactionList[index];
              return _buildTransactionCard(trx); // Mengganti Tile dengan Card
            },
          );
        }),
      ),
    );
  }
  
  /// AppBar Kustom (Konsisten)
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      title: Text(
        "Riwayat Dompet",
        style: Get.textTheme.headlineSmall?.copyWith(
          color: AppColors.textDark,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: false,
    );
  }

  /// Tampilan Empty State yang Didesain Ulang
  Widget _buildEmptyState() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const FaIcon(FontAwesomeIcons.fileInvoiceDollar, size: 96, color: AppColors.greyLight),
              const SizedBox(height: 32),
              Text(
                "Belum Ada Riwayat Transaksi",
                style: Get.textTheme.titleLarge?.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                "Lakukan transaksi pertama Anda, dan riwayat akan muncul di sini.",
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

  /// Kartu untuk satu baris transaksi (Didesain Ulang)
  Widget _buildTransactionCard(WalletTransactionModel trx) {
    final bool isKredit = trx.type == TransactionType.KREDIT;
    final Color color = isKredit ? AppColors.primary : Colors.red.shade700;
    final IconData icon = isKredit ? FontAwesomeIcons.arrowUp : FontAwesomeIcons.arrowDown;
    final String sign = isKredit ? "+" : "-";

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: FaIcon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trx.description,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  trx.formattedDate,
                  style: Get.textTheme.bodySmall?.copyWith(color: AppColors.textLight),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Text(
            "$sign ${rupiahFormatter.format(trx.amount)}",
            style: Get.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
  
  /// Loader Pagination (Tidak ada perubahan)
  Widget _buildLoader() {
    return Obx(() {
      if (controller.isLoadingMore.value) {
        return const Center(child: Padding(padding: EdgeInsets.all(24.0), child: CircularProgressIndicator()));
      }
      if (!controller.hasMoreData.value) {
        return const Center(child: Padding(padding: EdgeInsets.all(24.0), child: Text("Akhir dari riwayat.")));
      }
      return const SizedBox.shrink();
    });
  }
}