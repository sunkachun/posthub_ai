import 'package:equatable/equatable.dart';

sealed class BookmarkEvent extends Equatable {
  const BookmarkEvent();

  @override
  List<Object?> get props => const [];
}

class LoadBookmarks extends BookmarkEvent {
  const LoadBookmarks();
}

class ToggleBookmark extends BookmarkEvent {
  const ToggleBookmark(this.postId);

  final int postId;

  @override
  List<Object?> get props => [postId];
}
