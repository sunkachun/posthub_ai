import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'data/datasources/api_post_data_source.dart';
import 'data/repositories/api_post_repository_impl.dart';
import 'data/repositories/bookmark_repository_impl.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final preferences = await SharedPreferences.getInstance();
  final postRepository = ApiPostRepositoryImpl(
    dataSource: ApiPostDataSource(client: http.Client()),
  );
  final bookmarkRepository = BookmarkRepositoryImpl(
    preferences: preferences,
  );

  runApp(
    App(
      postRepository: postRepository,
      bookmarkRepository: bookmarkRepository,
    ),
  );
}
