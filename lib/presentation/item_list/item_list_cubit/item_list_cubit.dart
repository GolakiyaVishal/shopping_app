import 'package:bloc/bloc.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shopping_app/data/models/shopping_item.dart';
import 'package:shopping_app/data/shopping_dao.dart';
import 'package:shopping_app/l10n/l10n.dart';
import 'package:shopping_app/presentation/item_list/item_list_state/item_list_state.dart';
import 'package:shopping_app/presentation/item_list/add_new_item/add_item_dialog.dart';
import 'package:shopping_app/utils/internet_connection.dart';

class ItemListCubit extends Cubit<ItemListState> {
  ItemListCubit(this.shoppingDao) : super(const ItemListState.empty()) {
    checkAndCall((){
      shoppingDao.getCommonShoppingListItemsIds().then((value) {
        debugPrint('getCommonShoppingListItemsIds:: $value');
        emit(
          state.copyWith(
            isLoading: false,
            isShowEmptyView: value == null,
          ),
        );
      });
    });
  }

  final ShoppingDao shoppingDao;

  // add new item in firebase db
  void addNewItem(BuildContext context, ShoppingItem item) {
    emit(state.copyWith(isLoading: true));
    checkAndCall(() {
      shoppingDao.addNewItem(item).then((value) {
        emit(
          state.copyWith(
            isLoading: false,
            isShowEmptyView: shoppingDao.getCartItems().isEmpty,
          ),
        );
      });
    });
  }

  // get streaming query to watch data from firebase db
  Query getAllShoppingItems() {
    return shoppingDao.getAllItems();
  }

  // action on shopping list item check box change
  // for the warning: check change only support nullable variable
  Future<String> onItemCheckChange({
    required bool value,
    required ShoppingItem item,
    required int index,
  }) async {
    emit(state.copyWith(isLoading: true));
    item.isSelected = value;
    final resp = await shoppingDao.updateItem(item, index);
    emit(state.copyWith(isLoading: false));
    return resp;
  }

  // delete shopping item
  Future<String?> onDeleteTap(int index) async {
    emit(state.copyWith(isLoading: true));
    final resp = await shoppingDao.deleteItem(index);

    emit(
      state.copyWith(
        isLoading: false,
        isShowEmptyView: shoppingDao.getCartItems().isEmpty,
      ),
    );

    return resp;
  }

  /// [onNewItemAddTap]
  /// action on add floating button tap
  void onNewItemAddTap(BuildContext context) {
    showAddItemDialog(context).then((value) {
      debugPrint('onNewItemAddTap :: $value');
      if (value != null) {
        addNewItem(context, value);
      }
    });
  }

  // check remaining shopping items
  void checkShoppingList(BuildContext context) {
    final item =
        shoppingDao.getCartItems().any((element) => !element.isSelected!);
    if (item) {
      Fluttertoast.showToast(msg: context.l10n.shoppingNotCompletedText);
    }
  }

  void checkAndCall(void Function() call){
    InternetConnection.check().then((value) {
      if (value) {
       call();
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            error: 'No internet connection, Please try again',
          ),
        );
      }
    });
  }
}
