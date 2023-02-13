import 'package:flutter_test/flutter_test.dart';

import 'package:quiz/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(App());

    expect(find.text('My First App'), findsOneWidget);
    expect(find.text('This is my default text!'), findsOneWidget);
    expect(find.text('1'), findsNothing);
  });
}
