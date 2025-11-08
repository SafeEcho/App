import 'package:echomimi/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('smoke test EchoMimi app', (tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const EchomimiApp());

    // Wait for the loading screen to finish
    await tester.pumpAndSettle();

    // Verify that key elements are shown
    expect(find.text('ECHOMIMI'), findsWidgets);
  });
}
