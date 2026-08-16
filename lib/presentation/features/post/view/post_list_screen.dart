import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/error_retry_view.dart';
import '../../../../domain/entities/post.dart';
import '../bloc/post_bloc.dart';
import '../bloc/post_event.dart';
import '../bloc/post_state.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<PostBloc>().add(const PostFetched());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.extentAfter < 400) {
      context.read<PostBloc>().add(const PostLoadMore());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PostHub')),
      body: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          if (state.status == PostStatus.initial ||
              (state.status == PostStatus.loading && state.posts.isEmpty)) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == PostStatus.failure && state.posts.isEmpty) {
            return ErrorRetryView(
              message: state.errorMessage ?? 'Something went wrong',
              onRetry: () => context.read<PostBloc>().add(const PostFetched()),
            );
          }

          if (state.posts.isEmpty) {
            return const Center(child: Text('No posts yet'));
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<PostBloc>().add(const PostFetched());
            },
            child: ListView.separated(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: state.posts.length + (state.isLoadingMore ? 1 : 0),
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                if (index >= state.posts.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                return _PostTile(post: state.posts[index]);
              },
            ),
          );
        },
      ),
    );
  }
}

class _PostTile extends StatelessWidget {
  const _PostTile({required this.post});

  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    final initial =
        post.author.name.isNotEmpty ? post.author.name[0].toUpperCase() : '?';
    return ListTile(
      leading: CircleAvatar(child: Text(initial)),
      title: Text(post.title, maxLines: 2, overflow: TextOverflow.ellipsis),
      subtitle: Text('${post.author.name} (@${post.author.username})'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => context.push('/post/${post.id}', extra: post),
    );
  }
}
