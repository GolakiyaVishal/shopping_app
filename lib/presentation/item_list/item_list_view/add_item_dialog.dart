import 'package:flutter/material.dart';
import 'package:shopping_app/data/models/shopping_item.dart';
import 'package:shopping_app/l10n/l10n.dart';

Future<ShoppingItem?> showAddItemDialog(BuildContext context) {
  return showDialog<String>(
    context: context,
    builder: (context) => const AddNewItem(),
  ).then((value) {
    if (value != null) {
      debugPrint('add item :: $value');
      return ShoppingItem(name: value, isSelected: false);
    }
    return null;
  });
}

/// [AddNewItem]
/// Add new item dialog with TestField to enter text name

class AddNewItem extends StatelessWidget {
  const AddNewItem({super.key});

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();

    return AlertDialog(
      title: Text(context.l10n.addNewItemDialogTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: textController,
          ),
        ],
      ),
      actions: [
        // CANCEL button, not add item and remove the dialog
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(context.l10n.cancel.toUpperCase()),
        ),

        // ADD button, return item name and remove dialog
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(textController.text);
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.lightBlue),
          ),
          child: Text(
            context.l10n.add.toUpperCase(),
            style: Theme.of(context)
                .textTheme
                .button!
                .copyWith(color: Colors.black),
          ),
        ),
      ],
    );
  }
}
