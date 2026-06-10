import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quick_app_alert/quick_app_alert.dart';

void main() {
  testWidgets('QuickAlert shows default title and message correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.success,
                    title: 'Test Success Title',
                    text: 'Test Success Message',
                  );
                },
                child: const Text('Show Alert'),
              );
            },
          ),
        ),
      ),
    );

    // Tap the button to trigger the alert
    await tester.tap(find.text('Show Alert'));
    await tester.pumpAndSettle(); // Wait for the transition to finish

    // Verify the contents of the alert are displayed
    expect(find.text('Test Success Title'), findsOneWidget);
    expect(find.text('Test Success Message'), findsOneWidget);
    expect(find.text('OK'), findsOneWidget); // Default confirmBtnText is 'OK'

    // Tap confirm to close the alert
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    // Verify the alert is dismissed
    expect(find.text('Test Success Title'), findsNothing);
  });

  testWidgets('QuickAlert default titles are used when not specified', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.warning,
                  );
                },
                child: const Text('Show Warning'),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Show Warning'));
    await tester.pumpAndSettle();

    // Verify that the default title for QuickAlertType.warning ('Warning') is used
    expect(find.text('Warning'), findsOneWidget);
  });

  testWidgets('QuickAlert automatically closes when autoClose is true', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.success,
                    title: 'Auto Dismissing Alert',
                    autoClose: true,
                    autoCloseDuration: const Duration(seconds: 1),
                  );
                },
                child: const Text('Show Auto Close'),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Show Auto Close'));
    await tester.pumpAndSettle();

    expect(find.text('Auto Dismissing Alert'), findsOneWidget);

    // Pump for 1 second auto-close duration
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle(); // Settle close transition animation

    expect(find.text('Auto Dismissing Alert'), findsNothing);
  });

  testWidgets('QuickAlert shows notification layout and auto-dismisses', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.success,
                    title: 'Notification Title',
                    text: 'Notification Message',
                    layout: QuickAlertLayout.notification,
                    autoClose: true,
                    autoCloseDuration: const Duration(seconds: 1),
                  );
                },
                child: const Text('Show Notification'),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Show Notification'));
    await tester.pump(); // Start transition

    expect(find.text('Notification Title'), findsOneWidget);
    expect(find.text('Notification Message'), findsOneWidget);

    // Pump for 1 second auto-close duration
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.text('Notification Title'), findsNothing);
  });
}
