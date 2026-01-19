import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../data/models/community_post_model.dart';
import '../../../theme/app_colors.dart'; // Pastikan path ini bener
import '../controllers/community_controller.dart';

class CommunityView extends GetView<CommunityController> {
  const CommunityView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8), // Background Abu Josjis
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          "Komunitas Tani",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {}, // Fitur search (Mock)
            icon: const FaIcon(FontAwesomeIcons.magnifyingGlass, size: 20, color: Colors.black),
          ),
          IconButton(
            onPressed: () {}, // Fitur notifikasi (Mock)
            icon: const FaIcon(FontAwesomeIcons.bell, size: 20, color: Colors.black),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreatePostSheet(context),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.edit),
        label: const Text("Tulis"),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: controller.posts.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final post = controller.posts[index];
            return _buildPostCard(post);
          },
        );
      }),
    );
  }

  /// Card Postingan
  Widget _buildPostCard(CommunityPostModel post) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header (User Info)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.greyLight,
                  child: const FaIcon(FontAwesomeIcons.user, size: 18, color: Colors.grey),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            post.userName,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const SizedBox(width: 6),
                          // Badge Role
                          _buildRoleBadge(post.userRole),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        post.timeAgo,
                        style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.more_horiz, color: Colors.grey),
              ],
            ),
          ),

          // 2. Konten Teks
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              post.content,
              style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.black87),
            ),
          ),
          const SizedBox(height: 12),

          // 3. Gambar Postingan (Jika Ada)
          if (post.postImageUrl != null && post.postImageUrl!.startsWith('http'))
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                image: DecorationImage(
                  image: NetworkImage(post.postImageUrl!),
                  fit: BoxFit.cover,
                ),
              ),
            ),

          // 4. Action Buttons (Like & Comment)
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                // Tombol Like
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => controller.toggleLike(post.id),
                    icon: Icon(
                      post.isLiked ? Icons.favorite : Icons.favorite_border,
                      color: post.isLiked ? Colors.red : Colors.grey,
                      size: 20,
                    ),
                    label: Text(
                      "${post.likeCount} Suka",
                      style: TextStyle(color: post.isLiked ? Colors.red : Colors.grey),
                    ),
                  ),
                ),
                // Tombol Komentar
                Expanded(
                  child: TextButton.icon(
                    onPressed: () {},
                    icon: const FaIcon(FontAwesomeIcons.comment, size: 18, color: Colors.grey),
                    label: Text(
                      "${post.commentCount} Komentar",
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                // Tombol Share
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.share_outlined, color: Colors.grey, size: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Badge Role User (Warna Warni)
  Widget _buildRoleBadge(String role) {
    Color bgColor;
    Color textColor;

    if (role == 'Pakar') {
      bgColor = Colors.blue.shade50;
      textColor = Colors.blue.shade700;
    } else if (role == 'Investor') {
      bgColor = Colors.orange.shade50;
      textColor = Colors.orange.shade700;
    } else {
      // Petani
      bgColor = Colors.green.shade50;
      textColor = Colors.green.shade700;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        role,
        style: TextStyle(color: textColor, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  /// Bottom Sheet buat bikin postingan baru
  void _showCreatePostSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Buat Postingan Baru", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 16),
            TextField(
              controller: controller.postInputC,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Apa yang ingin Anda diskusikan?",
                filled: true,
                fillColor: const Color(0xFFF5F6F8),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: controller.createPost,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Posting Sekarang"),
              ),
            ),
            // Space keyboard
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}