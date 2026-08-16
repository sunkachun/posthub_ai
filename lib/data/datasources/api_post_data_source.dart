import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/errors/server_exception.dart';
import '../models/comment_dto.dart';
import '../models/post_dto.dart';
import '../models/user_dto.dart';

class ApiPostDataSource {
  ApiPostDataSource({http.Client? client}) : _client = client ?? http.Client();

  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';

  final http.Client _client;

  Future<List<PostDto>> fetchPosts({int page = 1, int pageSize = 10}) async {
    final uri = Uri.parse('$_baseUrl/posts?_page=$page&_limit=$pageSize');
    final response = await _client.get(uri);
    _ensureSuccess(response.statusCode, 'posts');
    final list = jsonDecode(response.body) as List<dynamic>;
    return list
        .map((e) => PostDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<PostDto> fetchPost(int id) async {
    final uri = Uri.parse('$_baseUrl/posts/$id');
    final response = await _client.get(uri);
    _ensureSuccess(response.statusCode, 'post $id');
    return PostDto.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<UserDto> fetchUser(int userId) async {
    final uri = Uri.parse('$_baseUrl/users/$userId');
    final response = await _client.get(uri);
    _ensureSuccess(response.statusCode, 'user $userId');
    return UserDto.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<List<CommentDto>> fetchComments(int postId) async {
    final uri = Uri.parse('$_baseUrl/posts/$postId/comments');
    final response = await _client.get(uri);
    _ensureSuccess(response.statusCode, 'comments for post $postId');
    final list = jsonDecode(response.body) as List<dynamic>;
    return list
        .map((e) => CommentDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  void _ensureSuccess(int statusCode, String resource) {
    if (statusCode != 200) {
      throw ServerException('Failed to load $resource (status $statusCode)');
    }
  }
}
