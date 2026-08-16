import '../../domain/entities/comment.dart';
import '../../domain/entities/post.dart';
import '../../domain/repositories/post_repository.dart';
import '../datasources/api_post_data_source.dart';

class ApiPostRepositoryImpl implements PostRepository {
  ApiPostRepositoryImpl({ApiPostDataSource? dataSource})
      : _dataSource = dataSource ?? ApiPostDataSource();

  final ApiPostDataSource _dataSource;

  @override
  Future<List<PostEntity>> fetchPosts({
    int page = 1,
    int pageSize = 10,
  }) async {
    final postDtos =
        await _dataSource.fetchPosts(page: page, pageSize: pageSize);
    if (postDtos.isEmpty) return const [];

    final userIds = postDtos.map((p) => p.userId).toSet();
    final userDtos = await Future.wait(userIds.map(_dataSource.fetchUser));
    final usersById = {for (final u in userDtos) u.id: u.toEntity()};

    return postDtos.map((p) => p.toEntity(usersById[p.userId]!)).toList();
  }

  @override
  Future<PostEntity> fetchPostDetail(int id) async {
    final postDto = await _dataSource.fetchPost(id);
    final userDto = await _dataSource.fetchUser(postDto.userId);
    return postDto.toEntity(userDto.toEntity());
  }

  @override
  Future<List<CommentEntity>> fetchComments(int postId) async {
    final commentDtos = await _dataSource.fetchComments(postId);
    return commentDtos.map((c) => c.toEntity()).toList();
  }
}
