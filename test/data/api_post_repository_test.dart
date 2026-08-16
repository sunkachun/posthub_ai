import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:posthub_by_ai/core/errors/server_exception.dart';
import 'package:posthub_by_ai/data/datasources/api_post_data_source.dart';
import 'package:posthub_by_ai/data/repositories/api_post_repository_impl.dart';

void main() {
  group('ApiPostRepositoryImpl', () {
    test('resolves N+1 by fetching unique authors and mapping them', () async {
      final client = MockClient((request) async {
        final path = request.url.path;
        if (path == '/posts') {
          return http.Response(
            jsonEncode([
              {'userId': 1, 'id': 1, 'title': 'First', 'body': 'Body 1'},
              {'userId': 1, 'id': 2, 'title': 'Second', 'body': 'Body 2'},
              {'userId': 2, 'id': 3, 'title': 'Third', 'body': 'Body 3'},
            ]),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        if (path == '/users/1') {
          return http.Response(
            jsonEncode({
              'id': 1,
              'name': 'Leanne Graham',
              'username': 'Bret',
              'email': 'Sincere@april.biz',
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        if (path == '/users/2') {
          return http.Response(
            jsonEncode({
              'id': 2,
              'name': 'Ervin Howell',
              'username': 'Antonette',
              'email': 'Shanna@melissa.tv',
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        return http.Response('Not found', 404);
      });

      final repository = ApiPostRepositoryImpl(
        dataSource: ApiPostDataSource(client: client),
      );

      final posts = await repository.fetchPosts();

      expect(posts, hasLength(3));
      expect(posts[0].author.name, 'Leanne Graham');
      expect(posts[1].author.name, 'Leanne Graham');
      expect(posts[2].author.name, 'Ervin Howell');
      expect(posts[0].imageUrl, 'https://picsum.photos/seed/1/200/150');
    });

    test('throws ServerException on a non-200 response', () async {
      final client = MockClient((_) async => http.Response('server error', 500));
      final dataSource = ApiPostDataSource(client: client);

      await expectLater(
        dataSource.fetchPosts(),
        throwsA(isA<ServerException>()),
      );
    });
  });
}
