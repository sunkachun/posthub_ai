import 'package:equatable/equatable.dart';

import 'user.dart';

class PostEntity extends Equatable {
  const PostEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.author,
  });

  final int id;
  final int userId;
  final String title;
  final String body;
  final UserEntity author;

  @override
  List<Object?> get props => [id, userId, title, body, author];
}
