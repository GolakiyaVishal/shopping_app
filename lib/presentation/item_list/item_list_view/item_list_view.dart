import 'package:flutter/material.dart';
import 'package:shopping_app/data/models/shopping_item.dart';
import 'package:shopping_app/presentation/item_list/item_list_view/item_tile.dart';

/// [ItemListView]
/// A List of shopping items

class ItemListView extends StatelessWidget {
  const ItemListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) => ItemTile(
        key: UniqueKey(),
        item: ShoppingItem(isSelected: false, name: 'Item name'),
      ),
      separatorBuilder: (context, index) => const Divider(),
      itemCount: 10,
    );
  }
}
