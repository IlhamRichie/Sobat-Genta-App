import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/product_reviews_controller.dart';

class ProductReviewsView extends GetView<ProductReviewsController> {
  const ProductReviewsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ProductReviewsView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ProductReviewsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
