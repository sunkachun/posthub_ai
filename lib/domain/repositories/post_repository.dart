import '../entities/comment.dart';
import '../entities/post.dart';

abstract class PostRepository {
  Future<List<PostEntity>> fetchPosts({int page = 1, int limit = 10});

  Future<PostEntity> fetchPostDetail(int id);

  Future<List<CommentEntity>> fetchComments(int postId);
}
