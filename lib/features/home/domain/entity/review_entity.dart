class ReviewEntity {
  final String userId;
  final String username;
  final String review;
  final DateTime date;

  ReviewEntity({
    required this.userId,
    required this.username,
    required this.review,
    required this.date,
  });
}
