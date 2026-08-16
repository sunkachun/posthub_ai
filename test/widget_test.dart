import 'package:flutter_test/flutter_test.dart';

import 'package:posthub_by_ai/app.dart';
import 'package:posthub_by_ai/data/repositories/mock_post_repository_impl.dart';

void main() {
  testWidgets('renders the PostHub post list', (WidgetTester tester) async {
    await tester.pumpWidget(App(repository: MockPostRepositoryImpl()));
    await tester.pump();

    expect(find.text('PostHub'), findsOneWidget);
  });
}
