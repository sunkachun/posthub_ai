import 'package:equatable/equatable.dart';

class BookmarkState extends Equatable {
  const BookmarkState({this.bookmarkedIds = const {}});

  final Set<int> bookmarkedIds;

  bool isBookmarked(int postId) => bookmarkedIds.contains(postId);

  BookmarkState copyWith({Set<int>? bookmarkedIds}) {
    return BookmarkState(bookmarkedIds: bookmarkedIds ?? this.bookmarkedIds);
  }

  @override
  List<Object?> get props => [bookmarkedIds];
}
