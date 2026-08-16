import '../../domain/entities/post.dart';
import '../../domain/entities/user.dart';

class PostDto {
  const PostDto({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  factory PostDto.fromJson(Map<String, dynamic> json) {
    return PostDto(
      id: json['id'] as int,
      userId: json['userId'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
    );
  }

  final int id;
  final int userId;
  final String title;
  final String body;

  PostEntity toEntity(UserEntity author) {
    return PostEntity(
      id: id,
      userId: userId,
      title: title,
      body: body,
      author: author,
    );
  }
}
