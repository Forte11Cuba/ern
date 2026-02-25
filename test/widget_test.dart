import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neurocognitive_risk/main.dart';
import 'package:neurocognitive_risk/core/constants/app_constants.dart';

void main() {
  testWidgets('App renders title', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: NeurocognitiveApp()));
    expect(find.text(AppConstants.appName), findsWidgets);
  });
}
