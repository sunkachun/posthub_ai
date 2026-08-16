import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'app.dart';
import 'data/datasources/api_post_data_source.dart';
import 'data/repositories/api_post_repository_impl.dart';

void main() {
  final repository = ApiPostRepositoryImpl(
    dataSource: ApiPostDataSource(client: http.Client()),
  );
  runApp(App(repository: repository));
}
