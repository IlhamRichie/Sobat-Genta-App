// lib/app/modules/product_reviews/views/product_reviews_view.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../data/models/product_review_model.dart';
import '../../../../theme/app_colors.dart';
import '../controllers/product_reviews_controller.dart';

class ProductReviewsView extends GetView<ProductReviewsController> {
  const ProductReviewsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Obx(() {
        if (controller.isLoading.value && controller.reviewList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (controller.reviewList.isEmpty) {
          return _buildEmptyState();
        }
        
        return ListView.builder(
          controller: controller.scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          itemCount: controller.reviewList.length + 1,
          itemBuilder: (context, index) {
            if (index == controller.reviewList.length) {
              return _buildLoader();
            }
            
            final review = controller.reviewList[index];
            return _buildReviewCard(review);
          },
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
        "Semua Ulasan",
        style: Get.textTheme.headlineSmall?.copyWith(
          color: AppColors.textDark,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: false,
    );
  }

  /// Empty State yang Didesain Ulang
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FaIcon(FontAwesomeIcons.solidStar, size: 96, color: Colors.amber),
            const SizedBox(height: 32),
            Text(
              "Belum Ada Ulasan",
              style: Get.textTheme.titleLarge?.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              "Jadilah orang pertama yang memberikan ulasan untuk produk ini.",
              style: Get.textTheme.bodyMedium?.copyWith(
                fontSize: 16,
                color: AppColors.textLight,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Widget untuk menampilkan satu ulasan (Didesain Ulang)
  Widget _buildReviewCard(ProductReviewModel review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: AppColors.greyLight,
                child: FaIcon(FontAwesomeIcons.solidUser, color: Colors.grey),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      DateFormat('d MMMM yyyy', 'id_ID').format(review.timestamp),
                      style: Get.textTheme.bodySmall?.copyWith(color: AppColors.textLight),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Text(
                    review.rating.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 4),
                  const FaIcon(FontAwesomeIcons.solidStar, color: Colors.amber, size: 16),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            review.comment,
            style: Get.textTheme.bodyMedium?.copyWith(height: 1.5, color: AppColors.textDark),
          ),
        ],
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
            child: Text("Akhir dari daftar ulasan.", style: TextStyle(color: AppColors.textLight)),
          ),
        );
      }
      return const SizedBox.shrink();
    });
  }
}