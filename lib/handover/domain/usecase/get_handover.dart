
import '../repository/handover_repository.dart';

class GetHandover {
  final HandoverRepository _repository;

  GetHandover(this._repository);

  Future<void> call(String id) {
    return _repository.getHandoverById(id);
  }
}