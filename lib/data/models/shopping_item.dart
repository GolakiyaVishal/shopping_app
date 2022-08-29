import 'package:equatable/equatable.dart';

/// [ShoppingItem]
/// A shopping item model class

class ShoppingItem extends Equatable {
  ShoppingItem({required this.name, this.isSelected});

  ShoppingItem.fromJson(Map<dynamic, dynamic> json)
      : name = json['name'] as String {
    if (json['isSelected'] != null) {
      isSelected = json['isSelected'] as bool;
    }
  }

  String name;
  bool? isSelected;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['isSelected'] = isSelected;
    return data;
  }

  @override
  List<Object> get props => [name];

  @override
  String toString() => {'name': name, 'isSelected': isSelected}.toString();
}
