import 'package:flutter/material.dart';
import 'package:shopping_app/l10n/l10n.dart';
import 'package:shopping_app/presentation/item_list/item_list_view/add_item_dialog.dart';
import 'package:shopping_app/presentation/item_list/item_list_view/item_list_view.dart';

class ItemListScreen extends StatelessWidget {
  const ItemListScreen({super.key});

  static const String routeName = '/itemListScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.shoppingListAppBarTitle)),

      // FAB to add new item in the shopping list
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showAddItemDialog(context);
        },
        child: const Icon(Icons.add),
      ),
      body: const ItemListView(),
    );
  }
}
