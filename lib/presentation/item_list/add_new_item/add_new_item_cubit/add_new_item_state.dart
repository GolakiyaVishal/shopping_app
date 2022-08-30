import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AddNewItemState extends Equatable {
  const AddNewItemState({
    required this.canAddItem,
  });

  const AddNewItemState.empty() : canAddItem = false;

  final bool canAddItem;

  AddNewItemState copyWith({
    bool? showLoader,
    TextEditingController? titleController,
    bool? canAddItem,
  }) {
    return AddNewItemState(
      canAddItem: canAddItem ?? this.canAddItem,
    );
  }

  @override
  List<Object> get props => [canAddItem];
}
