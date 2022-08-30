import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shopping_app/data/models/shopping_item.dart';
import 'package:shopping_app/data/shopping_repository.dart';
import 'package:shopping_app/presentation/item_list/item_list_cubit/item_list_cubit.dart';
import 'package:shopping_app/presentation/item_list/item_list_cubit/item_list_state.dart';

import '../../../helpers/firebase_app.dart';

// mock ShoppingDao class
class MockShoppingDao extends Mock implements ShoppingRepository {}

// mock ItemListCubit class
class MockItemListCubit extends MockCubit<ItemListState>
    implements ItemListCubit {}

// mock BuildContext
class MockBuildContext extends Mock implements BuildContext {}

void main() {
  setupFirebaseDatabaseMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  group('ItemListCubit Test', () {
    late ShoppingRepository shoppingDao;
    late ItemListCubit itemListCubit;

    final shoppingItem = ShoppingItem(name: 'Test Item');
    final itemList = <ShoppingItem>[shoppingItem];

    setUp(() {
      shoppingDao = MockShoppingDao();
      itemListCubit = MockItemListCubit();
      when(() => shoppingDao.addNewItem(shoppingItem))
          .thenAnswer((invocation) => Future.value('UID'));

      when(() => shoppingDao.updateItem(shoppingItem, 'UID'))
          .thenAnswer((invocation) => Future.value('UID'));

      when(
        () => itemListCubit.onItemCheckChange(
          value: true,
          item: shoppingItem,
          index: 0,
        ),
      ).thenAnswer(
        (invocation) async => Future<void>.value(),
      );
    });

    test('initial state of shopping item', () async {
      expect(
        ItemListCubit(shoppingDao).state,
        ItemListState.empty(),
      );
    });

    blocTest<ItemListCubit, ItemListState>(
      'emits non when addNewItem is called',
      build: MockItemListCubit.new,
      act: (cubit) => cubit.addNewItem(ShoppingItem(name: 'Potato')),
      expect: () => [],
    );

    // blocTest<ItemListCubit, ItemListState>(
    //   'emits non when updateItem is called',
    //   build: () => itemListCubit,
    //   act: (cubit) => cubit.onItemCheckChange(
    //     value: false,
    //     item: ShoppingItem(name: 'Potato'),
    //     index: 0,
    //   ),
    //   expect: () => [],
    // );

    // blocTest<ItemListCubit, ItemListState>(
    //   'emits non when deleteItem is called',
    //   build: MockItemListCubit.new,
    //   act: (cubit) => cubit.onDeleteTap(0),
    //   expect: () => [],
    // );
  });
}
