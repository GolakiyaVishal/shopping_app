import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopping_app/presentation/item_list/item_list_view/item_list_screen.dart';

import '../../../helpers/helpers.dart';

void main() {
  group('Shopping list page test', () {
    testWidgets('Render shopping list test', (widgetTester) async {
      await widgetTester.pumpApp(const ItemListScreen());
      expect(find.byType(ItemListScreen), findsOneWidget);
    });

    testWidgets('Add new item render test', (widgetTester) async {
      await widgetTester.pumpApp(const ItemListScreen());
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    // TODO(Vishal): correct the dialog test
    testWidgets(
        'Add new item tap and add item dialog test', (widgetTester) async {
        await widgetTester.pumpApp(const ItemListScreen());
        await widgetTester.tap(find.byIcon(Icons.add));
        // expect(find.byType(TextField), findsOneWidget);
        expect(find.text('ADD'), findsOneWidget);
        expect(find.text('CANCEL'), findsOneWidget);
    });
  });
}
