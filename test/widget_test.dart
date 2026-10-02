import 'package:flutter_test/flutter_test.dart';

import 'package:adv_calculator/main.dart';

void main() {
  testWidgets('Calculator app loads smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const AdvCalculatorApp());

    // Verify OMNI_CALC branding / title is present
    expect(find.text('OMNI_CALC'), findsNWidgets(2));
  });
}
