import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/community_post_model.dart';

class CommunityController extends GetxController {
  
  // --- STATE ---
  final isLoading = true.obs;
  final posts = <CommunityPostModel>[].obs;
  
  // Input Controller buat bikin postingan baru
  final postInputC = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadPosts();
  }

  void loadPosts() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1)); // Simulasi API
    
    // Data Dummy Biar Rame
    posts.value = [
      CommunityPostModel(
        id: '1',
        userName: 'Pak Budi Santoso',
        userRole: 'Petani',
        userAvatarUrl: '', // Kosongin biar pake default icon
        timeAgo: '2 jam yang lalu',
        content: 'Alhamdulillah panen cabai hari ini melimpah. Ada yang tau harga pasar Magelang per kg berapa ya sekarang?',
        postImageUrl: 'https://images.unsplash.com/photo-1595855793915-2882ad3d5c89', // Gambar Cabai
        likeCount: 24,
        commentCount: 5,
      ),
      CommunityPostModel(
        id: '2',
        userName: 'Dr. Irwan, SP',
        userRole: 'Pakar',
        userAvatarUrl: '',
        timeAgo: '5 jam yang lalu',
        content: 'Waspada musim penghujan! Jangan lupa cek drainase lahan bawang merah kalian agar tidak busuk akar. #TipsBertani',
        likeCount: 156,
        commentCount: 42,
        isLiked: true,
      ),
      CommunityPostModel(
        id: '3',
        userName: 'Siti Aminah',
        userRole: 'Investor',
        userAvatarUrl: '',
        timeAgo: '1 hari yang lalu',
        content: 'Lagi cari proyek hidroponik melon di daerah Magelang Utara untuk didanai. Info dong gan!',
        likeCount: 8,
        commentCount: 12,
      ),
    ];
    
    isLoading.value = false;
  }

  void toggleLike(String id) {
    // Logic like local
    var index = posts.indexWhere((p) => p.id == id);
    if (index != -1) {
      var post = posts[index];
      if (post.isLiked) {
        post.likeCount--;
      } else {
        post.likeCount++;
      }
      post.isLiked = !post.isLiked;
      posts[index] = post; // Trigger UI update manual karena objek dalam list berubah
      posts.refresh();
    }
  }

  void createPost() {
    if (postInputC.text.isEmpty) return;
    
    Get.back(); // Tutup BottomSheet
    
    // Tambah postingan baru ke paling atas (Mock)
    posts.insert(0, CommunityPostModel(
      id: DateTime.now().toString(),
      userName: 'Saya (Anda)',
      userRole: 'Petani',
      userAvatarUrl: '',
      timeAgo: 'Baru saja',
      content: postInputC.text,
      likeCount: 0,
      commentCount: 0,
    ));
    
    postInputC.clear();
    Get.snackbar('Sukses', 'Postingan berhasil diterbitkan!', 
      backgroundColor: Colors.green, colorText: Colors.white, snackPosition: SnackPosition.TOP);
  }
}