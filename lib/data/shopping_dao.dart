import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_app/data/models/shopping_item.dart';

/// [ShoppingDao]
/// A data access object to communicate with firebase realtime database

class ShoppingDao {
  ShoppingDao() {
    _reference = FirebaseDatabase.instance.ref('common_shopping_list');

    // update item id list on item added to FDB
    _reference.onChildAdded.listen((event) {
      getCommonShoppingListItemsIds().then(_updateItemListAndIds);
    });

    // update Item id list on item remove from FDB
    _reference.onChildRemoved.listen((event) {
      getCommonShoppingListItemsIds().then(_updateItemListAndIds);
    });

    // update Item id list on item update from FDB
    _reference.onChildChanged.listen((event) {
      getCommonShoppingListItemsIds().then(_updateItemListAndIds);
    });
  }

  static const String dbUrl =
      'https://mobilab-shopping-app-default-rtdb.firebaseio.com/common_shopping_list';

  late DatabaseReference _reference;
  final Map<String, ShoppingItem> dataMap = {};
  final List<String> _itemIds = [];
  final List<ShoppingItem> _itemList = [];

  // add new item in database
  // @param: [ShoppingItem] required
  Future<String> addNewItem(ShoppingItem item) async {
    final response = await http
        .post(Uri.parse('$dbUrl.json'), body: jsonEncode(item.toJson()));

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final id = json['name']! as String;
    _itemIds.add(id);
    _itemList.add(item);
    return id;
  }

  // db reference to show all shopping item
  Query getAllItems() {
    return _reference;
  }

  // get list of all items auto generated ids
  // return two list of ids and list of item objects
  Future<List<dynamic>?> getCommonShoppingListItemsIds() async {
    final resp = await http.get(Uri.parse('$dbUrl.json'));

    final body = jsonDecode(resp.body);
    if(body != null) {
      final json = jsonDecode(resp.body) as Map<String, dynamic>;

      final idList = <String>[];
      final itemList = <ShoppingItem>[];

      json.forEach((key, value) {
        idList.add(key);
        itemList.add(ShoppingItem.fromJson(value as Map<String, dynamic>));
      });
      return [idList, itemList];
    }
    return null;
  }

  // update item property in fdb
  Future<String> updateItem(ShoppingItem item, int index) async {
    final response =  await http
        .patch(
      Uri.parse('$dbUrl/${_itemIds[index]}.json'),
      body: jsonEncode(item.toJson()),
    );

    debugPrint('updateItem:: ${response.body}');
    return response.body;
  }

  // delete item from firebase database
  Future<String?> deleteItem(int index) async {
    debugPrint('deleteItem : $dbUrl/${_itemIds[index]}.json');
    final response = await http.delete(Uri.parse('$dbUrl/${_itemIds[index]}.json'));
    _itemList.removeAt(index);
    _itemIds.removeAt(index);
    debugPrint('deleteItem : ${response.body}');
    return response.body;
  }

  // get Map of each item and auto generated key of realtime database
  Future<Map<String, ShoppingItem>?> getCommonShoppingList() async {
    final resp = await http.get(Uri.parse(dbUrl));

    final json = jsonDecode(resp.body) as Map<String, dynamic>;

    final returnable = json.map(
          (key, value) =>
          MapEntry(key, ShoppingItem.fromJson(value as Map<String, dynamic>)),
    );

    return returnable;
  }

  // update list of id and items on each action
  void _updateItemListAndIds(List<dynamic>? value){
    debugPrint('_updateItemListAndIds:: $value');
    _itemIds.clear();
    _itemList.clear();

    if (value != null) {
      _itemIds.addAll(value[0] as List<String>);
      _itemList.addAll(value[1] as List<ShoppingItem>);
    }
  }

  List<ShoppingItem> getCartItems() => _itemList;
}
