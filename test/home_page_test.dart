import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:poultry_login_signup/main.dart';
import 'package:poultry_login_signup/providers/apicalls.dart';

void main() {
  testWidgets('', (WidgetTester tester) async {
    Widget makeTestableWidget({required Widget child}) {
      return MaterialApp(
        home: child,
      );
    }

    // Build our app and trigger a frame.
    await tester.pumpWidget(makeTestableWidget(child: MyHomePage()));

    // await tester.tap(find.byKey(const Key('Log In')));

    // // Verify that our counter starts at 0.
    // expect(find.text('0'), findsOneWidget);
    // expect(find.text('1'), findsNothing);

    // // Tap the '+' icon and trigger a frame.
    // await tester.tap(find.byIcon(Icons.add));
    // await tester.pump();

    // // Verify that our counter has incremented.
    // expect(find.text('0'), findsNothing);
    // expect(find.text('1'), findsOneWidget);
  });
}
