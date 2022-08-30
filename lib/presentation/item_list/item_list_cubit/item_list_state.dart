import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/data/models/shopping_item.dart';

/// [ItemListState]
/// A State class for cubit

enum UiStatus { initial, loading, loaded, failure }

@immutable
class ItemListState extends Equatable {
  const ItemListState({
    this.uiStatus = UiStatus.initial,
    this.error,
    this.shoppingList,
  });

  ItemListState.empty()
      : uiStatus = UiStatus.loading,
        error = null,
        shoppingList = [];

  final UiStatus uiStatus;
  final String? error;
  final List<ShoppingItem>? shoppingList;

  ItemListState copyWith({
    UiStatus? uiStatus,
    String? error,
    List<ShoppingItem>? shoppingList,
  }) {
    return ItemListState(
      uiStatus: uiStatus ?? this.uiStatus,
      error: error ?? this.error,
      shoppingList: shoppingList ?? this.shoppingList,
    );
  }

  @override
  List<Object?> get props => [uiStatus, error, shoppingList];
}
