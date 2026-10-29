import 'package:proof_pack/handover/domain/entity/handover_photo_entity.dart';
import 'package:proof_pack/handover/domain/repository/handover_photo_repository.dart';

class SaveHandoverPhoto {
  final HandoverPhotoRepository _repository;

  SaveHandoverPhoto(this._repository);

  Future<void> call(HandoverPhotoEntity photoRepository) {
    return _repository.addPhoto(photoRepository);
  }
}
