
import 'package:proof_pack/handover/data/model/handover_photo_model.dart';
import 'package:proof_pack/handover/domain/entity/handover_photo_entity.dart';

import '../../domain/repository/handover_photo_repository.dart';
import '../datasource/local_datasource/handover_photos_local_data_source.dart';

class HandoverPhotoRepositoryImpl implements HandoverPhotoRepository{
  final HandoverPhotosLocalDataSource _handoverPhotosLocalDataSource;

  HandoverPhotoRepositoryImpl(this._handoverPhotosLocalDataSource);


  @override
  Future<void> addPhoto(HandoverPhotoEntity photo) {
    final model = HandoverPhotoModel.fromEntity(photo);
    return _handoverPhotosLocalDataSource.save(model);
  }

  @override
  Future<void> deletePhoto(String photoId) {
   return _handoverPhotosLocalDataSource.delete(photoId);
  }

  @override
  Future<List<HandoverPhotoEntity>> getPhotos(String handoverId) async {
    final models = await _handoverPhotosLocalDataSource.getByHandoverId(handoverId);
    return models.map((models)=> models.toEntity()).toList();
  }

}