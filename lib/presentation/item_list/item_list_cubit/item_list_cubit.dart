import 'package:bloc/bloc.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shopping_app/data/models/shopping_item.dart';
import 'package:shopping_app/data/shopping_repository.dart';
import 'package:shopping_app/l10n/l10n.dart';
import 'package:shopping_app/presentation/item_list/add_new_item/add_item_dialog.dart';
import 'package:shopping_app/presentation/item_list/item_list_cubit/item_list_state.dart';
import 'package:shopping_app/utils/internet_connection.dart';

class ItemListCubit extends Cubit<ItemListState> {
  ItemListCubit(this.shoppingDao) : super(ItemListState.empty());

  final ShoppingRepository shoppingDao;
  final List<String> _itemIds = [];

  void getShoppingItems() {
    checkAndCall(() async {
      try {
        final resp = await shoppingDao.getCommonShoppingListItemsIds();
        if (resp != null) {
          final list = resp[0];
          if (list is List<String>) {
            _itemIds.addAll(list);
          }

          final list2 = resp[1];
          if (list2 is List<ShoppingItem>) {
            var l1 = state.shoppingList;
            if (l1 != null) {
              l1.addAll(list2);
            } else {
              l1 = list2;
            }

            emit(
              state.copyWith(
                uiStatus: UiStatus.loaded,
                // shoppingList: l1,
              ),
            );
          }
        } else {
          emit(
            state.copyWith(
              uiStatus: UiStatus.initial,
            ),
          );
        }
      } catch (exception) {
        onException(exception);
      }
    });
  }

  // add new item in firebase db
  void addNewItem(ShoppingItem item) {
    if (state.shoppingList?.any(
          (element) => element.name.toLowerCase() == item.name.toLowerCase(),
        ) ??
        false) {
      Fluttertoast.showToast(msg: 'Item already in cart');
      return;
    }

    emit(state.copyWith(uiStatus: UiStatus.loading));
    checkAndCall(() async {
      try {
        final id = await shoppingDao.addNewItem(item);
        _itemIds.add(id);
        var list = state.shoppingList;

        if (list == null) {
          list = [item];
        } else {
          list.add(item);
        }

        emit(
          state.copyWith(
            uiStatus: UiStatus.loaded,
            shoppingList: list,
          ),
        );
      } catch (exception) {
        onException(exception);
      }
    });
  }

  // get streaming query to watch data from firebase db
  Query getAllShoppingItems() {
    return shoppingDao.getAllItems();
  }

  // action on shopping list item check box change
  // for the warning: check change only support nullable variable
  Future<void> onItemCheckChange({
    required bool value,
    required ShoppingItem item,
    required int index,
  }) async {
    emit(state.copyWith(uiStatus: UiStatus.loading));
    item.isSelected = value;
    try {
      await shoppingDao.updateItem(item, _itemIds[index]);
      state.shoppingList?[index] = item;
      emit(
        state.copyWith(
          uiStatus: UiStatus.loaded,
          shoppingList: state.shoppingList,
        ),
      );
    } catch (exception) {
      onException(exception);
    }
  }

  // delete shopping item
  Future<void> onDeleteTap(int index) async {
    emit(state.copyWith(uiStatus: UiStatus.loading));
    try {
      await shoppingDao.deleteItem(_itemIds[index]);

      _itemIds.removeAt(index);
      state.shoppingList?.removeAt(index);

      emit(
        state.copyWith(
          uiStatus: _itemIds.isEmpty ? UiStatus.initial : UiStatus.loaded,
          shoppingList: state.shoppingList,
        ),
      );
    } catch (exception) {
      onException(exception);
    }
  }

  /// [onNewItemAddTap]
  /// action on add floating button tap
  void onNewItemAddTap(BuildContext context) {
    showAddItemDialog(context).then((value) {
      debugPrint('onNewItemAddTap :: $value');
      if (value != null) {
        addNewItem(value);
      }
    });
  }

  // check remaining shopping items
  void checkShoppingList(BuildContext context) {
    final item = state.shoppingList?.any((element) => !element.isSelected!);
    if (item ?? false) {
      Fluttertoast.showToast(msg: context.l10n.shoppingNotCompletedText);
    }
  }

  // before api call check for internet connection
  void checkAndCall(void Function() call) {
    InternetConnection.check().then((value) {
      if (value) {
        call();
      } else {
        emit(
          state.copyWith(
            uiStatus: UiStatus.failure,
            error: 'No internet connection, Please try again',
          ),
        );
      }
    });
  }

  // handle all exception and update screen state
  void onException(dynamic exception) {
    debugPrint('onException:: $onException');
    emit(
      state.copyWith(
        uiStatus: UiStatus.failure,
        error: exception.toString(),
      ),
    );
  }
}
