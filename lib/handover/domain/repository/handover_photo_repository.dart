
import 'package:proof_pack/handover/domain/entity/handover_photo_entity.dart';

abstract class HandoverPhotoRepository {

  Future<void> addPhoto(HandoverPhotoEntity photo);

  Future<List<HandoverPhotoEntity>> getPhotos(String handoverId);

  Future<void> deletePhoto(String photoId);
}