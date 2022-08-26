import 'package:flutter/material.dart';
import 'package:shopping_app/presentation/item_list/item_list_view/item_list_screen.dart';

/// [Routes]
/// A class to declare all the app routes

class Routes {
  Map<String, WidgetBuilder> getRoutes(BuildContext context) =>
      {ItemListScreen.routeName: (context) => const ItemListScreen()};
}
