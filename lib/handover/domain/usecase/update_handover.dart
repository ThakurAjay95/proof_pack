import '../entity/handover_entity.dart';
import '../repository/handover_repository.dart';

class UpdateHandover {
  final HandoverRepository _repository;

  UpdateHandover(this._repository);

  Future<void> call(HandoverEntity handover) {
    return _repository.updateHandover(handover);
  }
}