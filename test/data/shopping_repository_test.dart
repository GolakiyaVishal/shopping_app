import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/firebase_app.dart';

void main() {
  setupFirebaseDatabaseMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  group('Shopping Repository test', () {

    const secondDb =
    'https://mobilab-shopping-app-default-rtdb.firebaseio.com/common_shopping_list';

    test('ensure databaseUrl is correct', () {
      final shared = FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL: secondDb,
      );

      expect(shared.databaseURL, secondDb);
    });

    test(
        'ensure databaseUrl has "/" removed on FirebaseDatabase initialisation',
        () {
      final shared = FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        // add forward slash to end
        databaseURL: '$secondDb/',
      );

      expect(shared.databaseURL, secondDb);
    });
  });
}
