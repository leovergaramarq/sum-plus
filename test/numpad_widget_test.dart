import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uninorte_mobile_class_project/ui/widgets/numpad_widget.dart';

void main() {
  testWidgets('NumpadWidget should handle button clicks',
      (WidgetTester tester) async {
    int typedNumber = -1;
    bool cleared = false;
    bool answered = false;

    await tester.pumpWidget(
      MaterialApp(
        home: NumpadWidget(
          typeNumber: (number) {
            typedNumber = number;
          },
          clearAnswer: () {
            cleared = true;
          },
          answer: () {
            answered = true;
          },
        ),
      ),
    );

    await tester.tap(find.text('1'));
    await tester.pump();
    expect(typedNumber, 1);

    await tester.tap(find.text('7'));
    await tester.pump();
    expect(typedNumber, 1);

    await tester.tap(find.text('C'));
    await tester.pump();
    expect(cleared, isTrue);

    await tester.tap(find.text('GO'));
    await tester.pump();
    expect(answered, isTrue);
  });
}
