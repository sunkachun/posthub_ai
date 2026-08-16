abstract class BookmarkRepository {
  Future<Set<int>> getBookmarkedPostIds();

  Future<void> toggleBookmark(int postId);
}
