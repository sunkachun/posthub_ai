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

void main() {
  late MockPostRepository repository;

  final posts = [
    const PostEntity(
      id: 1,
      userId: 1,
      title: 'First post',
      body: 'First body',
      author: UserEntity(
        id: 1,
        name: 'Leanne Graham',
        username: 'Bret',
        email: 'Sincere@april.biz',
      ),
    ),
  ];

  setUp(() {
    repository = MockPostRepository();
  });

  blocTest<PostBloc, PostState>(
    'emits loading then loaded states when PostFetched is added',
    build: () => PostBloc(repository: repository),
    setUp: () {
      when(() => repository.fetchPosts(page: 1, limit: 10))
          .thenAnswer((_) async => posts);
    },
    act: (bloc) => bloc.add(const PostFetched()),
    expect: () => [
      isA<PostState>().having((s) => s.status, 'status', PostStatus.loading),
      isA<PostState>()
          .having((s) => s.status, 'status', PostStatus.success)
          .having((s) => s.posts, 'posts', posts),
    ],
  );
}
