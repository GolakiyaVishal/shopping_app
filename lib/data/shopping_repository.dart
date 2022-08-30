import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_app/data/models/shopping_item.dart';

/// [ShoppingRepository]
/// A data access object to communicate with firebase realtime database

class ShoppingRepository {
  ShoppingRepository() {
    _reference = FirebaseDatabase.instance.ref('common_shopping_list');
  }

  static const String dbUrl =
      'https://mobilab-shopping-app-default-rtdb.firebaseio.com/common_shopping_list';

  late DatabaseReference _reference;

  // add new item in database
  Future<String> addNewItem(ShoppingItem item) async {
    final response = await http.post(
      Uri.parse('$dbUrl.json'),
      body: jsonEncode(item.toJson()),
    );

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final id = json['name']! as String;
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
    if (body != null) {
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
  Future<String> updateItem(ShoppingItem item, String itemId) async {
    final response = await http.patch(
      Uri.parse('$dbUrl/$itemId.json'),
      body: jsonEncode(item.toJson()),
    );

    debugPrint('updateItem:: ${response.body}');
    return response.body;
  }

  // delete item from firebase database
  Future<String> deleteItem(String itemId) async {
    final response =
        await http.delete(Uri.parse('$dbUrl/$itemId.json'));
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
}
