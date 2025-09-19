// lib/app/modules/product_reviews/views/product_reviews_view.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../data/models/product_review_model.dart';
import '../controllers/product_reviews_controller.dart';

class ProductReviewsView extends GetView<ProductReviewsController> {
  const ProductReviewsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Semua Ulasan"),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (controller.reviewList.isEmpty) {
          return const Center(child: Text("Belum ada ulasan untuk produk ini."));
        }
        
        // Render ListView
        return ListView.builder(
          // 1. Hubungkan ScrollController
          controller: controller.scrollController,
          
          padding: const EdgeInsets.all(16),
          
          // 2. Item count + 1 untuk loading indicator
          itemCount: controller.reviewList.length + 1, 
          
          itemBuilder: (context, index) {
            // 3. Render loading indicator di item terakhir
            if (index == controller.reviewList.length) {
              return _buildLoader();
            }
            
            // Render item ulasan
            final review = controller.reviewList[index];
            return _buildReviewCard(review);
          },
        );
      }),
    );
  }

  /// Widget untuk menampilkan satu ulasan
  Widget _buildReviewCard(ProductReviewModel review) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300)
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(child: FaIcon(FontAwesomeIcons.solidUser)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(review.userName, style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        DateFormat('d MMMM yyyy', 'id_ID').format(review.timestamp),
                        style: Get.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                // Rating
                Row(
                  children: [
                    Text(review.rating.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 4),
                    const FaIcon(FontAwesomeIcons.solidStar, color: Colors.amber, size: 16),
                  ],
                ),
              ],
            ),
            const Divider(height: 24),
            Text(review.comment, style: Get.textTheme.bodyMedium?.copyWith(height: 1.4)),
          ],
        ),
      ),
    );
  }

  /// Widget loader di bagian bawah list
  Widget _buildLoader() {
    return Obx(() {
      if (controller.isLoadingMore.value) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 24.0),
            child: CircularProgressIndicator(),
          ),
        );
      }
      if (!controller.hasMoreData.value) {
         return const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 24.0),
            child: Text("Akhir dari daftar ulasan."),
          ),
        );
      }
      return const SizedBox.shrink(); // Tidak menampilkan apa-apa jika masih ada data tapi tidak sedang loading
    });
  }
}