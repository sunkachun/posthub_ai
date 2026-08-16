import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/widgets/error_retry_view.dart';
import '../../../../core/widgets/post_image.dart';
import '../../../../domain/entities/post.dart';
import '../../bookmark/view/bookmark_button.dart';
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
    final state = context.read<PostBloc>().state;
    if (state.isLoadingMore || !state.hasMore) return;
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
            return const _PostListShimmer();
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

class _PostListShimmer extends StatelessWidget {
  const _PostListShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 8,
        itemBuilder: (context, index) => const _PostTileShimmer(),
      ),
    );
  }
}

class _PostTileShimmer extends StatelessWidget {
  const _PostTileShimmer();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _ShimmerBox(width: 40, height: 40, borderRadius: 20),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ShimmerBox(height: 16),
                SizedBox(height: 8),
                _ShimmerBox(height: 12, width: 120),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  const _ShimmerBox({this.width, this.height = 16, this.borderRadius = 8});

  final double? width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

class _PostTile extends StatelessWidget {
  const _PostTile({required this.post});

  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: PostImage(
        seed: '${post.id}',
        width: 56,
        height: 56,
        borderRadius: 8,
      ),
      title: Text(post.title, maxLines: 2, overflow: TextOverflow.ellipsis),
      subtitle: Text('${post.author.name} (@${post.author.username})'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          BookmarkButton(postId: post.id),
          const Icon(Icons.chevron_right),
        ],
      ),
      onTap: () => context.push('/post/${post.id}', extra: post),
    );
  }
}
