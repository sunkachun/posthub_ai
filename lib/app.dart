import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/router/app_router.dart';
import 'domain/repositories/post_repository.dart';
import 'presentation/features/post/bloc/post_bloc.dart';

class App extends StatelessWidget {
  const App({super.key, required this.repository});

  final PostRepository repository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostBloc>(
      create: (_) => PostBloc(repository: repository),
      child: MaterialApp.router(
        title: 'PostHub',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routerConfig: AppRouter().router,
      ),
    );
  }
}
