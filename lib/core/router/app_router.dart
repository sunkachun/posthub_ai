import 'package:go_router/go_router.dart';

import '../../domain/entities/post.dart';
import '../../presentation/features/post/view/post_detail_screen.dart';
import '../../presentation/features/post/view/post_list_screen.dart';

class AppRouter {
  final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const PostListScreen(),
        routes: [
          GoRoute(
            path: 'post/:id',
            builder: (context, state) {
              final post = state.extra! as PostEntity;
              return PostDetailScreen(post: post);
            },
          ),
        ],
      ),
    ],
  );
}
