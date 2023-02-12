import 'package:flutter_test/flutter_test.dart';

import 'package:quiz/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(App());

    expect(find.text('Hello world!'), findsOneWidget);
    expect(find.text('1'), findsNothing);
  });
}
