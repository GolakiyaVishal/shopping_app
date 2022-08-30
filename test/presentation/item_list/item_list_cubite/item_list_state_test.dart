import 'package:flutter_test/flutter_test.dart';
import 'package:shopping_app/presentation/item_list/item_list_cubit/item_list_state.dart';

void main() {
  group('CrewState', () {
    test('supports value comparison', () {
      expect(
        const ItemListState(
          shoppingList: [],
        ),
        const ItemListState(
          shoppingList: [],
        ),
      );
    });
  });
}
