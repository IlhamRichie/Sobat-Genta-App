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
      appBar: AppBar(
        title: const Text("Riwayat Dompet"),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (controller.transactionList.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(FontAwesomeIcons.fileInvoiceDollar, size: 80, color: AppColors.greyLight),
                SizedBox(height: 16),
                Text("Belum ada riwayat transaksi."),
              ],
            ),
          );
        }

        // Render ListView Pagination
        return RefreshIndicator(
          onRefresh: controller.fetchInitialHistory,
          child: ListView.builder(
            controller: controller.scrollController,
            itemCount: controller.transactionList.length + 1, // +1 untuk loader
            itemBuilder: (context, index) {
              if (index == controller.transactionList.length) {
                return _buildLoader(); // Loader di akhir list
              }
              final trx = controller.transactionList[index];
              return _buildTransactionTile(trx);
            },
          ),
        );
      }),
    );
  }

  /// Tile untuk satu baris transaksi
  Widget _buildTransactionTile(WalletTransactionModel trx) {
    final bool isKredit = trx.type == TransactionType.KREDIT;
    final Color color = isKredit ? Colors.green.shade700 : Colors.red.shade700;
    final IconData icon = isKredit ? FontAwesomeIcons.arrowDown : FontAwesomeIcons.arrowUp;
    final String sign = isKredit ? "+" : "-";

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.1),
        child: FaIcon(icon, size: 16, color: color),
      ),
      title: Text(
        trx.description,
        style: const TextStyle(fontWeight: FontWeight.w600),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(trx.formattedDate, style: Get.textTheme.bodySmall),
      trailing: Text(
        "$sign ${rupiahFormatter.format(trx.amount)}",
        style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 16),
      ),
    );
  }
  
  /// Loader Pagination (Identik dengan modul lain)
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