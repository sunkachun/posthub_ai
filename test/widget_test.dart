import 'package:flutter_test/flutter_test.dart';

import 'package:posthub_by_ai/app.dart';
import 'package:posthub_by_ai/data/repositories/mock_post_repository_impl.dart';
import 'package:posthub_by_ai/domain/repositories/bookmark_repository.dart';

class _FakeBookmarkRepository implements BookmarkRepository {
  @override
  Future<Set<int>> getBookmarkedPostIds() async => <int>{};

  @override
  Future<void> toggleBookmark(int postId) async {}
}

void main() {
  testWidgets('renders the PostHub post list', (WidgetTester tester) async {
    await tester.pumpWidget(
      App(
        postRepository: MockPostRepositoryImpl(),
        bookmarkRepository: _FakeBookmarkRepository(),
      ),
    );
    await tester.pump();

    expect(find.text('PostHub'), findsOneWidget);
  });
}
