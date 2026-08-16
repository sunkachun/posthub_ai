import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:posthub_by_ai/data/datasources/mock_post_data_source.dart';
import 'package:posthub_by_ai/data/repositories/mock_post_repository_impl.dart';
import 'package:posthub_by_ai/domain/entities/post.dart';

class MockDataSource extends Mock implements MockPostDataSource {}

void main() {
  late MockDataSource dataSource;
  late MockPostRepositoryImpl repository;

  const postsJson = '''
[
  {"userId": 1, "id": 1, "title": "First post", "body": "First body"},
  {"userId": 1, "id": 2, "title": "Second post", "body": "Second body"},
  {"userId": 2, "id": 3, "title": "Third post", "body": "Third body"}
]
''';

  const user1Json =
      '{"id": 1, "name": "Leanne Graham", "username": "Bret", '
      '"email": "Sincere@april.biz"}';
  const user2Json =
      '{"id": 2, "name": "Ervin Howell", "username": "Antonette", '
      '"email": "Shanna@melissa.tv"}';

  setUp(() {
    dataSource = MockDataSource();
    repository = MockPostRepositoryImpl(dataSource: dataSource);
  });

  group('fetchPosts', () {
    test('parses posts and maps authors via N+1 aggregation', () async {
      when(() => dataSource.fetchPostsJson()).thenAnswer((_) async => postsJson);
      when(() => dataSource.fetchUserJson(1)).thenAnswer((_) async => user1Json);
      when(() => dataSource.fetchUserJson(2)).thenAnswer((_) async => user2Json);

      final List<PostEntity> posts = await repository.fetchPosts();

      expect(posts, hasLength(3));

      expect(posts[0].id, 1);
      expect(posts[0].title, 'First post');
      expect(posts[0].author.id, 1);
      expect(posts[0].author.name, 'Leanne Graham');
      expect(posts[0].author.username, 'Bret');
      expect(posts[0].author.email, 'Sincere@april.biz');

      expect(posts[1].id, 2);
      expect(posts[1].author.id, 1);

      expect(posts[2].id, 3);
      expect(posts[2].author.id, 2);
      expect(posts[2].author.name, 'Ervin Howell');

      // N+1 dedup: userId 1 appears on two posts but is fetched only once.
      verify(() => dataSource.fetchUserJson(1)).called(1);
      verify(() => dataSource.fetchUserJson(2)).called(1);
    });

    test('returns empty list when data source returns no posts', () async {
      when(() => dataSource.fetchPostsJson()).thenAnswer((_) async => '[]');

      final List<PostEntity> posts = await repository.fetchPosts();

      expect(posts, isEmpty);
      verifyNever(() => dataSource.fetchUserJson(any()));
    });
  });
}
