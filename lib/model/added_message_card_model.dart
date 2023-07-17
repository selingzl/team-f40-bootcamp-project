class AddedMessage {
  final String userId;
  final String bookName;
  final String message;
  final int likes;

  AddedMessage({
    required this.userId,
    required this.bookName,
    required this.message,
    required this.likes,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'bookName': bookName,
      'message': message,
      'likes': likes,
    };
  }
}
