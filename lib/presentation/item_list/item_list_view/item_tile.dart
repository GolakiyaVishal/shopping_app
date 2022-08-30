import 'package:flutter/material.dart';
import 'package:shopping_app/data/models/shopping_item.dart';

/// [ItemTile]
/// A tile ui for list of shopping items
///

class ItemTile extends StatelessWidget {
  const ItemTile({
    super.key,
    required this.item,
    required this.onCheckChange,
    required this.onDeleteTap,
  });

  final ShoppingItem item;
  final void Function(bool) onCheckChange;
  final void Function() onDeleteTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: item.isSelected,
          onChanged: (value) {
            if (value != null) {
              onCheckChange(value);
            }
          },
        ),
        Expanded(
          child: Text(
            item.name,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  decoration: item.isSelected ?? false
                      ? TextDecoration.lineThrough
                      : null,
                ),
          ),
        ),
        IconButton(
          onPressed: onDeleteTap,
          icon: const Icon(Icons.delete),
        )
      ],
    );
  }
}
