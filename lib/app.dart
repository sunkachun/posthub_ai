import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/router/app_router.dart';
import 'domain/repositories/bookmark_repository.dart';
import 'domain/repositories/post_repository.dart';
import 'presentation/features/bookmark/bloc/bookmark_bloc.dart';
import 'presentation/features/bookmark/bloc/bookmark_event.dart';
import 'presentation/features/post/bloc/post_bloc.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    required this.postRepository,
    required this.bookmarkRepository,
  });

  final PostRepository postRepository;
  final BookmarkRepository bookmarkRepository;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PostBloc>(
          create: (_) => PostBloc(repository: postRepository),
        ),
        BlocProvider<BookmarkBloc>(
          create: (_) => BookmarkBloc(repository: bookmarkRepository)
            ..add(const LoadBookmarks()),
        ),
      ],
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
