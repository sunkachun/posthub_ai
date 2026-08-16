import 'dart:convert';

import '../../domain/entities/comment.dart';
import '../../domain/entities/post.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/post_repository.dart';
import '../datasources/mock_post_data_source.dart';
import '../models/comment_dto.dart';
import '../models/post_dto.dart';
import '../models/user_dto.dart';

class MockPostRepositoryImpl implements PostRepository {
  MockPostRepositoryImpl({MockPostDataSource? dataSource})
      : _dataSource = dataSource ?? MockPostDataSource();

  final MockPostDataSource _dataSource;

  @override
  Future<List<PostEntity>> fetchPosts({int page = 1, int pageSize = 10}) async {
    final allPosts = _parsePosts(await _dataSource.fetchPostsJson());

    final start = (page - 1) * pageSize;
    final pagePosts = allPosts.skip(start).take(pageSize).toList();
    if (pagePosts.isEmpty) return const [];

    return _attachAuthors(pagePosts);
  }

  @override
  Future<PostEntity> fetchPostDetail(int id) async {
    final allPosts = _parsePosts(await _dataSource.fetchPostsJson());
    final post = allPosts.firstWhere(
      (p) => p.id == id,
      orElse: () => throw StateError('Post with id $id not found'),
    );

    final usersById = await _fetchUsersByIds({post.userId});
    return post.toEntity(usersById[post.userId]!);
  }

  @override
  Future<List<CommentEntity>> fetchComments(int postId) async {
    final json = await _dataSource.fetchCommentsJson(postId);
    final list = jsonDecode(json) as List<dynamic>;
    return list
        .map((e) => CommentDto.fromJson(e as Map<String, dynamic>).toEntity())
        .toList();
  }

  /// Handles the N+1 problem: aggregate the unique `userId`s of a page of
  /// posts, fetch the corresponding users concurrently, then map each user
  /// onto its post before returning the list.
  Future<List<PostEntity>> _attachAuthors(List<PostDto> posts) async {
    final userIds = posts.map((p) => p.userId).toSet();
    final usersById = await _fetchUsersByIds(userIds);
    return posts.map((p) => p.toEntity(usersById[p.userId]!)).toList();
  }

  Future<Map<int, UserEntity>> _fetchUsersByIds(Set<int> userIds) async {
    final jsonStrings =
        await Future.wait(userIds.map((id) => _dataSource.fetchUserJson(id)));
    final users = jsonStrings.map(_parseUser).toList();
    return {for (final user in users) user.id: user};
  }

  List<PostDto> _parsePosts(String json) {
    final list = jsonDecode(json) as List<dynamic>;
    return list
        .map((e) => PostDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  UserEntity _parseUser(String json) {
    return UserDto.fromJson(jsonDecode(json) as Map<String, dynamic>)
        .toEntity();
  }
}
