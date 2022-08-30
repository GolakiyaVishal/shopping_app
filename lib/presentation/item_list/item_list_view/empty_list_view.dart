import 'package:flutter/material.dart';
import 'package:shopping_app/l10n/l10n.dart';

/// [EmptyListView]
/// this view show when the shopping list is empty

class EmptyListView extends StatelessWidget {
  const EmptyListView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      alignment: Alignment.center,
      constraints: BoxConstraints(
        maxHeight: size.height * 0.8,
        maxWidth: size.height * 0.8,
        minWidth: size.height * 0.8,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            context.l10n.emptyListText,
            style: textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Text(
            context.l10n.addNewItemInstruction,
            textAlign: TextAlign.center,
            style: textTheme.bodySmall!.copyWith(
              color: Colors.black54,
            ),
          )
        ],
      ),
    );
  }
}
