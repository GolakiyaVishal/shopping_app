import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shopping_app/data/models/shopping_item.dart';
import 'package:shopping_app/data/shopping_dao.dart';
import 'package:shopping_app/l10n/l10n.dart';
import 'package:shopping_app/presentation/item_list/item_list_cubit/item_list_cubit.dart';
import 'package:shopping_app/presentation/item_list/item_list_state/item_list_state.dart';
import 'package:shopping_app/presentation/item_list/item_list_view/empty_list_view.dart';
import 'package:shopping_app/presentation/item_list/item_list_view/item_tile.dart';
import 'package:shopping_app/presentation/widgets/small_loader.dart';

class ItemListScreen extends StatelessWidget {
  const ItemListScreen({super.key});

  static const String routeName = '/itemListScreen';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ItemListCubit(ShoppingDao()),
      child: const ScreenContent(),
    );
  }
}

class ScreenContent extends StatelessWidget {
  const ScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.shoppingListAppBarTitle),
        actions: [
          if (context.watch<ItemListCubit>().state.isLoading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SmallLoader(),
            ),
          if (!context.watch<ItemListCubit>().state.isLoading
              && !context.watch<ItemListCubit>().state.isShowEmptyView)
            TextButton(
              onPressed: () =>
                  context.read<ItemListCubit>().checkShoppingList(context),
              child: Text(
                context.l10n.checkButtonText,
                style: Theme.of(context).textTheme.button?.copyWith(
                      color: Colors.black,
                    ),
              ),
            )
        ],
      ),

      // FAB to add new item in the shopping list
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<ItemListCubit>().onNewItemAddTap(context),
        child: const Icon(Icons.add),
      ),

      body: BlocBuilder<ItemListCubit, ItemListState>(
        builder: (context, itemListState) {

          // for any error show error dialog
          if (itemListState.error != null) {
            Fluttertoast.showToast(
                msg: itemListState.error ?? context.l10n.commonErrorText,);
            // showErrorDialog(
            //   context: context,
            //   errorText: itemListState.error ?? context.l10n.commonErrorText,
            // );
          }

          // if item is not available then show the empty view
          if (context.watch<ItemListCubit>().state.isShowEmptyView) {
            return const EmptyListView();
          }

          return FirebaseAnimatedList(
            query: context.watch<ItemListCubit>().getAllShoppingItems(),
            defaultChild: const EmptyListView(),
            itemBuilder: (context, snapshot, animation, index) {
              debugPrint('snapshot :: ${snapshot.value}');

              final json = snapshot.value! as Map<dynamic, dynamic>;
              final item = ShoppingItem.fromJson(json);

              return ItemTile(
                key: UniqueKey(),
                item: item,
                onCheckChange: (value) =>
                    context.read<ItemListCubit>().onItemCheckChange(
                          value: value,
                          item: item,
                          index: index,
                        ),
                onDeleteTap: () =>
                    context.read<ItemListCubit>().onDeleteTap(index),
              );
            },
          );
        },
      ),
    );
  }
}
