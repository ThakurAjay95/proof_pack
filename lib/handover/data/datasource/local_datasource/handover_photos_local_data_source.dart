import 'package:hive/hive.dart';
import 'package:proof_pack/handover/data/model/handover_photo_model.dart';

import '../../../domain/entity/handover_photo_entity.dart';

class HandoverPhotosLocalDataSource {
  final Box<HandoverPhotoModel> box;

  HandoverPhotosLocalDataSource(this.box);

  Future<void> save(HandoverPhotoModel photo) async {
    await box.put(photo.id, photo);
  }

  Future<HandoverPhotoModel?> getById(String id) async {
    return box.get(id);
  }

  Future<List<HandoverPhotoModel>> getByHandoverId(String id) async {
    return box.values
        .where((HandoverPhotoModel photo) =>  photo.handoverId == id)
        .toList();
  }

  Future<List<HandoverPhotoModel>> getPendingPhotos(String id) async {
    return box.values
        .where(
          (HandoverPhotoModel photo) =>
              (photo.handoverId == id) &&
              (photo.syncStatus == HandoverPhotoSyncStatus.pending ||
                  photo.syncStatus == HandoverPhotoSyncStatus.failed),
        )
        .toList();
  }

  Future<void> delete(String id) async {
    return box.delete(id);
  }
}
