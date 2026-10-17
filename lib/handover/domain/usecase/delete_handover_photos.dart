import '../repository/handover_photo_repository.dart';

class DeleteHandoverPhotos {
  final HandoverPhotoRepository _repository;

  DeleteHandoverPhotos(this._repository);

  Future<void> call(String id) {
    return _repository.deletePhoto(id);
  }
}
