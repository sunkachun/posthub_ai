import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/error_retry_view.dart';
import '../../../../core/widgets/post_image.dart';
import '../../../../domain/entities/comment.dart';
import '../../../../domain/entities/post.dart';
import '../bloc/post_bloc.dart';
import '../bloc/post_event.dart';
import '../bloc/post_state.dart';

class PostDetailScreen extends StatefulWidget {
  const PostDetailScreen({super.key, required this.post});

  final PostEntity post;

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PostBloc>().add(PostCommentsFetched(widget.post.id));
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final textTheme = Theme.of(context).textTheme;
    final initial = post.author.name.isNotEmpty
        ? post.author.name[0].toUpperCase()
        : '?';

    return Scaffold(
      appBar: AppBar(title: const Text('Post')),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          PostImage(seed: '${post.id}', width: double.infinity, height: 220),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(post.title, style: textTheme.headlineSmall),
                const SizedBox(height: 16),
                Row(
                  children: [
                    CircleAvatar(child: Text(initial)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(post.author.name, style: textTheme.titleMedium),
                          Text(
                            '@${post.author.username}',
                            style: textTheme.bodySmall,
                          ),
                          Text(post.author.email, style: textTheme.bodySmall),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(post.body, style: textTheme.bodyLarge),
                const SizedBox(height: 24),
                Text('Comments', style: textTheme.titleLarge),
                const SizedBox(height: 8),
                BlocBuilder<PostBloc, PostState>(
                  builder: (context, state) {
                    return switch (state.commentsStatus) {
                      PostStatus.initial || PostStatus.loading => const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      PostStatus.failure => ErrorRetryView(
                        message:
                            state.commentsErrorMessage ??
                            'Something went wrong',
                        onRetry: () => context.read<PostBloc>().add(
                          PostCommentsFetched(widget.post.id),
                        ),
                      ),
                      PostStatus.success =>
                        state.comments.isEmpty
                            ? const Padding(
                                padding: EdgeInsets.symmetric(vertical: 24),
                                child: Center(child: Text('No comments yet')),
                              )
                            : Column(
                                children: [
                                  for (final comment in state.comments)
                                    _CommentTile(comment: comment),
                                ],
                              ),
                    };
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CommentTile extends StatelessWidget {
  const _CommentTile({required this.comment});

  final CommentEntity comment;

  @override
  Widget build(BuildContext context) {
    final initial = comment.name.isNotEmpty
        ? comment.name[0].toUpperCase()
        : '?';
    return ListTile(
      leading: CircleAvatar(child: Text(initial)),
      title: Text(comment.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(comment.email, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 4),
          Text(comment.body),
        ],
      ),
    );
  }
}
