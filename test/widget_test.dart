import 'package:flutter_test/flutter_test.dart';
import 'package:tugas1/main.dart';

void main() {
  testWidgets('MyApp builds and displays', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.byType(MyApp), findsOneWidget);
  });
}
