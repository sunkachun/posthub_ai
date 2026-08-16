import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repositories/bookmark_repository.dart';

class BookmarkRepositoryImpl implements BookmarkRepository {
  BookmarkRepositoryImpl({required SharedPreferences preferences})
      : _preferences = preferences;

  static const String _storageKey = 'bookmarked_posts';

  final SharedPreferences _preferences;

  @override
  Future<Set<int>> getBookmarkedPostIds() async {
    final ids = _preferences.getStringList(_storageKey) ?? const [];
    return ids.map(int.parse).toSet();
  }

  @override
  Future<void> toggleBookmark(int postId) async {
    final ids = _preferences.getStringList(_storageKey) ?? const [];
    final bookmarked = List<String>.from(ids);
    final key = postId.toString();
    if (bookmarked.contains(key)) {
      bookmarked.remove(key);
    } else {
      bookmarked.add(key);
    }
    await _preferences.setStringList(_storageKey, bookmarked);
  }
}
