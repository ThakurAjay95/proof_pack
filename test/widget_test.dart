// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:proof_pack/handover/data/adapter/handover_model_adapter.dart';
import 'package:proof_pack/handover/data/adapter/handover_photo_model_adapter.dart';
import 'package:proof_pack/handover/data/model/handover_model.dart';
import 'package:proof_pack/handover/data/model/handover_photo_model.dart';

import 'package:proof_pack/main.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final tempDir = Directory.systemTemp.createTempSync();
    Hive.init(tempDir.path);

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(HandoverModelAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(HandoverPhotoModelAdapter());
    }

    if (!Hive.isBoxOpen('handovers')) {
      await Hive.openBox<HandoverModel>('handovers');
    }
    if (!Hive.isBoxOpen('handover_photos')) {
      await Hive.openBox<HandoverPhotoModel>('handover_photos');
    }
  });

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
     await tester.pumpWidget(const MyApp());
    //
    // // Verify that our counter starts at 0.
    // expect(find.text('0'), findsOneWidget);
    // expect(find.text('1'), findsNothing);
    //
    // // Tap the '+' icon and trigger a frame.
    // await tester.tap(find.byIcon(Icons.add));
    // await tester.pump();
    //
    // // Verify that our counter has incremented.
    // expect(find.text('0'), findsNothing);
    // expect(find.text('1'), findsOneWidget);
  });
}
