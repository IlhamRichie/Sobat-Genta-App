class CommunityPostModel {
  final String id;
  final String userName;
  final String userRole; // Petani, Pakar, Investor
  final String userAvatarUrl;
  final String timeAgo;
  final String content;
  final String? postImageUrl;
  int likeCount;
  int commentCount;
  bool isLiked;

  CommunityPostModel({
    required this.id,
    required this.userName,
    required this.userRole,
    required this.userAvatarUrl,
    required this.timeAgo,
    required this.content,
    this.postImageUrl,
    this.likeCount = 0,
    this.commentCount = 0,
    this.isLiked = false,
  });
}