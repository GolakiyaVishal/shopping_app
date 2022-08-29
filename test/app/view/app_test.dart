import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopping_app/app/app.dart';
import 'package:shopping_app/presentation/item_list/item_list_view/item_list_screen.dart';

import '../../helpers/firebase_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseDatabaseMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  group('App', () {
    testWidgets('renders ItemListPage', (tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(ItemListScreen), findsOneWidget);
    });
  });
}
