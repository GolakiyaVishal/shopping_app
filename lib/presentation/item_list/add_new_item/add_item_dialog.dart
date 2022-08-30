import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/data/models/shopping_item.dart';
import 'package:shopping_app/l10n/l10n.dart';
import 'package:shopping_app/presentation/item_list/add_new_item/add_new_item_cubit/add_new_item_cubit.dart';

Future<ShoppingItem?> showAddItemDialog(BuildContext context) {
  return showDialog<String>(
    context: context,
    builder: (context) => const AddNewItem(),
  ).then((value) {
    if (value != null) {
      final str = value;
      if (str.isNotEmpty) {
        debugPrint('add item :: $value');
        return ShoppingItem(
          name: str,
          isSelected: false,
        );
      }
    }
    return null;
  });
}

/// [AddNewItem]
/// Add new item dialog with TestField to enter sopping item name
///
/// Reason for stateful widget:
/// According to suggested in bloc library, beast place to create a
/// controller is initState of widget.

class AddNewItem extends StatelessWidget {
  const AddNewItem({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddNewItemCubit(),
      child: const _DialogContent(),
    );
  }
}

class _DialogContent extends StatefulWidget {
  const _DialogContent();

  @override
  State<_DialogContent> createState() => _DialogContentState();
}

class _DialogContentState extends State<_DialogContent> {
  TextEditingController titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    titleController.addListener(() {
      context.read<AddNewItemCubit>().updateAddButton(titleController.text);
    });
  }

  @override
  void deactivate() {
    super.deactivate();
    titleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.l10n.addNewItemDialogTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: context.l10n.addItemInputLabel,
              ),
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
          onPressed: context.watch<AddNewItemCubit>().state.canAddItem
              ? () {
                  Navigator.of(context).pop(
                    titleController.text,
                  );
                }
              : null,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.disabled)) {
                return Colors.black38;
              }
              return Colors.lightBlue;
            }),
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
