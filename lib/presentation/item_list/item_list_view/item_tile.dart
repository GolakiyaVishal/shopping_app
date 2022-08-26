import 'package:flutter/material.dart';
import 'package:shopping_app/data/models/shopping_item.dart';

class ItemTile extends StatelessWidget {
  const ItemTile({super.key, required this.item});

  final ShoppingItem item;

  @override
  Widget build(BuildContext context) {
    var isSelected = item.isSelected;
    return Row(
      children: [
        Checkbox(value: isSelected, onChanged: (value){
          isSelected = value!;
          debugPrint('value changed: $value');
        },),
        Text(item.name)
      ],
    );
  }
}
