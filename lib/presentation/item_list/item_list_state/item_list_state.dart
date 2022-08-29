import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/data/models/shopping_item.dart';

/// [ItemListState]
/// A State class for cubit

@immutable
class ItemListState extends Equatable {
  const ItemListState({
    this.isLoading = false,
    this.error,
    this.shoppingList,
    this.isShowEmptyView = false,
  });

  const ItemListState.empty()
      : isLoading = true,
        error = null,
        shoppingList = null,
        isShowEmptyView = true;

  final bool isLoading;
  final String? error;
  final List<ShoppingItem>? shoppingList;
  final bool isShowEmptyView;

  ItemListState copyWith({
    bool? isLoading,
    String? error,
    List<ShoppingItem>? shoppingList,
    bool? isShowEmptyView,
  }) {
    return ItemListState(
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error,
        shoppingList: shoppingList ?? this.shoppingList,
        isShowEmptyView: isShowEmptyView ?? this.isShowEmptyView,
    );
  }

  @override
  List<Object?> get props => [isLoading, error, shoppingList];
}
