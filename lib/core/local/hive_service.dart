import 'package:hive_flutter/hive_flutter.dart';
import 'package:proof_pack/handover/data/adapter/handover_model_adapter.dart';
import 'package:proof_pack/handover/data/adapter/handover_photo_model_adapter.dart';

import '../../handover/data/model/handover_model.dart';
import '../../handover/data/model/handover_photo_model.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(HandoverModelAdapter());
    await Hive.openBox<HandoverModel>('handovers');

    Hive.registerAdapter(HandoverPhotoModelAdapter());
    await Hive.openBox<HandoverPhotoModel>('handover_photos');
  }
}
