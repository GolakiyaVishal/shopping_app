import 'package:flutter_test/flutter_test.dart';
import 'package:shopping_app/app/app.dart';
import 'package:shopping_app/presentation/item_list/item_list_view/item_list_screen.dart';

void main() {
  group('App', () {
    testWidgets('renders CounterPage', (tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(ItemListScreen), findsOneWidget);
    });
  });
}
