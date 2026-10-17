
import 'package:proof_pack/handover/domain/entity/handover_photo_entity.dart';
import 'package:proof_pack/handover/domain/repository/handover_photo_repository.dart';

class GetAllHandoversPhotos {
  final HandoverPhotoRepository _repository;

  GetAllHandoversPhotos(this._repository);

  Future<List<HandoverPhotoEntity>> call(String id) {
    return _repository.getPhotos(id);
  }
}