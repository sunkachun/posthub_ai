import 'package:flutter/material.dart';

import 'app.dart';
import 'data/repositories/mock_post_repository_impl.dart';

void main() {
  runApp(App(repository: MockPostRepositoryImpl()));
}
