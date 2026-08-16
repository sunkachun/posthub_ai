import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bookmark_bloc.dart';
import '../bloc/bookmark_event.dart';
import '../bloc/bookmark_state.dart';

class BookmarkButton extends StatelessWidget {
  const BookmarkButton({super.key, required this.postId});

  final int postId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookmarkBloc, BookmarkState>(
      builder: (context, state) {
        final isBookmarked = state.isBookmarked(postId);
        return IconButton(
          icon: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_border),
          color: isBookmarked ? Colors.amber : null,
          tooltip: isBookmarked ? 'Remove bookmark' : 'Add bookmark',
          onPressed: () =>
              context.read<BookmarkBloc>().add(ToggleBookmark(postId)),
        );
      },
    );
  }
}
