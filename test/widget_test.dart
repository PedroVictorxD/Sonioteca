import 'package:flutter_test/flutter_test.dart';
import 'package:sonioteca/main.dart';

void main() {
  testWidgets('App renders', (WidgetTester tester) async {
    await tester.pumpWidget(const SoniotecaApp());
    expect(find.text('Sonioteca'), findsOneWidget);
  });
}