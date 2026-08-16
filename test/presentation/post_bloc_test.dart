import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:posthub_by_ai/domain/entities/post.dart';
import 'package:posthub_by_ai/domain/entities/user.dart';
import 'package:posthub_by_ai/domain/repositories/post_repository.dart';
import 'package:posthub_by_ai/presentation/features/post/bloc/post_bloc.dart';
import 'package:posthub_by_ai/presentation/features/post/bloc/post_event.dart';
import 'package:posthub_by_ai/presentation/features/post/bloc/post_state.dart';

class MockPostRepository extends Mock implements PostRepository {}

const _author = UserEntity(
  id: 1,
  name: 'Leanne Graham',
  username: 'Bret',
  email: 'Sincere@april.biz',
);

List<PostEntity> _makePosts(int count) => List.generate(
      count,
      (i) => PostEntity(
        id: i + 1,
        userId: 1,
        title: 'Post ${i + 1}',
        body: 'Body ${i + 1}',
        author: _author,
      ),
    );

void main() {
  late MockPostRepository repository;

  setUp(() {
    repository = MockPostRepository();
  });

  blocTest<PostBloc, PostState>(
    'emits loading then loaded states when PostFetched is added',
    build: () => PostBloc(repository: repository),
    setUp: () {
      when(() => repository.fetchPosts(page: 1, pageSize: 10))
          .thenAnswer((_) async => _makePosts(1));
    },
    act: (bloc) => bloc.add(const PostFetched()),
    expect: () => [
      isA<PostState>().having((s) => s.status, 'status', PostStatus.loading),
      isA<PostState>()
          .having((s) => s.status, 'status', PostStatus.success)
          .having((s) => s.posts, 'posts', _makePosts(1)),
    ],
  );

  blocTest<PostBloc, PostState>(
    'loads more posts and stops when hasMore is false',
    build: () => PostBloc(repository: repository),
    setUp: () {
      when(() => repository.fetchPosts(page: 1, pageSize: 10))
          .thenAnswer((_) async => _makePosts(10));
      when(() => repository.fetchPosts(page: 2, pageSize: 10))
          .thenAnswer((_) async => _makePosts(2));
    },
    act: (bloc) {
      bloc
        ..add(const PostFetched())
        ..add(const PostLoadMore())
        ..add(const PostLoadMore());
    },
    expect: () => [
      isA<PostState>().having((s) => s.status, 'status', PostStatus.loading),
      isA<PostState>()
          .having((s) => s.status, 'status', PostStatus.success)
          .having((s) => s.posts.length, 'posts length', 10)
          .having((s) => s.hasMore, 'hasMore', true),
      isA<PostState>().having((s) => s.isLoadingMore, 'isLoadingMore', true),
      isA<PostState>()
          .having((s) => s.isLoadingMore, 'isLoadingMore', false)
          .having((s) => s.posts.length, 'posts length', 12)
          .having((s) => s.hasMore, 'hasMore', false),
    ],
    verify: (_) {
      verify(() => repository.fetchPosts(page: 1, pageSize: 10)).called(1);
      verify(() => repository.fetchPosts(page: 2, pageSize: 10)).called(1);
      verifyNever(() => repository.fetchPosts(page: 3, pageSize: 10));
    },
  );
}
